/*! \file mpiramsesio.cxx
 *  \brief this file contains routines used with MPI compilation and ramses io and domain construction.
 */

#ifdef USEMPI

//-- For MPI

#include "stf.h"

#include "ramsesitems.h"
#include "endianutils.h"

/// \name RAMSES Domain decomposition
//@{

/*!
    Determine the domain decomposition.\n
    Here the domains are constructured in data units
    only ThisTask==0 should call this routine. It is tricky to get appropriate load balancing and correct number of particles per processor.\n

    I could use recursive binary splitting like kd-tree along most spread axis till have appropriate number of volumes corresponding
    to number of processors.

    NOTE: assume that cannot store data so position information is read Nsplit times to determine boundaries of subvolumes
    could also randomly subsample system and produce tree from that
    should store for each processor the node structure generated by the domain decomposition
    what I could do is read file twice, one to get extent and other to calculate entropy then decompose
    along some primary axis, then choose orthogonal axis, keep iterating till have appropriate number of subvolumes
    then store the boundaries of the subvolume. this means I don't store data but get at least reasonable domain decomposition

    NOTE: pkdgrav uses orthoganal recursive bisection along with kd-tree, gadget-2 uses peno-hilbert curve to map particles and oct-trees
    the question with either method is guaranteeing load balancing. for ORB achieved by splitting (sub)volume along a dimension (say one with largest spread or max entropy)
    such that either side of the cut has approximately the same number of particles (ie: median splitting). But for both cases, load balancing requires particle information
    so I must load the system then move particles about to ensure load balancing.

    Main thing first is get the dimensional extent of the system.
    then I could get initial splitting just using mid point between boundaries along each dimension.
    once have that initial splitting just load data then start shifting data around.
*/

void MPIDomainExtentRAMSES(Options &opt){
    Int_t i;
    char buf[2000];
    fstream Framses;
    RAMSES_Header ramses_header_info;
    string stringbuf;
    if (ThisTask==0) {
    sprintf(buf,"%s/info_%s.txt",opt.fname,opt.ramsessnapname);
    Framses.open(buf, ios::in);
    getline(Framses,stringbuf);
    getline(Framses,stringbuf);
    getline(Framses,stringbuf);
    getline(Framses,stringbuf);
    getline(Framses,stringbuf);
    getline(Framses,stringbuf);
    getline(Framses,stringbuf);
    Framses>>stringbuf>>stringbuf>>ramses_header_info.BoxSize;
    Framses>>stringbuf>>stringbuf>>ramses_header_info.time;
    Framses>>stringbuf>>stringbuf>>ramses_header_info.aexp;
    Framses>>stringbuf>>stringbuf>>ramses_header_info.HubbleParam;
    Framses>>stringbuf>>stringbuf>>ramses_header_info.Omegam;
    Framses>>stringbuf>>stringbuf>>ramses_header_info.OmegaLambda;
    Framses>>stringbuf>>stringbuf>>ramses_header_info.Omegak;
    Framses>>stringbuf>>stringbuf>>ramses_header_info.Omegab;
    Framses>>stringbuf>>stringbuf>>ramses_header_info.scale_l;
    Framses>>stringbuf>>stringbuf>>ramses_header_info.scale_d;
    Framses>>stringbuf>>stringbuf>>ramses_header_info.scale_t;
    Framses.close();
    ///note that code units are 0 to 1
    for (int j=0;j<3;j++) {mpi_xlim[j][0]=0;mpi_xlim[j][1]=1.0;}

    //There may be issues with particles exactly on the edge of a domain so before expanded limits by a small amount
    //now only done if a specific compile option passed
#ifdef MPIEXPANDLIM
    for (int j=0;j<3;j++) {
        Double_t dx=0.001*(mpi_xlim[j][1]-mpi_xlim[j][0]);
        mpi_xlim[j][0]-=dx;mpi_xlim[j][1]+=dx;
    }
#endif
    }

    //make sure limits have been found
    MPI_Barrier(MPI_COMM_WORLD);
    if (NProcs==1) {
        for (i=0;i<3;i++) {
            mpi_domain[ThisTask].bnd[i][0]=mpi_xlim[i][0];
            mpi_domain[ThisTask].bnd[i][1]=mpi_xlim[i][1];
        }
    }
}

void MPIDomainDecompositionRAMSES(Options &opt){
#define SKIP2 Fgad[i].read((char*)&dummy, sizeof(dummy));
    Int_t i,j,k,n,m;
    int Nsplit,isplit;

    if (ThisTask==0) {
    }
}

///reads a gadget file to determine number of particles in each MPIDomain
///\todo need to add code to read gas cell positions and send them to the appropriate mpi thead
void MPINumInDomainRAMSES(Options &opt)
{

    if (NProcs > 1)
    {
        MPIDomainExtentRAMSES(opt);
	long long nbodies = ReadHeader(opt);
        //MPIInitialDomainDecomposition();
        MPIDomainDecompositionRAMSES(opt);
        Int_t i,j,k,n,m,temp,Ntot,indark,ingas,instar;
        int idim,ivar,igrid;
        Int_t idval;
        int   typeval;
        long long Nlocalold=Nlocal;
        RAMSESFLOAT xtemp[3], ageval;
        Double_t mtemp;
        MPI_Status status;
        Int_t Nlocalbuf,ibuf=0,*Nbuf, *Nbaryonbuf;
        int *ngridlevel,*ngridbound,*ngridfile;
        int lmin=1000000,lmax=0;

        char buf[2000],buf1[2000],buf2[2000];
        string stringbuf,orderingstring;
        fstream Finfo;
        fstream *Fpart, *Fpartmass, *Fpartage, *Fpartfam, *Famr, *Fhydro;
        fstream  Framses;
        RAMSES_Header *header;
        int intbuff[NRAMSESTYPE];
        long long longbuff[NRAMSESTYPE];
        Int_t count2,bcount2;
        int dummy,byteoffset;
        Int_t chunksize = opt.inputbufsize, nchunk;
        RAMSESFLOAT *xtempchunk, *mtempchunk, *agetempchunk;
	RAMSESFLOAT *xtempall, *xtempX, *xtempY, *xtempZ, *xtempTMP;
	RAMSESFLOAT **xtempA, **xtempA2;
	int *famtempall;
	char *dummy_family2;
	int * dummy_family;

        int *icellchunk;
        Fpart      = new fstream[opt.num_files];
        Fpartmass  = new fstream[opt.num_files];
        Fpartage   = new fstream[opt.num_files];
	Fpartfam   = new fstream[opt.num_files];
        Famr       = new fstream[opt.num_files];
        Fhydro     = new fstream[opt.num_files];
        header     = new RAMSES_Header[opt.num_files];
        double dmp_mass,OmegaM, OmegaB;
        int n_out_of_bounds = 0;
        long long ndark  = 0;
        long long nstar  = 0;
        int nghost = 0;
        int *ireadfile,*ireadtask,*readtaskID;
        ireadtask=new int[NProcs];
        readtaskID=new int[opt.nsnapread];
        ireadfile=new int[opt.num_files];
        MPIDistributeReadTasks(opt,ireadtask,readtaskID);
        MPISetFilesRead(opt,ireadfile,ireadtask);

        Nbuf=new Int_t[NProcs];
        Nbaryonbuf=new Int_t[NProcs];
        for (int j=0;j<NProcs;j++) Nbuf[j]=0;
        for (int j=0;j<NProcs;j++) Nbaryonbuf[j]=0;

        if (ThisTask == 0)
        {
          //
          // Compute Mass of DM particles in RAMSES code units
          //
          fstream Finfo;
          sprintf(buf1,"%s/info_%s.txt", opt.fname, opt.ramsessnapname);
          Finfo.open(buf1, ios::in);
          getline(Finfo,stringbuf);//nfiles
          getline(Finfo,stringbuf);//ndim
          getline(Finfo,stringbuf);//lmin
          getline(Finfo,stringbuf);//lmax
          getline(Finfo,stringbuf);//ngridmax
          getline(Finfo,stringbuf);//ncoarse
          getline(Finfo,stringbuf);//blank
          getline(Finfo,stringbuf);//boxsize
          getline(Finfo,stringbuf);//time
          getline(Finfo,stringbuf);//a
          getline(Finfo,stringbuf);//hubble
          Finfo>>stringbuf>>stringbuf>>OmegaM;
          getline(Finfo,stringbuf);
          getline(Finfo,stringbuf);
          getline(Finfo,stringbuf);
          Finfo>>stringbuf>>stringbuf>>OmegaB;
          Finfo.close();
          dmp_mass = 1.0 / (opt.Neff*opt.Neff*opt.Neff) * (OmegaM - OmegaB) / OmegaM;
        }
        MPI_Bcast(&dmp_mass, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);

        if (ireadtask[ThisTask]>=0) {

	    ////// MPI DOMAIN DECOMPOSITION

            if (opt.partsearchtype!=PSTGAS) {
                xtempall = new RAMSESFLOAT [3*nbodies];
                xtempX   = new RAMSESFLOAT [nbodies];
                xtempY   = new RAMSESFLOAT [nbodies];
                xtempZ   = new RAMSESFLOAT [nbodies];
                famtempall=new int [nbodies];

                int ind_DM = 0;
                int ind_ST = 0;
		int nnnnn=0;
                for (int i = 0, count2 = 0; i < opt.num_files; i++) if (ireadfile[i]){
                    sprintf(buf1,"%s/part_%s.out%05d",opt.fname,opt.ramsessnapname,i+1);
                    sprintf(buf2,"%s/part_%s.out",opt.fname,opt.ramsessnapname);
                    if (FileExists(buf1)) sprintf(buf,"%s",buf1);
                    else if (FileExists(buf2)) sprintf(buf,"%s",buf2);
                    Fpart[i].open      (buf, ios::binary|ios::in);
                    Fpartmass[i].open  (buf, ios::binary|ios::in);
                    Fpartage[i].open   (buf, ios::binary|ios::in);
                    Fpartfam[i].open   (buf, ios::binary|ios::in);
                    //skip header information in each file save for number in the file
                    //@{
                    byteoffset = 0;
                    // ncpus
                    byteoffset += RAMSES_fortran_skip(Fpart[i], 1);
                    // ndims
                    byteoffset += RAMSES_fortran_read(Fpart[i],header[i].ndim);
                    //store number of particles locally in file
                    byteoffset += RAMSES_fortran_read(Fpart[i],header[i].npartlocal);
                    // skip local seeds, nstartot, mstartot, mstarlost, nsink
                    byteoffset += RAMSES_fortran_skip(Fpart[i], 5);
                    // byteoffset now stores size of header offset for particles
                    Fpartmass[i].seekg  (byteoffset,ios::cur);
                    Fpartage[i].seekg   (byteoffset,ios::cur);
                    Fpartfam[i].seekg   (byteoffset,ios::cur);

                    //skip positions
                    for(idim = 0; idim < header[i].ndim; idim++)
                    {
                          RAMSES_fortran_skip (Fpartmass[i]);
                          RAMSES_fortran_skip (Fpartage[i]);
                          RAMSES_fortran_skip (Fpartfam[i]);
                    }
                    //skip velocities
                    for(idim=0;idim<header[i].ndim;idim++)
                    {
                        RAMSES_fortran_skip(Fpartmass[i]);
                        RAMSES_fortran_skip(Fpartage[i]);
                        RAMSES_fortran_skip (Fpartfam[i]);
                    }
                    //skip mass
                    RAMSES_fortran_skip(Fpartage[i]);
                    RAMSES_fortran_skip (Fpartfam[i]);
                    //skip ids;
                    RAMSES_fortran_skip(Fpartage[i]);
                    RAMSES_fortran_skip (Fpartfam[i]);
                    //skip levels
                    RAMSES_fortran_skip(Fpartage[i]);
                    RAMSES_fortran_skip (Fpartfam[i]);
                    //skip family
                    //RAMSES_fortran_skip(Fpartage[i]);
                    //skip tag
                    //RAMSES_fortran_skip(Fpartage[i]);

                    //data loaded into memory in chunks
                    chunksize    = nchunk = header[i].npartlocal;
                    xtempchunk   = new RAMSESFLOAT  [3*chunksize];
                    mtempchunk   = new RAMSESFLOAT  [chunksize];
                    agetempchunk = new RAMSESFLOAT  [chunksize];
                    //dummy_family = new int [chunksize];
                    //dummy_family2= new char [chunksize];

                    //now load position data, mass data, and age data
                    for(idim = 0; idim < header[i].ndim; idim++)RAMSES_fortran_read(Fpart[i], &xtempchunk[idim*nchunk]);
                    RAMSES_fortran_read(Fpartmass[i],  mtempchunk);
                    RAMSES_fortran_read(Fpartage[i],   agetempchunk);

                    //Fpartfam[i].read((char*)&dummy, sizeof(dummy));
                    //Fpartfam[i].read((char*)&dummy_family2[0], dummy);
                    //Fpartfam[i].read((char*)&dummy, sizeof(dummy));

                    //for(int ii2=0; ii2<chunksize; ii2 ++) dummy_family[ii2] = dummy_family2[ii2] + 0;

		    for (int nn = 0; nn < nchunk; nn++)
                    {
                            if (opt.partsearchtype == PSTDARK && (fabs((mtempchunk[nn]-dmp_mass)/dmp_mass) < 1e-5))
                            {
                                    xtempall[ind_DM] = xtempchunk[nn];
                                    xtempall[ind_DM+nbodies] = xtempchunk[nn+nchunk];
                                    xtempall[ind_DM+2*nbodies]= xtempchunk[nn+2*nchunk];
                                    xtempX[ind_DM] = xtempchunk[nn];
                                    xtempY[ind_DM] = xtempchunk[nn+nchunk];
                                    xtempZ[ind_DM] = xtempchunk[nn+2*nchunk];
                                    famtempall[ind_DM] = 1; //dummy_family[nn];
                                    ind_DM++;
                            }

                            if(opt.partsearchtype == PSTSTAR && (fabs((mtempchunk[nn]-dmp_mass)/dmp_mass) > 1e-5) && agetempchunk[nn]<0.0) 
                            {
                                    xtempall[ind_ST] = xtempchunk[nn];
                                    xtempall[ind_ST+nbodies] = xtempchunk[nn+nchunk];
                                    xtempall[ind_ST+2*nbodies]= xtempchunk[nn+2*nchunk];
                                    xtempX[ind_ST] = xtempchunk[nn];
                                    xtempY[ind_ST] = xtempchunk[nn+nchunk];
                                    xtempZ[ind_ST] = xtempchunk[nn+2*nchunk];
                                    famtempall[ind_ST] = 2; //dummy_family[nn];
                                    ind_ST ++;
				    nnnnn++;
                            }

                            if(opt.partsearchtype == PSTALL)
                            {
                                    cout<<"MPIRAMSES -- ALL PTCLS ARE NOT IMPLEMENTED"<<endl;
                                    exit(9);
                            }

                    }
                    delete[] xtempchunk;
                    delete[] mtempchunk;
                    //delete[] dummy_family;
                    //delete[] dummy_family2;

                    Fpart[i].close();
                    Fpartmass[i].close();
                    Fpartage[i].close();
                    Fpartfam[i].close();
                }

                //////
                RAMSESFLOAT Z_domain[NProcs][3][2];
                double Z_box[3][2];
                int Z_dir[3];
                int Z_np = nbodies / NProcs;
                int Z_np2 = Z_np;
                int xtempNtot;
                double Z_cut;
		double Z_slope, Z_int;

                Z_box[0][0] = 0.;
                Z_box[0][1] = 1.;
                Z_box[1][0] = 0.;
                Z_box[1][1] = 1.;
                Z_box[2][0] = 0.;
                Z_box[2][1] = 1.;

                Z_dir[0] = 0;
                Z_dir[1] = 0;
                Z_dir[2] = 0;

		for (int nn = 0; nn < NProcs; nn++)
                {
                        if(nn < NProcs-1)
                        {
                                if(nn == 0)
                                {
                                        xtempA = new RAMSESFLOAT *[nbodies];
                                        for(int nn5 = 0; nn5 < nbodies; nn5++) xtempA[nn5] = new RAMSESFLOAT[3];
                                        for(int nn2 = 0; nn2 < nbodies; nn2 ++)
                                        {
                                                xtempA[nn2][0] = xtempX[nn2];
                                                xtempA[nn2][1] = xtempY[nn2];
                                                xtempA[nn2][2] = xtempZ[nn2];
                                        }
                                        xtempNtot = nbodies;
                                }

                                xtempTMP = new RAMSESFLOAT [xtempNtot];
                                for(int nn2 = 0; nn2 < xtempNtot; nn2++) xtempTMP[nn2] = xtempA[nn2][(nn % 3)];

                                if( (Z_dir[nn % 3] % 2) == 0 ) sort(xtempTMP, xtempTMP + xtempNtot);
                                if( (Z_dir[nn % 3] % 2) == 1 ) sort(xtempTMP, xtempTMP + xtempNtot, greater<float>());

				// Assign different number of ptcls to each MPI domain to read equal load balancing
				//
				//Z_slope = (Z_np*1./4 - Z_np*7./4)/(NProcs - 1);
				//Z_int	= Z_np - (NProcs + 1)/2. * Z_slope;
				//Z_np2	= Z_slope * (nn+1) + Z_int;

				Z_np2	= Z_np;
                                //Z_np2 = Z_np + Z_np/(1 - NProcs) * (nn+1) - Z_np*(NProcs + 1)/(2.*(1 - NProcs));
                                Z_cut = xtempTMP[Z_np2 - 1];
				                                ///
                                double domain_dx = 0.;
                                for(int nn3=Z_np2 - Z_np2/4; nn3 < Z_np2 + Z_np2/4; nn3++){
                                        if(fabs(xtempTMP[nn3] - xtempTMP[nn3-1]) > domain_dx){
                                                domain_dx = fabs(xtempTMP[nn3] - xtempTMP[nn3-1]);
                                                Z_cut = (xtempTMP[nn3] + xtempTMP[nn3-1])/2.;
                                        }

                                }

                                delete[] xtempTMP;

                                xtempA2 = new RAMSESFLOAT *[xtempNtot - Z_np2];
                                for(int nn5 = 0; nn5 < xtempNtot - Z_np2; nn5 ++) xtempA2[nn5] = new RAMSESFLOAT[3];
                                int nn3 = 0;
                                for(int nn2 = 0; nn2 < xtempNtot; nn2 ++)
                                {
                                        if(xtempA[nn2][(nn % 3)] > Z_cut && (Z_dir[nn % 3] % 2) == 0 && nn3 < xtempNtot - Z_np2)
                                        {
                                                for(int nn4 = 0; nn4 < 3; nn4 ++) xtempA2[nn3][nn4] = xtempA[nn2][nn4];
                                                nn3 ++;
                                        }
                                        if(xtempA[nn2][(nn % 3)] < Z_cut && (Z_dir[nn % 3] % 2) == 1 && nn3 < xtempNtot - Z_np2)
                                        {
                                                for(int nn4 = 0; nn4 < 3; nn4 ++) xtempA2[nn3][nn4] = xtempA[nn2][nn4];
                                                nn3 ++;
                                        }
                                }
                                for(int nn5 = 0; nn5 < xtempNtot; nn5++) delete[] xtempA[nn5];
                                delete[] xtempA;

                                xtempNtot = xtempNtot - Z_np2;
                                xtempA = new RAMSESFLOAT *[xtempNtot];
                                for(int nn5 = 0; nn5 < xtempNtot; nn5 ++) xtempA[nn5] = new RAMSESFLOAT[3];
                                for (int nn2 = 0; nn2 < xtempNtot; nn2 ++)
                                {
                                        for(int nn3 = 0; nn3 < 3; nn3 ++) xtempA[nn2][nn3] = xtempA2[nn2][nn3];
                                }
                                for(int nn5 = 0; nn5 < xtempNtot; nn5++) delete[] xtempA2[nn5];
                                delete[] xtempA2;

                                for(int nn2 = 0; nn2 < 3; nn2 ++)
                                {
                                        Z_domain[nn][nn2][0] = Z_box[nn2][0];
                                        Z_domain[nn][nn2][1] = Z_box[nn2][1];
                                }
                                Z_domain[nn][nn % 3][(Z_dir[nn % 3] + 1) % 2] = Z_cut;
                                Z_box[nn % 3][Z_dir[nn % 3] % 2] = Z_cut;


                                Z_dir[nn % 3] ++;
                        }
                        else
                        {
                                for(int nn2 = 0; nn2 < 3; nn2 ++)
                                {
                                        Z_domain[nn][nn2][0] = Z_box[nn2][0];
                                        Z_domain[nn][nn2][1] = Z_box[nn2][1];
                                }
                        }
                }

                for(int nn = 0; nn < NProcs; nn ++)
                {
                        for(int nn2 = 0; nn2 < 3; nn2 ++)
                        {
                                MPIDomainDecompositionZOOMIN(nn, nn2, Z_domain[nn][nn2][0], Z_domain[nn][nn2][1]);
                        }
                }
            }
	}

        MPIInitialDomainDecomposition();

	    //////
	if (ireadtask[ThisTask]>=0) {
            if (opt.partsearchtype!=PSTGAS) {
		for (int nn = 0; nn < nbodies; nn++)
                {
			typeval = 100;
                        if(famtempall[nn] == 1)
                        {
                                typeval = DARKTYPE;
                                ndark++;
                        }
                        else
                        {
                                typeval = STARTYPE;
                                nstar++;
                        }

                        ibuf = MPIGetParticlesProcessor(xtempall[nn],xtempall[nn+nbodies],xtempall[nn+2*nbodies]);

                        if(opt.partsearchtype == PSTALL)
                        {
                                Nbuf[ibuf]++;
                                count2++;
                        }
                        else
                        {
                            if (opt.partsearchtype == PSTDARK)
                            {
                                if (typeval == DARKTYPE)
                                {
                                    Nbuf[ibuf]++;
                                    count2++;
                                }
                                else
                                {
                                    if (opt.iBaryonSearch)
                                    {
                                        Nbaryonbuf[ibuf]++;
                                    }
                                }
                            }
                            else
                            {
                                if (opt.partsearchtype == PSTSTAR)
                                {
                                    if (typeval == STARTYPE)
                                    {
                                        Nbuf[ibuf]++;
                                        count2++;
                                    }
                                }
                            }
                        }
                }
                delete[] xtempall;
                delete[] xtempX;
                delete[] xtempY;
                delete[] xtempZ;
                delete[] famtempall;
	}
                //for (int i = 0, count2 = 0; i < opt.num_files; i++) if (ireadfile[i]){
                //    sprintf(buf1,"%s/part_%s.out%05d",opt.fname,opt.ramsessnapname,i+1);
                //    sprintf(buf2,"%s/part_%s.out",opt.fname,opt.ramsessnapname);
                //    if (FileExists(buf1)) sprintf(buf,"%s",buf1);
                //    else if (FileExists(buf2)) sprintf(buf,"%s",buf2);
                //    Fpart[i].open      (buf, ios::binary|ios::in);
                //    Fpartmass[i].open  (buf, ios::binary|ios::in);
                //    Fpartage[i].open   (buf, ios::binary|ios::in);
                //    //skip header information in each file save for number in the file
                //    //@{
                //    byteoffset = 0;
                //    // ncpus
                //    byteoffset += RAMSES_fortran_skip(Fpart[i], 1);
                //    // ndims
                //    byteoffset += RAMSES_fortran_read(Fpart[i],header[i].ndim);
                //    //store number of particles locally in file
                //    byteoffset += RAMSES_fortran_read(Fpart[i],header[i].npartlocal);
                //    // skip local seeds, nstartot, mstartot, mstarlost, nsink
                //    byteoffset += RAMSES_fortran_skip(Fpart[i], 5);
                //    // byteoffset now stores size of header offset for particles
                //    Fpartmass[i].seekg  (byteoffset,ios::cur);
                //    Fpartage[i].seekg   (byteoffset,ios::cur);

                //    //skip positions
                //    for(idim = 0; idim < header[i].ndim; idim++)
                //    {
                //          RAMSES_fortran_skip (Fpartmass[i]);
                //          RAMSES_fortran_skip (Fpartage[i]);
                //    }
                //    //skip velocities
                //    for(idim=0;idim<header[i].ndim;idim++)
                //    {
                //        RAMSES_fortran_skip(Fpartmass[i]);
                //        RAMSES_fortran_skip(Fpartage[i]);
                //    }
                //    //skip mass
                //    RAMSES_fortran_skip(Fpartage[i]);
                //    //skip ids;
                //    RAMSES_fortran_skip(Fpartage[i]);
                //    //skip levels
                //    RAMSES_fortran_skip(Fpartage[i]);
                //    //data loaded into memory in chunks
                //    chunksize    = nchunk = header[i].npartlocal;
                //    xtempchunk   = new RAMSESFLOAT  [3*chunksize];
                //    mtempchunk   = new RAMSESFLOAT  [chunksize];
                //    agetempchunk = new RAMSESFLOAT  [chunksize];
                //    //now load position data, mass data, and age data
                //    for(idim = 0; idim < header[i].ndim; idim++)RAMSES_fortran_read(Fpart[i], &xtempchunk[idim*nchunk]);
                //    RAMSES_fortran_read(Fpartmass[i],  mtempchunk);
                //    RAMSES_fortran_read(Fpartage[i],   agetempchunk);

                //    for (int nn = 0; nn < nchunk; nn++)
                //    {
                //        //this should be a ghost star particle
                //        if (fabs((mtempchunk[nn]-dmp_mass)/dmp_mass) > 1e-5 && (agetempchunk[nn] == 0.0)) nghost++;
                //        else
                //        {
                //            xtemp[0] = xtempchunk[nn];
                //            xtemp[1] = xtempchunk[nn+nchunk];
                //            xtemp[2] = xtempchunk[nn+2*nchunk];
                //            mtemp = mtempchunk[nn];
                //            ageval = agetempchunk[nn];

                //            if (fabs(mtemp-dmp_mass)/dmp_mass<1e-5)
                //            {
                //                typeval = DARKTYPE;
                //                ndark++;
                //            }
                //            else
                //            {
                //                typeval = STARTYPE;
                //                nstar++;
                //            }

                //            //determine processor this particle belongs on based on its spatial position
                //            ibuf = MPIGetParticlesProcessor(xtemp[0],xtemp[1],xtemp[2]);
                //            /// Count total number of DM particles, Baryons, etc
                //            //@{
                //            if (opt.partsearchtype == PSTALL)
                //            {
                //            Nbuf[ibuf]++;
                //            count2++;
                //            }
                //            else
                //            {
                //                if (opt.partsearchtype == PSTDARK)
                //                {
                //                    if (typeval == DARKTYPE)
                //                    {
                //                        Nbuf[ibuf]++;
                //                        count2++;
                //                    }
                //                    else
                //                    {
                //                        if (opt.iBaryonSearch)
                //                        {
                //                            Nbaryonbuf[ibuf]++;
                //                        }
                //                    }
                //                }
                //                else
                //                {
                //                    if (opt.partsearchtype == PSTSTAR)
                //                    {
                //                        if (typeval == STARTYPE)
                //                        {
                //                            Nbuf[ibuf]++;
                //                            count2++;
                //                        }
                //                    }
                //                }
                //            }
                //        }
                //    }
                //    delete[] xtempchunk;
                //    delete[] mtempchunk;
                //    delete[] agetempchunk;

                //    Fpart[i].close();
                //    Fpartmass[i].close();
                //    Fpartage[i].close();
                //}
            //}

            // now process gas if necessary
            if (opt.partsearchtype==PSTGAS || opt.partsearchtype==PSTALL) {
                for (i=0;i<opt.num_files;i++) if (ireadfile[i]) {
                    sprintf(buf1,"%s/amr_%s.out%05lld",opt.fname,opt.ramsessnapname,i+1);
                    sprintf(buf2,"%s/amr_%s.out",opt.fname,opt.ramsessnapname);
                    if (FileExists(buf1)) sprintf(buf,"%s",buf1);
                    else if (FileExists(buf2)) sprintf(buf,"%s",buf2);
                    Famr[i].open(buf, ios::binary|ios::in);
                    sprintf(buf1,"%s/hydro_%s.out%05lld",opt.fname,opt.ramsessnapname,i+1);
                    sprintf(buf2,"%s/hydro_%s.out",opt.fname,opt.ramsessnapname);
                    if (FileExists(buf1)) sprintf(buf,"%s",buf1);
                    else if (FileExists(buf2)) sprintf(buf,"%s",buf2);
                    Fhydro[i].open(buf, ios::binary|ios::in);
                    //read some of the amr header till get to number of cells in current file
                    //@{
                    byteoffset=0;
                    byteoffset+=RAMSES_fortran_read(Famr[i],header[i].ndim);
                    header[i].twotondim=pow(2,header[i].ndim);
                    Famr[i].read((char*)&dummy, sizeof(dummy));
                    Famr[i].read((char*)&header[i].nx, sizeof(int));
                    Famr[i].read((char*)&header[i].ny, sizeof(int));
                    Famr[i].read((char*)&header[i].nz, sizeof(int));
                    Famr[i].read((char*)&dummy, sizeof(dummy));
                    byteoffset+=RAMSES_fortran_read(Famr[i],header[i].nlevelmax);
                    byteoffset+=RAMSES_fortran_read(Famr[i],header[i].ngridmax);
                    byteoffset+=RAMSES_fortran_read(Famr[i],header[i].nboundary);
                    byteoffset+=RAMSES_fortran_read(Famr[i],header[i].npart[RAMSESGASTYPE]);

                    //then skip the rest
                    for (j=0;j<14;j++) RAMSES_fortran_skip(Famr[i]);
                    if (lmin>header[i].nlevelmax) lmin=header[i].nlevelmax;
                    if (lmax<header[i].nlevelmax) lmax=header[i].nlevelmax;
                    //@}
                    //read header info from hydro files
                    //@{
                    RAMSES_fortran_skip(Fhydro[i]);
                    RAMSES_fortran_read(Fhydro[i],header[i].nvarh);
                    RAMSES_fortran_skip(Fhydro[i]);
                    RAMSES_fortran_skip(Fhydro[i]);
                    RAMSES_fortran_skip(Fhydro[i]);
                    RAMSES_fortran_read(Fhydro[i],header[i].gamma_index);
                    //@}

                    //then apparently read ngridlevels, which appears to be an array storing the number of grids at a given level
                    ngridlevel=new int[header[i].nlevelmax];
                    ngridfile=new int[(1+header[i].nboundary)*header[i].nlevelmax];
                    RAMSES_fortran_read(Famr[i],ngridlevel);
                    for (j=0;j<header[i].nlevelmax;j++) ngridfile[j]=ngridlevel[j];
                    //skip some more
                    RAMSES_fortran_skip(Famr[i]);
                    //if nboundary>0 then need two skip twice then read ngridbound
                    if(header[i].nboundary>0) {
                        ngridbound=new int[header[i].nboundary*header[i].nlevelmax];
                        RAMSES_fortran_skip(Famr[i]);
                        RAMSES_fortran_skip(Famr[i]);
                        //ngridbound is an array of some sort but I don't see what it is used for
                        RAMSES_fortran_read(Famr[i],ngridbound);
                        for (j=0;j<header[i].nlevelmax;j++) ngridfile[header[i].nlevelmax+j]=ngridbound[j];
                    }
                    //skip some more
                    RAMSES_fortran_skip(Famr[i],2);
                    //if odering list in info is bisection need to skip more
                    if (orderingstring==string("bisection")) RAMSES_fortran_skip(Famr[i],5);
                    else RAMSES_fortran_skip(Famr[i],4);

                    for (k=0;k<header[i].nboundary+1;k++) {
                        for (j=0;j<header[i].nlevelmax;j++) {
                            //first read amr for positions
                            chunksize=nchunk=ngridfile[k*header[i].nlevelmax+j];
                            if (chunksize>0) {
                                xtempchunk=new RAMSESFLOAT[3*chunksize];
                                //store son value in icell
                                icellchunk=new int[header[i].twotondim*chunksize];
                                //skip grid index, next index and prev index.
                                RAMSES_fortran_skip(Famr[i],3);
                                //now read grid centre
                                for (idim=0;idim<header[i].ndim;idim++) {
                                    RAMSES_fortran_read(Famr[i],&xtempchunk[idim*chunksize]);
                                }
                                //skip father index, then neighbours index
                                RAMSES_fortran_skip(Famr[i],1+2*header[i].ndim);
                                //read son index to determine if a cell in a specific grid is at the highest resolution and needs to be represented by a particle
                                for (idim=0;idim<header[i].twotondim;idim++) {
                                    RAMSES_fortran_read(Famr[i],&icellchunk[idim*chunksize]);
                                }
                                //skip cpu map and refinement map (2^ndim*2)
                                RAMSES_fortran_skip(Famr[i],2*header[i].twotondim);
                            }
                            RAMSES_fortran_skip(Fhydro[i]);
                            //then read hydro for other variables (first is density, then velocity, then pressure, then metallicity )
                            if (chunksize>0) {
                                //first read velocities (for 2 cells per number of dimensions (ie: cell corners?))
                                for (idim=0;idim<header[i].twotondim;idim++) {
                                    for (ivar=0;ivar<header[i].nvarh;ivar++) {
                                        for (igrid=0;igrid<chunksize;igrid++) {
                                            //once we have looped over all the hydro data then can start actually storing it into the particle structures
                                            if (ivar==header[i].nvarh-1) {
                                                //if cell has no internal cells or at maximum level produce a particle
                                                if (icellchunk[idim*chunksize+igrid]==0 || j==header[i].nlevelmax-1) {
                                                    //first suggestion is to add some jitter to the particle positions
                                                    double dx = pow(0.5, j);
                                                    int ix, iy, iz;
                                                    //below assumes three dimensions with 8 corners (? maybe cells) per grid
                                                    iz = idim/4;
                                                    iy = (idim - (4*iz))/2;
                                                    ix = idim - (2*iy) - (4*iz);
                                                    // Calculate absolute coordinates + jitter, and generate particle
                                                    xtemp[0] = ((((float)rand()/(float)RAND_MAX) * header[i].BoxSize * dx) +(header[i].BoxSize * (xtempchunk[igrid] + (double(ix)-0.5) * dx )) - (header[i].BoxSize*dx/2.0)) ;
                                                    xtemp[1] = ((((float)rand()/(float)RAND_MAX) * header[i].BoxSize * dx) +(header[i].BoxSize * (xtempchunk[igrid+1*chunksize] + (double(iy)-0.5) * dx )) - (header[i].BoxSize*dx/2.0)) ;
                                                    xtemp[2] = ((((float)rand()/(float)RAND_MAX) * header[i].BoxSize * dx) +(header[i].BoxSize * (xtempchunk[igrid+2*chunksize] + (double(iz)-0.5) * dx )) - (header[i].BoxSize*dx/2.0)) ;
                                                    //determine processor this particle belongs on based on its spatial position
                                                    ibuf=MPIGetParticlesProcessor(xtemp[0],xtemp[1],xtemp[2]);
                                                    Nbuf[ibuf]++;
                                                }
                                            }
                                        }
                                    }
                                }
                                delete[] xtempchunk;
                            }
                        }
                    }
                    Famr[i].close();
                }
            }
        }
        //now having read number of particles, run all gather
        Int_t mpi_nlocal[NProcs];
        MPI_Allreduce(Nbuf,mpi_nlocal,NProcs,MPI_Int_t,MPI_SUM,MPI_COMM_WORLD);
        Nlocal=mpi_nlocal[ThisTask];
        if (opt.iBaryonSearch) {
            MPI_Allreduce(Nbaryonbuf,mpi_nlocal,NProcs,MPI_Int_t,MPI_SUM,MPI_COMM_WORLD);
            Nlocalbaryon[0]=mpi_nlocal[ThisTask];
        }
    }
}

//@}

#endif
