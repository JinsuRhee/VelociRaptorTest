/*! \file KDFOF.cxx
 *  \brief This file contains subroutines involving FOF routines

    \todo must make periodic
*/

#include <KDTree.h>

namespace NBody
{

    Int_t* KDTree::FOF(Double_t fdist, Int_t &numgroup, Int_t minnum, int order,
        Int_tree_t *pHead, Int_tree_t *pNext, Int_tree_t *pTail, Int_tree_t *pLen,
        int ipcheckflag, FOFcheckfunc check, Double_t *params)
    {
        Double_t fdist2=fdist*fdist, off[6];
        //array containing particles group id
        Int_t *pGroup=new Int_t[numparts];
        //array containing head particle of Group
        Int_tree_t *pGroupHead=new Int_tree_t[numparts];
        //First-in First-out pointer, used to point to the next particle of
        //interest in the group to be examined.
        Int_tree_t *Fifo=new Int_tree_t[numparts];
        //array used to flag if bucket already searched.
        short *pBucketFlag=new short[numnodes];
        //flags for memory management
        bool iph,ipt,ipn,ipl;

        //arrays used in determining group id.
        //pHead contains the index of the particle at head of the particles group
        //pTail contains tail of the particles group and Next the next in the list
        //and pLen is indexed by group and is length of group.
        //flags to see if mem allocated
        iph=ipt=ipn=ipl=false;
        if (pHead==NULL)    {pHead=new Int_tree_t[numparts];iph=true;}
        if (pNext==NULL)    {pNext=new Int_tree_t[numparts];ipn=true;}
        if (pLen==NULL)     {pLen=new Int_tree_t[numparts];ipl=true;}
        if (pTail==NULL)    {pTail=new Int_tree_t[numparts];ipt=true;}

        Int_t iGroup=0,iHead=0,iTail=0,id,iid;
        Int_t maxlen=0;


        //initial arrays
        //initial arrays
	double time10 = (clock() /( (double)CLOCKS_PER_SEC));
        for (Int_t i=0;i<numparts;i++) {
            pHead[i]=pTail[i]=i;
            pNext[i]=-1;
            id=bucket[i].GetID();
            if (ipcheckflag) pGroup[id]=check(bucket[i],params);
            else pGroup[id]=0;
        }
        for (Int_t i=0;i<numnodes;i++) pBucketFlag[i]=0;

	// -- JS --
	LeafNode *js_lp;
	Node *js_dum;
	Double_t js_bdn[6][2], js_bdn2[6][2], js_rootbdn[6][2], js_linkbdn[6][2], js_volume;
	Double_t js_volumetmp, js_dx[6][2];
	Int_t js_inside, js_out, js_mask, js_bdncheck, js_endnode;

	for(int js_i=0; js_i<ND; js_i++) for(int js_j=0; js_j<2; js_j++) js_rootbdn[js_i][js_j] = root->GetBoundary(js_i, js_j);


        for (Int_t i=0;i<numparts;i++){
	    //double time10 = (clock() /( (double)CLOCKS_PER_SEC));
	   
	    int jinsu = 0;
            //if particle already member of group, ignore and go to next particle
            id=bucket[i].GetID();

            if(pGroup[id]!=0) continue;
            pGroup[id]=++iGroup;
            pLen[iGroup]=1;
            pGroupHead[iGroup]=i;
            Fifo[iTail++]=i;

            //if reach the end of particle list, set iTail to zero and wrap around
            if(iTail==numparts) iTail=0;

            //continue search for this group until one has wrapped around such that iHead==iTail
            while(iHead!=iTail) {
                //this is initially particle i with ID id;
                iid=Fifo[iHead++];
                //if reached the head of Index list, go back to zero
                if (iHead==numparts) iHead=0;

		// -- JS --
		// Begin Ball Search. This routine is based on a bottom-up structure finding

		js_lp = NULL;
		js_dum = NULL;
		js_out = -1;
		js_endnode = -1;

		js_lp=(LeafNode*)FindLeafNode(iid);
		for(int js_i=0; js_i<ND; js_i++) for(int js_j=0; js_j<2; js_j++) js_bdn[js_i][js_j] = js_lp->GetBoundary(js_i, js_j);

		// Setting Linking length Area
		js_volume = 1.;
		for(int js_i=0; js_i<ND; js_i++){
			js_linkbdn[js_i][0] = max(bucket[iid].GetPhase(js_i) - sqrt(fdist2), js_rootbdn[js_i][0]) + 1e-8;
			js_linkbdn[js_i][1] = min(bucket[iid].GetPhase(js_i) + sqrt(fdist2), js_rootbdn[js_i][1]) - 1e-8;

			js_volume = js_volume * (js_linkbdn[js_i][1] - js_linkbdn[js_i][0]);
		}

		// Initial Search
                for (int j = 0; j < 3; j++) off[j] = 0.0;
                if (period==NULL) js_lp->FOFSearchBall(0.0,fdist2,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,iid);
                else js_lp->FOFSearchBallPeriodic(0.0,fdist2,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,period,iid);

		js_dum = ((Node *)js_lp)->GetNext();

		if (js_lp->GetLorR() == -1) js_mask=1;
		if (js_lp->GetLorR() == 1) js_mask=0;
		js_dum->SetMask(js_mask);

		// Neighbor Search
		while(1){

		double time11 = (clock() /( (double)CLOCKS_PER_SEC)); //%123123
		if(time11 - time10 > 100*(jinsu+1.)){
			jinsu ++;
	    		if(jinsu>0) cout<<" %123123 - "<<i<<" / "<<numparts<<" / Length: "<<pLen[iGroup]<<" / GID: "<<iGroup<<" / "<<time11-time10<<endl;//%123123
		}

			// Sibling Search
			if(js_dum->GetLorR() == -1){
				// Left
				if(js_dum->GetLeaf() == 1){
					js_dum=(LeafNode *)js_dum;
                			if (period==NULL) js_dum->FOFSearchBall(0.0,fdist2,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,iid);
                			else js_dum->FOFSearchBallPeriodic(0.0,fdist2,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,period,iid);
					js_dum=((Node *)js_dum)->GetNext();
					js_mask=1;
					if(js_dum->GetMask() != 2) js_dum->SetMask(js_mask);
					goto js_start;
				}
				else
				{
					if(js_dum->GetMask() == 2){
						js_dum=((Node *)js_dum)->GetNext();
						js_mask = 1;
						if(js_dum->GetMask() != 2) js_dum->SetMask(js_mask);
						goto js_start;
					}
					else
					{
						js_mask = 2;
						js_dum->SetMask(js_mask);
						js_dum=(Node *)((SplitNode *)js_dum)->GetLeft();
						goto js_start;
					}
				}
			}

			if(js_dum->GetLorR() == 0){
				// Root
				if(js_dum->GetMask() == 0){
					js_mask = 2;
					js_dum->SetMask(js_mask);

					js_dum=(Node *)((SplitNode *)js_dum)->GetLeft();

					goto js_start;
				}
				else if (js_dum->GetMask() == 2) break;
			}

			if(js_dum->GetLorR() == 1){
				// Right
				if(js_dum->GetMask() == 0){
					js_mask = 2;
					js_dum->SetMask(js_mask);

					js_dum=((Node *)js_dum)->GetNext();
					js_dum=(Node *)((SplitNode *)js_dum)->GetLeft();

					goto js_start;
				}
				else if (js_dum->GetMask() == 1){ // Go ahead
					if(js_dum->GetLeaf() == 1){
						js_dum=(LeafNode *)js_dum;
                				if (period==NULL) js_dum->FOFSearchBall(0.0,fdist2,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,iid);
						else js_dum->FOFSearchBallPeriodic(0.0,fdist2,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,period,iid);
						js_dum=((Node *)js_dum)->GetNext();

						if(js_dum->GetLorR() == -1){
							js_mask = 2;
							js_dum->SetMask(js_mask);
						}
						else
						{
							if(js_dum->GetMask() == 1) js_mask=2;
							if(js_dum->GetMask() != 1) js_mask=0;
							js_dum->SetMask(js_mask);
						}

						goto js_start;
					}
					else
					{
						js_dum=(Node *)((SplitNode *)js_dum)->GetLeft();
						goto js_start;
					}

				}
				else if (js_dum->GetMask() == 2){
					js_dum=((Node *)js_dum)->GetNext();

					if(js_dum->GetLorR() == -1){
						js_mask = 2;
						js_dum->SetMask(js_mask);
					}
					else
					{
						if(js_dum->GetMask() == 1) js_mask=2;
						if(js_dum->GetMask() != 1) js_mask=0;
						js_dum->SetMask(js_mask);
					}
					goto js_start;
				}
				 
			}

			js_start:

			if(js_out == 1) break;

			if(js_dum->GetLeaf() == 1){
				if(js_out == -1)
				{
					for(int js_i=0; js_i<ND; js_i++) for(int js_j=0; js_j<2; js_j++) js_bdn2[js_i][js_j] = js_lp->GetBoundary(js_i, js_j);
					
					js_inside = 0;
					for(int js_i=0; js_i<ND; js_i++){
						if( js_bdn2[js_i][1] - js_bdn2[js_i][0] > js_linkbdn[js_i][1] - js_linkbdn[js_i][0] ){
							if(js_bdn2[js_i][1] < js_linkbdn[js_i][0]) continue;
							if(js_bdn2[js_i][1] > js_linkbdn[js_i][0] && js_bdn2[js_i][1] < js_linkbdn[js_i][1]){
								js_dx[js_i][0] = js_linkbdn[js_i][0];
								js_dx[js_i][1] = js_bdn2[js_i][1];
								js_inside ++;
							}
							if(js_bdn2[js_i][1] > js_linkbdn[js_i][1] && js_bdn2[js_i][0] < js_linkbdn[js_i][1]){
								js_dx[js_i][0] = max(js_bdn2[js_i][0], js_linkbdn[js_i][0]);
								js_dx[js_i][1] = js_linkbdn[js_i][1];
								js_inside ++;
							}
						}
						else
						{
							if(js_bdn2[js_i][1] < js_linkbdn[js_i][0]) continue;
							if(js_bdn2[js_i][1] > js_linkbdn[js_i][0] && js_bdn2[js_i][1] < js_linkbdn[js_i][1]){
								js_dx[js_i][0] = max(js_bdn2[js_i][0], js_linkbdn[js_i][0]);
								js_dx[js_i][1] = js_bdn2[js_i][1];
								js_inside ++;
							}
							if(js_bdn[js_i][1] > js_linkbdn[js_i][1] && js_bdn2[js_i][0] < js_linkbdn[js_i][1]){
								js_dx[js_i][0] = js_bdn2[js_i][0];
								js_dx[js_i][1] = js_linkbdn[js_i][1];
								js_inside ++;
							}
						}
					}

					if(js_inside == ND){
						js_volumetmp = 1.;
						for(int js_i=0; js_i<ND; js_i++){
							js_volumetmp = js_volumetmp * (js_dx[js_i][1] - js_dx[js_i][0]);
						}

						js_volume = js_volume - js_volumetmp;
					}

					js_out = 0.0;
					if(js_volume <= 0.) js_out = 1.0;
				}


				for(int js_i=0; js_i<ND; js_i++) for(int js_j=0; js_j<2; js_j++) js_bdn2[js_i][js_j] = js_dum->GetBoundary(js_i, js_j);
				
				js_inside = 0;
				for(int js_i=0; js_i<ND; js_i++){
					if( js_bdn2[js_i][1] - js_bdn2[js_i][0] > js_linkbdn[js_i][1] - js_linkbdn[js_i][0] ){
						if(js_bdn2[js_i][1] < js_linkbdn[js_i][0]) continue;
						if(js_bdn2[js_i][1] > js_linkbdn[js_i][0] && js_bdn2[js_i][1] < js_linkbdn[js_i][1]){
							js_dx[js_i][0] = js_linkbdn[js_i][0];
							js_dx[js_i][1] = js_bdn2[js_i][1];
							js_inside ++;
						}
						if(js_bdn2[js_i][1] > js_linkbdn[js_i][1] && js_bdn2[js_i][0] < js_linkbdn[js_i][1]){
							js_dx[js_i][0] = max(js_bdn2[js_i][0], js_linkbdn[js_i][0]);
							js_dx[js_i][1] = js_linkbdn[js_i][1];
							js_inside ++;
						}
					}
					else
					{
						if(js_bdn2[js_i][1] < js_linkbdn[js_i][0]) continue;
						if(js_bdn2[js_i][1] > js_linkbdn[js_i][0] && js_bdn2[js_i][1] < js_linkbdn[js_i][1]){
							js_dx[js_i][0] = max(js_bdn2[js_i][0], js_linkbdn[js_i][0]);
							js_dx[js_i][1] = js_bdn2[js_i][1];
							js_inside ++;
						}
						if(js_bdn[js_i][1] > js_linkbdn[js_i][1] && js_bdn2[js_i][0] < js_linkbdn[js_i][1]){
							js_dx[js_i][0] = js_bdn2[js_i][0];
							js_dx[js_i][1] = js_linkbdn[js_i][1];
							js_inside ++;
						}
					}
				}

				if(js_inside == ND){
					js_volumetmp = 1.;
					for(int js_i=0; js_i<ND; js_i++){
						js_volumetmp = js_volumetmp * (js_dx[js_i][1] - js_dx[js_i][0]);
					}

					js_volume = js_volume - js_volumetmp;
				}


				if(js_volume <= 0) js_out = 1;
			}

			if(js_dum->GetLeaf() == 1)
			{
				cout<<"%123123	-- "<<iid<<" / "<<pLen[iGroup]<<" / "<<js_volume<<" / "<<js_volumetmp<<" / "<<js_dum->GetID()<<endl;
				for(int js_i=0; js_i<ND; js_i++) cout<<"		"<<js_bdn2[js_i][0]<<" ~ "<<js_bdn2[js_i][1]<<" // "<<js_linkbdn[js_i][0]<<" ~ "<<js_linkbdn[js_i][1]<<endl;
			}
			
			// Update searched volume
			//for(int js_i=0; js_i<ND; js_i++) for(int js_j=0; js_j<2; js_j++) js_bdn2[js_i][js_j] = js_dum->GetBoundary(js_i, js_j);

			//js_bdncheck=0;
			//for(int js_i=0; js_i<ND; js_i++){
			//	if(js_bdn2[js_i][0] <= js_bdn[js_i][0] && js_bdn2[js_i][1] >= js_bdn[js_i][1]) js_bdncheck ++;
			//}
			//if(js_bdncheck == ND) for(int js_i=0; js_i<ND; js_i++) for(int js_j=0; js_j<2; js_j++) js_bdn[js_i][js_j] = js_bdn2[js_i][js_j];

			//// Whether the whole volume encloses the linking-length sphere
			//js_inside = 0;
			//for(int js_i=0; js_i<ND; js_i++)
			//	if(js_linkbdn[js_i][0] > js_bdn[js_i][0] && js_linkbdn[js_i][1] < js_bdn[js_i][1]) js_inside ++;

			//if(js_inside == ND){
			//	js_endnode = js_dum->GetID();
			//	if(js_dum->GetLorR() == -1) js_out=0;
			//}

			//// End While if this node (if it's right) is again visited; if left, close
			//if(js_endnode > 0 & js_dum->GetID()==js_endnode) js_out ++;
		}

		ClearNodeMask(root);


                //now begin Ball search. This node routine finds all particles
                //within a distance fdist2, marks all particles using their IDS and pGroup array
                //adjusts the Fifo array, iTail and pLen.
                //first set offset to zero when beginning node search
		
                //for (int j = 0; j < 3; j++) off[j] = 0.0;
                //if (period==NULL) root->FOFSearchBall(0.0,fdist2,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,iid);
                //else root->FOFSearchBallPeriodic(0.0,fdist2,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,period,iid);

		//cout<<"%123123	-- "<<i<<" / "<<iid<<" / "<<iGroup<<" / "<<pLen[iGroup]<<endl;
            }

            if(pLen[iGroup]<minnum){
                Int_t ii=pHead[pGroupHead[iGroup]];
                do {
                    pGroup[bucket[ii].GetID()]=-1;
                } while ((ii=pNext[ii])!=-1);
            pLen[iGroup--]=0;
            }
            if (maxlen<pLen[iGroup]){maxlen=pLen[iGroup];}
	    if(pLen[iGroup]>10) cout<<"%123123 --- "<<id<<" / "<<iGroup<<" / "<<pLen[iGroup]<<" / "<<maxlen<<endl;

        }


        for (Int_t i=0;i<numparts;i++) if(pGroup[bucket[i].GetID()]==-1)pGroup[bucket[i].GetID()]=0;

        //free memory for arrays that are not needed
        delete[] Fifo;
        delete[] pBucketFlag;
        if (iph) delete[] pHead;
        if (ipt) delete[] pTail;
        if (ipn) delete[] pNext;

        if (iGroup>0){
            if (order) {
                //generate pList array to store go through particle list and generate linked list
                Int_t **pList, *pCount;
                pList=new Int_t*[iGroup+1];
                pCount=new Int_t[iGroup+1];
                for (Int_t i=1;i<=iGroup;i++) {pList[i]=new Int_t[pLen[i]];pCount[i]=0;}
                for (Int_t i=0;i<numparts;i++) {
                    Int_t gid=pGroup[bucket[i].GetID()];
                    if (gid>0) {
                        pList[gid][pCount[gid]++]=i;
                    }
                }
                //now order group indices
                PriorityQueue *pq=new PriorityQueue(iGroup);
                for (Int_t i = 1; i <=iGroup; i++) pq->Push(i, pLen[i]);
                maxlen=pq->TopPriority();
                for (Int_t i = 1; i<=iGroup; i++) {
                    Int_t groupid=pq->TopQueue();
                    pq->Pop();
                    for (Int_t j=0;j<pLen[groupid];j++) pGroup[bucket[pList[groupid][j]].GetID()]=i;
                    delete[] pList[groupid];
                }
                delete[] pList;
                delete[] pCount;
                delete pq;
            }
            //printf("Found %d groups. Largest is %d with %d particles.\n",iGroup,maxlenid,maxlen);
        }


        //else printf("No groups found.\n");

        if (ipl) delete[] pLen;
        delete[] pGroupHead;

        numgroup=iGroup;
        return pGroup;
    }

    //algorithm same as above with different comparison funciton
    //For example cmp function for FOF search see FOFFunc.h
    Int_t* KDTree::FOFCriterion(FOFcompfunc cmp, Double_t *params, Int_t &numgroup, Int_t minnum, int order, int ipcheckflag, FOFcheckfunc check, Int_tree_t *pHead, Int_tree_t *pNext, Int_tree_t *pTail, Int_tree_t *pLen)
    {
        Int_t *pGroup=new Int_t[numparts];
        Int_tree_t *pGroupHead=new Int_tree_t[numparts];
        Int_tree_t *Fifo=new Int_tree_t[numparts];
        short *pBucketFlag=new short[numnodes];

        bool iph,ipt,ipn,ipl;
        iph=ipt=ipn=ipl=false;
        if (pHead==NULL)    {pHead=new Int_tree_t[numparts];iph=true;}
        if (pNext==NULL)    {pNext=new Int_tree_t[numparts];ipn=true;}
        if (pLen==NULL)     {pLen=new Int_tree_t[numparts];ipl=true;}
        if (pTail==NULL)    {pTail=new Int_tree_t[numparts];ipt=true;}

        Double_t off[6];
        Int_t iGroup=0,iHead=0,iTail=0,id,iid;
        Int_t maxlen=0;

        //initial arrays
        for (Int_t i=0;i<numparts;i++) {
            id=bucket[i].GetID();
            if (ipcheckflag) pGroup[id]=check(bucket[i],params);
            else pGroup[id]=0;
            pHead[i]=pTail[i]=i;
            pNext[i]=-1;
        }
        for (Int_t i=0;i<numnodes;i++) pBucketFlag[i]=0;

        for (Int_t i=0;i<numparts;i++){
            //if particle already member of group, ignore and go to next particle
            id=bucket[i].GetID();
            if(pGroup[id]!=0) continue;
            pGroup[id]=++iGroup;
            pLen[iGroup]=1;
            pGroupHead[iGroup]=i;
            Fifo[iTail++]=i;

            //if reach the end of particle list, set iTail to zero and wrap around
            if(iTail==numparts) iTail=0;
            //continue search for this group until one has wrapped around such that iHead==iTail
            while(iHead!=iTail) {
                iid=Fifo[iHead++];
                if (iHead==numparts) iHead=0;

                //now begin search.
                for (int j = 0; j < 6; j++) off[j] = 0.0;
                if (period==NULL) root->FOFSearchCriterion(0.0,cmp,params,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,iid);
                else root->FOFSearchCriterionPeriodic(0.0,cmp,params,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,period,iid);
            }

            //make sure group big enough
            if(pLen[iGroup]<minnum){
                Int_t ii=pHead[pGroupHead[iGroup]];
                do {
                    pGroup[bucket[ii].GetID()]=-1;
                } while ((ii=pNext[ii])!=-1);
            pLen[iGroup--]=0;
            }
            //determine biggest group
            else if (maxlen<pLen[iGroup]){maxlen=pLen[iGroup];}
        }

        //for all groups that were too small reset id to 0
        for (Int_t i=0;i<numparts;i++) if(pGroup[bucket[i].GetID()]==-1)pGroup[bucket[i].GetID()]=0;

        //free memory for arrays that are not needed
        delete[] Fifo;
        delete[] pBucketFlag;
        if (iph) delete[] pHead;
        if (ipt) delete[] pTail;
        if (ipn) delete[] pNext;

        if (iGroup>0){
            if (order) {
                //generate pList array to store go through particle list and generate linked list
                Int_t **pList, *pCount;
                pList=new Int_t*[iGroup+1];
                pCount=new Int_t[iGroup+1];
                for (Int_t i=1;i<=iGroup;i++) {pList[i]=new Int_t[pLen[i]];pCount[i]=0;}
                for (Int_t i=0;i<numparts;i++) {
                    Int_t gid=pGroup[bucket[i].GetID()];
                    if (gid>0) pList[gid][pCount[gid]++]=i;

                }
                //now order group indices
                PriorityQueue *pq=new PriorityQueue(iGroup);
                for (Int_t i = 1; i <=iGroup; i++) pq->Push(i, pLen[i]);
                maxlen=pq->TopPriority();
                for (Int_t i = 1;i<=iGroup; i++) {
                    Int_t groupid=pq->TopQueue();
                    pq->Pop();
                    for (Int_t j=0;j<pLen[groupid];j++) pGroup[bucket[pList[groupid][j]].GetID()]=i;
                    delete[] pList[groupid];
                }
                delete[] pList;
                delete[] pCount;
                delete pq;
            }
            //printf("Found %d groups. Largest is %d with %d particles.\n",iGroup,maxlenid,maxlen);
        }
        //else printf("No groups found.\n");

        if (ipl) delete[] pLen;
        delete[] pGroupHead;
        numgroup=iGroup;
        return pGroup;
    }

    //FOF search with particles allowed to be basis of links set by FOFcheckfunc
    Int_t* KDTree::FOFCriterionSetBasisForLinks(FOFcompfunc cmp, Double_t *params, Int_t &numgroup, Int_t minnum, int order, int ipcheckflag, FOFcheckfunc check, Int_tree_t *pHead, Int_tree_t *pNext, Int_tree_t *pTail, Int_tree_t *pLen)
    {
        Int_t *pGroup=new Int_t[numparts];
        Int_tree_t *pGroupHead=new Int_tree_t[numparts];
        Int_tree_t *Fifo=new Int_tree_t[numparts];
        short *pBucketFlag=new short[numnodes];

        bool iph,ipt,ipn,ipl;
        iph=ipt=ipn=ipl=false;
        if (pHead==NULL)    {pHead=new Int_tree_t[numparts];iph=true;}
        if (pNext==NULL)    {pNext=new Int_tree_t[numparts];ipn=true;}
        if (pLen==NULL)     {pLen=new Int_tree_t[numparts];ipl=true;}
        if (pTail==NULL)    {pTail=new Int_tree_t[numparts];ipt=true;}

        Double_t off[6];
        Int_t iGroup=0,iHead=0,iTail=0,id,iid;
        Int_t maxlen=0;

        //initial arrays
        for (Int_t i=0;i<numparts;i++) {
            id=bucket[i].GetID();
            pGroup[id]=0;
            pHead[i]=pTail[i]=i;
            pNext[i]=-1;
        }
        for (Int_t i=0;i<numnodes;i++) pBucketFlag[i]=0;

        for (Int_t i=0;i<numparts;i++){
            //if particle already member of group, ignore and go to next particle
            id=bucket[i].GetID();
            if (check(bucket[i],params)!=0) continue;
            if(pGroup[id]!=0) continue;
            pGroup[id]=++iGroup;
            pLen[iGroup]=1;
            pGroupHead[iGroup]=i;
            Fifo[iTail++]=i;

            //if reach the end of particle list, set iTail to zero and wrap around
            if(iTail==numparts) iTail=0;
            //continue search for this group until one has wrapped around such that iHead==iTail
            while(iHead!=iTail) {
                iid=Fifo[iHead++];
                if (iHead==numparts) iHead=0;

                //check if head particle should be used as basis for links
                if (check(bucket[iid],params)==0) {
                    //now begin search.
                    for (int j = 0; j < 6; j++) off[j] = 0.0;
                    if (period==NULL) root->FOFSearchCriterionSetBasisForLinks(0.0,cmp,check,params,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,iid);
                    else root->FOFSearchCriterionSetBasisForLinksPeriodic(0.0,cmp,check,params,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,period,iid);
                }
            }

            //make sure group big enough
            if(pLen[iGroup]<minnum){
                Int_t ii=pHead[pGroupHead[iGroup]];
                do {
                    pGroup[bucket[ii].GetID()]=-1;
                } while ((ii=pNext[ii])!=-1);
            pLen[iGroup--]=0;
            }
            //determine biggest group
            else if (maxlen<pLen[iGroup]){maxlen=pLen[iGroup];}
        }

        //for all groups that were too small reset id to 0
        for (Int_t i=0;i<numparts;i++) if(pGroup[bucket[i].GetID()]==-1)pGroup[bucket[i].GetID()]=0;

        //free memory for arrays that are not needed
        delete[] Fifo;
        delete[] pBucketFlag;
        if (iph) delete[] pHead;
        if (ipt) delete[] pTail;
        if (ipn) delete[] pNext;

        if (iGroup>0){
            if (order) {
                //generate pList array to store go through particle list and generate linked list
                Int_t **pList, *pCount;
                pList=new Int_t*[iGroup+1];
                pCount=new Int_t[iGroup+1];
                for (Int_t i=1;i<=iGroup;i++) {pList[i]=new Int_t[pLen[i]];pCount[i]=0;}
                for (Int_t i=0;i<numparts;i++) {
                    Int_t gid=pGroup[bucket[i].GetID()];
                    if (gid>0) pList[gid][pCount[gid]++]=i;

                }
                //now order group indices
                PriorityQueue *pq=new PriorityQueue(iGroup);
                for (Int_t i = 1; i <=iGroup; i++) pq->Push(i, pLen[i]);
                maxlen=pq->TopPriority();
                for (Int_t i = 1;i<=iGroup; i++) {
                    Int_t groupid=pq->TopQueue();
                    pq->Pop();
                    for (Int_t j=0;j<pLen[groupid];j++) pGroup[bucket[pList[groupid][j]].GetID()]=i;
                    delete[] pList[groupid];
                }
                delete[] pList;
                delete[] pCount;
                delete pq;
            }
            //printf("Found %d groups. Largest is %d with %d particles.\n",iGroup,maxlenid,maxlen);
        }
        //else printf("No groups found.\n");

        if (ipl) delete[] pLen;
        delete[] pGroupHead;
        numgroup=iGroup;
        return pGroup;
    }

    Int_t *KDTree::FOFNNCriterion(FOFcompfunc cmp, Double_t *params, Int_t numNN, Int_t **nnID, Int_t &numgroup, Int_t minnum)
    {
        //declare useful fof arrays
        Int_t *pGroup=new Int_t[numparts];
        Int_t *pGroupHead=new Int_t[numparts];
        Int_t *Fifo=new Int_t[numparts];
        Int_t *pHead=new Int_t[numparts];
        Int_t *pTail=new Int_t[numparts];
        Int_t *pNext=new Int_t[numparts];
        Int_t *pLen=new Int_t[numparts];
        Int_t *pCount, **pList;
        PriorityQueue *pq;
        Int_t iGroup=0,iHead=0,iTail=0,id,iid,target;

        //initial arrays
        for (Int_t i=0;i<numparts;i++) {
            pGroup[i]=0;
            pHead[i]=pTail[i]=i;
            pNext[i]=-1;
        }

        for (Int_t i=0;i<numparts;i++){
            //if particle already member of group, ignore and go to next particle
            id=bucket[i].GetID();
            if(pGroup[id]!=0) continue;
            pGroup[id]=++iGroup;
            pLen[iGroup]=1;
            pGroupHead[iGroup]=i;
            Fifo[iTail++]=i;

            //if reach the end of particle list, set iTail to zero and wrap around
            if(iTail==numparts) iTail=0;
            //continue search for this group until one has wrapped around such that iHead==iTail
            while(iHead!=iTail) {
                target=Fifo[iHead++];
                if (iHead==numparts) iHead=0;

                //now begin search.
                //look at near neighbours that meet criteria.
                for (Int_t j = 0; j < numNN; j++)
                {
                    iid=bucket[nnID[target][j]].GetID();
                    if (pGroup[iid]==iGroup) continue;
                    if (cmp(bucket[target],bucket[nnID[target][j]],params)) {
                        //If criteria met and particle already member of another group, join groups by
                        //going through old group, change ids to new group and change head and tail appropriately
                        if (pGroup[iid]>0) {
                            Int_t oldGroup=pGroup[iid],oldHead=pGroupHead[oldGroup],oldTail=pTail[oldHead],currentTail=pTail[pGroupHead[iGroup]],ii;
                            //adjust ids
                            ii=oldHead;
                            do {
                                pGroup[bucket[ii].GetID()]=iGroup;
                                pHead[ii]=pGroupHead[iGroup];
                            } while ((ii=pNext[ii])!=-1);
                            ii=currentTail;
                            do {
                                pTail[ii]=oldTail;
                            } while ((ii=pNext[ii])!=-1);
                            pLen[iGroup]+=pLen[oldGroup];
                            pLen[oldGroup]=-1;//indicates mergered with another group
                            //now link groups by setting next to current particle and adjust tail and Head
                            pNext[currentTail]=oldHead;
                            pTail[pGroupHead[iGroup]]=oldTail;
                            pHead[oldHead]=pGroupHead[iGroup];//pHead[target];
                        }
                        //othersise adjust group id and head, tail pointer appropriately
                        else {

                            pGroup[iid]=iGroup;
                            Fifo[iTail++]=nnID[target][j];
                            pLen[iGroup]++;

                            pNext[pTail[pGroupHead[iGroup]]]=nnID[target][j];
                            pTail[pGroupHead[iGroup]]=nnID[target][j];
                            pHead[nnID[target][j]]=pGroupHead[iGroup];
                            //pNext[pTail[pHead[target]]]=pHead[nnID[target][j]];
                            //pTail[pHead[target]]=pTail[pHead[nnID[target][j]]];
                            //pHead[nnID[target][j]]=pHead[target];
                            if(iTail==numparts)iTail=0;
                        }
                    }
                }
            }
        }

        //free memory
        delete[] Fifo;
        delete[] pHead;
        delete[] pTail;
        delete[] pNext;

        //generate pList array to store go through particle list and generate linked list
        pList=new Int_t*[iGroup+1];
        pCount=new Int_t[iGroup+1];
        for (Int_t i=1;i<=iGroup;i++) if (pLen[i]>0) {pList[i]=new Int_t[pLen[i]];pCount[i]=0;}
        for (Int_t i=0;i<numparts;i++) {
            Int_t gid=pGroup[bucket[i].GetID()];
            if (gid>0)
                if(pLen[gid]>0)
                    pList[gid][pCount[gid]++]=i;
        }
        //now determine largest group, number of groups that are above minimum number
        numgroup=iGroup;
        for (Int_t i=1;i<=numgroup;i++){
            if(pLen[i]<minnum) {
                //two possibilities:  if pLen[i]=-1,group joined with another groupid
                //if this group was not joined with another then head should have the correct group id and then remove it by setting the ids to zero
                //if (pGroup[bucket[pGroupHead[i]].GetID()]==i) {
                if (pLen[i]>0) for (Int_t j=0;j<pLen[i];j++) pGroup[bucket[pList[i][j]].GetID()]=0;
                pLen[i]=0;
                iGroup--;
            }
        }
        //now order groups
        if (iGroup) {
            pq=new PriorityQueue(iGroup);
            for (Int_t i = 1; i <=numgroup; i++) if (pLen[i]>0) pq->Push(i, pLen[i]);
            //printf("Found %d groups. Largest is %d with %d particles.\n",iGroup,1,(Int_t)pq->TopPriority());
            for (Int_t i = 1; i<=iGroup; i++) {
                Int_t groupid=pq->TopQueue(),size=pq->TopPriority();pq->Pop();
                for (Int_t j=0;j<size;j++) pGroup[bucket[pList[groupid][j]].GetID()]=i;
                delete[] pList[groupid];
            }
            delete pq;
        }
        //else printf("No groups found.\n");

        //free memory
        delete[] pList;
        delete[] pCount;
        delete[] pLen;
        delete[] pGroupHead;

        numgroup=iGroup;
        return pGroup;
    }

    Int_t *KDTree::FOFNNDistCriterion(FOFcompfunc cmp, Double_t *params, Int_t numNN, Int_t **nnID, Double_t **dist2,
                                      Double_t distfunc(Int_t , Double_t *), Int_t npc, Int_t *npca, Int_t &numgroup, Int_t minnum)
    {
        //declare useful fof arrays
        Int_t *pGroup=new Int_t[numparts];
        Int_t *pGroupHead=new Int_t[numparts];
        Int_t *Fifo=new Int_t[numparts];
        Int_t *pHead=new Int_t[numparts];
        Int_t *pTail=new Int_t[numparts];
        Int_t *pNext=new Int_t[numparts];
        Int_t *pLen=new Int_t[numparts];
        Int_t *pCount, **pList;
        PriorityQueue *pq;


        Int_t iGroup=0,iHead=0,iTail=0,id,iid,target;

        //initial arrays
        for (Int_t i=0;i<numparts;i++) {
            pGroup[i]=0;
            pHead[i]=pTail[i]=i;
            pNext[i]=-1;
        }

        for (Int_t i=0;i<numparts;i++){
            //if particle already member of group, ignore and go to next particle
            id=bucket[i].GetID();
            if(pGroup[id]!=0) continue;
            pGroup[id]=++iGroup;
            pLen[iGroup]=1;
            pGroupHead[iGroup]=i;
            Fifo[iTail++]=i;

            //if reach the end of particle list, set iTail to zero and wrap around
            if(iTail==numparts) iTail=0;
            //continue search for this group until one has wrapped around such that iHead==iTail
            while(iHead!=iTail) {
                target=Fifo[iHead++];
                if (iHead==numparts) iHead=0;

                //now begin search.
                //look at near neighbours that meet criteria.
                double newdist=distfunc(numNN,dist2[target]);
                for (Int_t k=0;k<npc;k++) params[npca[k]]=newdist;
                for (Int_t j = 0; j < numNN; j++)
                {
                    iid=bucket[nnID[target][j]].GetID();
                    if (pGroup[iid]==iGroup) continue;
                    if (cmp(bucket[target],bucket[nnID[target][j]],params)) {
                        //If criteria met and particle already member of another group, join groups by
                        //going through old group, change ids to new group and change head and tail appropriately
                        if (pGroup[iid]>0) {
                            Int_t oldGroup=pGroup[iid],oldHead=pGroupHead[oldGroup],oldTail=pTail[oldHead],currentTail=pTail[pGroupHead[iGroup]],ii;
                            //adjust ids
                            ii=oldHead;
                            do {
                                pGroup[bucket[ii].GetID()]=iGroup;
                                pHead[ii]=pGroupHead[iGroup];
                            } while ((ii=pNext[ii])!=-1);
                            ii=currentTail;
                            do {
                                pTail[ii]=oldTail;
                            } while ((ii=pNext[ii])!=-1);
                            pLen[iGroup]+=pLen[oldGroup];
                            pLen[oldGroup]=-1;
                            //now link groups by setting next to current particle and adjust tail and Head
                            pNext[currentTail]=oldHead;
                            pTail[pGroupHead[iGroup]]=oldTail;
                            pHead[oldHead]=pGroupHead[iGroup];
                        }
                        //othersise adjust group id and head, tail pointer appropriately
                        else {

                            pGroup[iid]=iGroup;
                            Fifo[iTail++]=nnID[target][j];
                            pLen[iGroup]++;

                            pNext[pTail[pGroupHead[iGroup]]]=nnID[target][j];
                            pTail[pGroupHead[iGroup]]=nnID[target][j];
                            pHead[nnID[target][j]]=pGroupHead[iGroup];
                            if(iTail==numparts)iTail=0;
                        }
                    }
                }
            }
        }

        //free memory
        delete[] Fifo;
        delete[] pHead;
        delete[] pTail;
        delete[] pNext;

        //generate pList array to store go through particle list and generate linked list
        pList=new Int_t*[iGroup+1];
        pCount=new Int_t[iGroup+1];
        for (Int_t i=1;i<=iGroup;i++) if (pLen[i]>0) {pList[i]=new Int_t[pLen[i]];pCount[i]=0;}
        for (Int_t i=0;i<numparts;i++) {
            Int_t gid=pGroup[bucket[i].GetID()];
            if (gid>0)
                if(pLen[gid]>0)
                    pList[gid][pCount[gid]++]=i;
        }
        //now determine largest group, number of groups that are above minimum number
        numgroup=iGroup;
        for (Int_t i=1;i<=numgroup;i++){
            if(pLen[i]<minnum) {
                //two possibilities:  if pLen[i]=-1,group joined with another groupid
                //if this group was not joined with another then head should have the correct group id and then remove it by setting the ids to zero
                //if (pGroup[bucket[pGroupHead[i]].GetID()]==i) {
                if (pLen[i]>0) for (Int_t j=0;j<pLen[i];j++) pGroup[bucket[pList[i][j]].GetID()]=0;
                pLen[i]=0;
                iGroup--;
            }
        }
        //now order groups
        if (iGroup) {
            pq=new PriorityQueue(iGroup);
            for (Int_t i = 1; i <=numgroup; i++) if (pLen[i]>0) pq->Push(i, pLen[i]);
            //printf("Found %d groups. Largest is %d with %d particles.\n",iGroup,1,(Int_t)pq->TopPriority());
            for (Int_t i = 1; i<=iGroup; i++) {
                Int_t groupid=pq->TopQueue(),size=pq->TopPriority();pq->Pop();
                for (Int_t j=0;j<size;j++) pGroup[bucket[pList[groupid][j]].GetID()]=i;
                delete[] pList[groupid];
            }
            delete pq;
        }
        //else printf("No groups found.\n");

        //free memory
        delete[] pList;
        delete[] pCount;
        delete[] pLen;
        delete[] pGroupHead;

        numgroup=iGroup;
        return pGroup;
    }

    //similar to combination of FOFCriterion and FOFNNDistCriterion in that pass the distance array of nearest neighbours to a function to set the value of a particular parameter in comparison function
    //the number of parameters to change and the index of the parameters is passed in npc and npca
    /*Int_t *KDTree::FOFNNDistScalingCriterion(int cmp(Particle, Particle, Double_t *), Double_t *params, Int_t numNN, Double_t *dist2, Double_t disfunc(Int_t , Double_t *), Int_t npc, Int_t *npca, Int_t &numgroup, Int_t minnum)
    {
        //declare useful fof arrays
        Int_t *pGroup=new Int_t[numparts];
        Int_t *pGroupHead=new Int_t[numparts];
        Int_t *Fifo=new Int_t[numparts];
        Int_t *pHead=new Int_t[numparts];
        Int_t *pTail=new Int_t[numparts];
        Int_t *pNext=new Int_t[numparts];
        Int_t *pLen=new Int_t[numparts];
        Int_t *pCount, **pList;
        PriorityQueue *pq;


        Int_t iGroup=0,iHead=0,iTail=0,id,iid,target;

        //initial arrays
        for (Int_t i=0;i<numparts;i++) {
            pGroup[i]=0;
            pHead[i]=pTail[i]=i;
            pNext[i]=-1;
        }

        ///???

    }*/

    //algorithm same as above but start at specific target particle
    Int_t KDTree::FOFCriterionParticle(FOFcompfunc cmp, Int_t *pfof, Int_t target, Int_t iGroup, Double_t *params, Int_tree_t *pGroupHead, Int_tree_t *Fifo, Int_tree_t *pHead, Int_tree_t *pTail, Int_tree_t *pNext, Int_tree_t *pLen)
    {
        Int_t *pGroup=pfof;
        short *pBucketFlag=new short[numnodes];

        Int_t nsize;
        Double_t off[6];

        Int_t iHead=target,iTail=target,iid;
        Int_t oldtail,oldidval;
        pLen[iGroup]=0;
        //initial arrays
        for (Int_t i=numparts-1;i>=0;i--) if (pGroup[i]==iGroup) {oldtail=i;break;}
        for (Int_t i=0;i<numparts;i++) {
            if (pGroup[i]==iGroup) {
                pLen[iGroup]++;
                pHead[i]=target;
                pTail[i]=oldtail;
            }
            pHead[i]=pTail[i]=i;
            pNext[i]=-1;
        }
        oldidval=target;
        for (Int_t i=target+1;i<numparts;i++) {
            if (pGroup[i]==iGroup) {
                pNext[oldidval]=i;
                oldidval=i;
            }
        }
        for (Int_t i=0;i<numnodes;i++) pBucketFlag[i]=0;
        //reset the group array for targets group

        pGroupHead[iGroup]=target;
        Fifo[iTail++]=target;

        //if reach the end of particle list, set iTail to zero and wrap around
        if(iTail==numparts) iTail=0;
        //continue search for this group until one has wrapped around such that iHead==iTail
        while(iHead!=iTail) {
            iid=Fifo[iHead++];
            if (iHead==numparts) iHead=0;
            for (int j = 0; j < 6; j++) off[j] = 0.0;
            root->FOFSearchCriterion(0.0,cmp,params,iGroup,numparts,bucket,pGroup,pLen,pHead,pTail,pNext,pBucketFlag, Fifo,iTail,off,iid);
        }
        nsize=pLen[iGroup];
        delete[] pBucketFlag;

        return nsize;
    }

}
