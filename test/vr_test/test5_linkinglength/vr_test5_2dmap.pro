PRO vr_test5_2dmap, settings, vr, g1, g1_raw, n_snap=n_snap, $
	npix=npix, maxis=maxis, rfact=rfact, drange=drange, $
	kernel=kernel, bandwidth=bandwidth, ctable=ctable, raw=raw

	id_vr	= where(vr.mass_tot eq max(vr.mass_tot))
	;;-----
	;; Figure Setting
	;;-----

	dsize=[800., 800.]
	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=1.5 & !p.color=255B
	xr	= [-vr.r_halfmass(id_vr), vr.r_halfmass(id_vr)] * rfact
	yr	= xr

	;;-----
	;; Draw
	;;-----
	cgPlot, 0, 0, xrange=xr, yrange=yr, position=[0., 0., 1., 1.], $
		xstyle=4, ystyle=4, /nodata, background='black'

	IF KEYWORD_SET(raw) THEN BEGIN
		xp = g1_raw.xp & zz = g1_raw.F_g
	ENDIF ELSE BEGIN
		xp = g1.xp & zz = g1.F_g
	ENDELSE

	draw_gal, xp, zz, vr, id_vr, $
		xr=xr, yr=yr, proj='faceon', n_pix=npix, num_thread=settings.num_thread, $
		maxis=maxis, symsize=0.1, ctable=ctable, /logscale, dsize=dsize(0), psize=1.0, $
		kernel=kernel, bandwidth=bandwidth, drange=drange

	print, xr, yr, vr.xc(id_vr), vr.yc(id_vr), vr.zc(id_vr), vr.r_halfmass(id_vr)

END
