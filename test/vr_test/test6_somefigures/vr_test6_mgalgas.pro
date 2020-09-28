PRO vr_test6_mgalgas, settings, n_snap, rfact=rfact, n_pix=n_pix, skip=skip, drange=drange, proj=proj, eps=eps, weight=weight, kernel=kernel, id=id

IF ~KEYWORD_SET(skip) THEN BEGIN
	;;-----
	;; Read Galaxies
	;;-----

	;GAL	= f_rdgal(settings, n_snap, [settings.column_list, 'ABmag', 'SFR'], id=id)
	;PTCL	= f_rdptcl(settings, id, /p_pos, /p_mass, /p_flux, /p_gyr, flux_list=settings.flux_list, $
	;	num_thread=settings.num_thread, n_snap=n_snap, /longint)
	;AMR	= f_rdamr(settings, id, n_snap=n_snap, rfact=rfact)

	;save, filename=settings.root_path + 'test/vr_test/test6*/dumm.sav', GAL, PTCL, AMR
	RESTORE, settings.root_path + 'test/vr_test/test6*/dumm.sav'

	IF KEYWORD_SET(eps) THEN $
		cgPS_open, settings.root_path + 'test/vr_test/test6*/Mgal_' + $
		STRTRIM(proj,2) + '_' + STRTRIM(weight,2) + '.eps', /encapsulated

	dsize	= [1600., 400.]
	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=1.5 & !p.color=255B
	xr	= [-GAL.r_halfmass, GAL.r_halfmass] * rfact
	yr	= xr

	;;-----
	;; Mass Map
	;;-----
	pos	= [0.00, 0.0, 0.25, 1.0]
	cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, $
		xstyle=4, ystyle=4, /nodata, background='black'

	draw_gal, PTCL.xp, PTCL.mp, GAL, 0L, xr=xr, yr=yr, proj=proj, n_pix=n_pix, num_thread=settings.num_thread, $
		maxis=[0L, 1L], ctable=0L, /logscale, $
		dsize=dsize(0), position=pos, kernel=kernel, drange=drange

	;;-----
	;; U-band
	;;-----
	pos	= [0.25, 0.0, 0.5, 1.0]
	cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, $
		xstyle=4, ystyle=4, /nodata, background='black', /noerase
	draw_gal, PTCL.xp, PTCL.F_u, GAL, 0L, xr=xr, yr=yr, proj=proj, n_pix=n_pix, num_thread=settings.num_thread, $
		maxis=[0L, 1L], ctable=0L, /logscale, $
		dsize=dsize(0), position=pos, kernel=kernel, drange=drange


	;;;-----
	;;; Density
	;;;-----
	pos	= [0.5, 0.0, 0.75, 1.0]

	cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, /noerase, xstyle=4, ystyle=4, background='black'
	draw_gas, amr, GAL, 0L, xr=xr, yr=yr, /density, position=pos, dir_lib=settings.dir_lib, maxlev=5L

	;;-----
	;; Temperature
	;;-----
	pos	= [0.75, 0.0, 1.0, 1.0]
	cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, /noerase, xstyle=4, ystyle=4, background='black'
	draw_gas, amr, GAL, 0L, xr=xr, yr=yr, /temperature, position=pos, dir_lib=settings.dir_lib, maxlev=5L
	IF KEYWORD_SET(eps) THEN cgPS_close
ENDIF

END
