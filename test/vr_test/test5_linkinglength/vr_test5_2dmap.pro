PRO vr_test5_2dmap, settings, vr, g1, $
	npix=npix, maxis=maxis, rfact=rfact, $
	kernel=kernel, bandwidth=bandwidth

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
	cgPlot, 0, 0, xrange=xr, yrange=yr, position=[0.1, 0.1, 0.95, 0.95], $
		xstyle=4, ystyle=4, /nodata, background='black'

	draw_gal, g1.xp, g1.F_g, vr, id_vr, $
		xr=xr, yr=yr, proj='edgeon', n_pix=npix, num_thread=settings.num_thread, $
		maxis=maxis, symsize=0.1, ctable=1L, /logscale, dsize=dsize(0), psize=0.85, $
		kernel=kernel, bandwidth=bandwidth


END
