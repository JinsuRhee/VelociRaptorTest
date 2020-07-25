PRO vr_test5, settings

	gal=f_rdgal(settings, 21L, $
		[Settings.column_list, 'ABmag', 'SFR'])

	aa=f_rdptcl(gal.id(2321), $
		/p_pos, /p_vel, /p_gyr, /p_sfactor, /p_mass, /p_flux, /p_metal, $
		flux_list=settings.flux_list, $
                dir_lib=settings.dir_lib, $
                dir_raw=settings.dir_raw, $
                dir_save=settings.dir_save, $
                num_thread=settings.num_thread, $
                n_snap=21L, /longint)

	cgDisplay, 800, 800
	!p.font = -1 & !p.charsize=1.5 & !p.color=255B
	xr = [-gal.r_halfmass(2321), gal.r_halfmass(2321)]*5.0
	yr = xr
	cgPlot, 0, 0, xrange=xr, yrange=yr, position=[0.1, 0.1, 0.9, 0.9], $
		xstyle=4, ystyle=4, /nodata, background='black'

	draw_gal, aa.xp, aa.F_g, gal, 2321L, $
		xr=xr, yr=yr, proj='edgeon', n_pix=1000L, num_thread=num_thread, $
		maxis=[0L, 1L], symsize=0.1, ctable=1L, /logscale
	stop
END
