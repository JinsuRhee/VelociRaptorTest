FUNCTION read_tree, fname

	nsteps	= 0L
	OPENR, 1, fname, /f77_unformatted
	READU, 1, nsteps
		nb_of_halos     = LONARR(nsteps)
		nb_of_subhalos  = LONARR(nsteps)
	READU, 1, nb_of_halos, nb_of_subhalos
		n_halos_all     = TOTAL(nb_of_halos) + TOTAL(nb_of_subhalos)
	READU, 1
	READU, 1
	READU, 1

		nfathers	= 0L
		nsons		= 0L
		n_all_fathers	= 0L
		n_all_sons	= 0L
		flist_index	= 0L
		slist_index	= 0L
	FOR i=0L, nsteps-1L DO BEGIN
		nhals_now=nb_of_halos(i)+nb_of_subhalos(i)
		FOR j=1, nhals_now DO BEGIN
			READU, 1	;id_tmp
			READU, 1	;bushID
			READU, 1	;st
			READU, 1	;hosts
			READU, 1	;m
			READU, 1	;macc
			READU, 1	;xp
			READU, 1	;vp
			READU, 1	;lp
			READU, 1	;abc
			READU, 1	;energy
			READU, 1	;spin
			READU, 1, nfathers
				n_all_fathers	+= nfathers
				flist_index	+= nfathers

			READU, 1	;F ID
			READU, 1	;F Mass
			READU, 1, nsons
				n_all_sons	+= nsons
			IF(nsons GT 0L) THEN BEGIN
				READU, 1	;s ID
			ENDIF
				slist_index	+= nsons
			READU, 1	;(r,m,t)_vir, c_vel
			READU, 1	;profile
			READU, 1	;particle ID
		ENDFOR
	ENDFOR

	STOP


END
