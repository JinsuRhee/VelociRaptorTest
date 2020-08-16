PRO rv_readtree, output, output2, $
	column_list=column_list, horg=horg, $
	dir_snap=dir_snap, silent=silent, n_snap=n_snap, skip=skip

	;;-----
	;; Skip Process
	;;-----
	IF skip EQ 1L THEN BEGIN
		output2 = {progs:-1}
		RETURN
	ENDIF
	;;-----
	;; General Settings
	;;-----
	dir_tree	= dir_snap + '../tree/'

	;;-----
	;; I/O
	;;-----
	fname	= dir_tree + 'tree.snapshot_' + STRING(n_snap, format="(I3.3)") + $
		'.VELOCIraptor.tree'

	;;-----
	;; READ HDF
	;;-----
	fid	= H5F_OPEN(fname)

	did	= H5D_OPEN(fid, 'NumProgen')
	prognum	= H5D_READ(did)
	H5D_CLOSE, did

	did	= H5D_OPEN(fid, 'ProgenOffsets')
	progoff	= H5D_READ(did)
	H5D_CLOSE, did

	did	= H5D_OPEN(fid, 'Progenitors')
	prog	= H5D_READ(did)
	H5D_CLOSE, did

	H5F_CLOSE, fid

	;;-----
	;; READ PREVIOUS SNAPDATA
	;;-----
	dum	= STRPOS(dir_snap, STRING(n_snap, format='(I3.3)'))
	dum	= STRMID(dir_snap, 0, dum) + STRING(n_snap-1L, format='(I3.3)') + $
		STRMID(dir_snap, dum+3, STRLEN(dir_snap)-1L)
	outpre	= rv_RawCatalog(dir_snap=dum, horg=horg, column_list=column_list, silent=silent)

	;;-----
	;; Find Progenitors and List by their Mass / Distance
	;;-----
	plist_mass	= LONARR(N_ELEMENTS(output.id),10) - 1L
	FOR i=0L, N_ELEMENTS(output.id)-1L DO BEGIN
		IF prognum(i) EQ 0L THEN CONTINUE
		ind1	= progoff(i)
		ind2	= progoff(i) + prognum(i) - 1L
		prog_id	= prog(ind1:ind2)

		mass_dum= dblarr(N_ELEMENTS(prog_id)) - 1.

		FOR j=0L, N_ELEMENTS(prog_id)-1L DO BEGIN
			cut	= WHERE(outpre.id EQ prog_id(j))
			mass_dum(j) = outpre.Mass_tot(cut)
		ENDFOR

		sort_ind= REVERSE(SORT(mass_dum))
		prog_id	= prog_id(sort_ind)
		IF(N_ELEMENTS(prog_id) GT N_ELEMENTS(plist_mass(0,*))) THEN $
			prog_id	= prog_id(0L:N_ELEMENTS(plist_mass(0,*))-1L)
		plist_mass(i,0:N_ELEMENTS(prog_id)-1L)	= prog_id
	ENDFOR

	output2	= {progs:plist_mass}

	RETURN
END
