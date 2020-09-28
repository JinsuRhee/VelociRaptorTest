PRO vr_test7, settings

	n_snap	= 187L
	vr_test7_findgal, settings, n_snap=n_snap, /skip;, /sk_vr;, /sk_yzics

	vr_test7_nbroken, settings, n_snap=n_snap
	STOP
	xr	= [-500.0, 500.0]
	yr	= [-500.0, 500.0]
	weight	= 'mass'
	n_pix	= 1000L
	drange	= [7., 8.]
	id	= 2319L	;; 187
	vr_test7_drawgal, settings, ID=id, n_start=50L, n_final=187L, $
		xr=xr, yr=yr, weight=weight, proj='noproj', n_pix=n_pix, drange=drange, /eps
	STOP
	GOTO, skip
	mcut	= 1e10
	n_snap	= 187L
	gal	= f_rdgal(settings, n_snap, [Settings.column_list])

	ngal = 0
	btree= 0
	mass	= dblarr(900,40)
	FOR i=0L, N_ELEMENTS(gal.id)-1L DO BEGIN
		IF gal.mass_tot(i) lt mcut THEN CONTINUE
		mass_dum	= dblarr(40) - 1.
		mass_dum(0)	= gal.mass_tot(i)

		nn	= 1L
		REPEAT BEGIN
			pid	= gal.progs(i,0)
			IF pid GE 0L AND n_snap-nn GE 151L THEN BEGIN
				dum	= f_rdgal(settings, n_snap-nn, [Settings.column_list], $
					id=pid)

				mass_dum(nn)	= dum.mass_tot(0)
				nn ++
			ENDIF ELSE BEGIN
				pid = -1L
			ENDELSE
		ENDREP UNTIL pid EQ -1L

		mass(ngal,*)	= mass_dum
		ngal ++
		IF mass_dum(1) LT 0. THEN btree ++

		PRINT, ngal, ' / ', i, ' / ', N_ELEMENTS(gal)-1L
	ENDFOR
	SAVE, filename=settings.root_path + 'test/vr_test/test7*/dum.sav', mass
	skip:
	RESTORE, settings.root_path + 'test/vr_test/test7*/dum.sav'
	ind=lindgen(40)+150
	FOR i=0L, 899L DO BEGIN
		cut	= WHERE(mass(i,*) GT 0.)
		;cgPlot, ind(cut), mass(i,cut), linestyle=0, thick=2, /ylog
		if MAX(CUT) EQ 0L THEN PRINT, i
	ENDFOR

	STOP
END
