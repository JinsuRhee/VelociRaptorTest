PRO vr_test7_nbroken, settings, n_snap=n_snap

	GAL	= f_rdgal(settings, n_snap, [settings.column_list])

	cut	= WHERE(GAL.structuretype GE 10L)
	n_galaxy= N_ELEMENTS(GAL.id(cut))
	mgal	= GAL.mass_tot(cut)
	nbrok	= LONARR(n_galaxy) - 1L
	id	= GAL.id(cut)

	FOR i=0L, n_galaxy-1L DO BEGIN
		id0	= id(i)
		FOR j=187L, 30L, -1L DO BEGIN
			GDUM	= f_rdgal(settings, j, [settings.column_list], id=id0)
			IF GDUM.progs(0) LT 0L THEN BEGIN
				nbrok(i) = j
				BREAK
			ENDIF

			id0	= GAL.progs(0)
		ENDFOR
		PRINT , i, ' / ', n_galaxy, ' / ', nbrok(i)
	ENDFOR

	CUT	= WHERE(nbrok GE 0L)
	nbrok(CUT)	= 187L - nbrok(CUT)
	
	STOP

END	



