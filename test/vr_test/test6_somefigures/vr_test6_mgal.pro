PRO vr_test6_mgal, settings, n_snap, rfact=rfact, n_pix=n_pix, skip=skip, kernel=kernel, bandwidth=bandwidth, drange=drange, proj=proj, eps=eps, weight=weight

IF ~KEYWORD_SET(skip) THEN BEGIN
	;;-----
	;; Read Galaxies
	;;-----
	GAL	= f_rdgal(settings, n_snap, [settings.column_list, 'ABmag', 'SFR'], id=2345)

	;PTCL	= f_rdptcl(settings, 2345L, /p_pos, /p_mass, /p_flux, /p_gyr, flux_list=settings.flux_list, $
	;	num_thread=settings.num_thread, n_snap=n_snap, /longint)
	;SAVE, filename=settings.root_path + 'test/vr_test/test6*/mgal.sav', ptcl
	RESTORE, settings.root_path + 'test/vr_test/test6*/mgal.sav'

	IF KEYWORD_SET(eps) THEN $
		cgPS_open, settings.root_path + 'test/vr_test/test6*/Mgal_' + $
		STRTRIM(proj,2) + '_' + STRTRIM(weight,2) + '.eps', /encapsulated

	dsize	= [800., 800.]
	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=1.5 & !p.color=255B
	xr	= [-GAL.r_halfmass, GAL.r_halfmass] * rfact
	yr	= xr
	pos	= [0., 0., 1., 1.]
	cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, $
		xstyle=4, ystyle=4, /nodata, background='black'

	IF weight EQ 'u' THEN zz = PTCL.f_u
	IF weight EQ 'g' THEN zz = PTCL.f_g
	IF weight EQ 'mass' THEN zz = PTCL.mp

	draw_gal, PTCL.xp, zz, GAL, 0L, xr=xr, yr=yr, proj=proj, n_pix=n_pix, num_thread=settings.num_thread, $
		maxis=[0L, 1L], ctable=0L, /logscale, $
		dsize=dsize(0), position=position, kernel=kernel, drange=drange

	IF KEYWORD_SET(eps) THEN cgPS_close
ENDIF

END
