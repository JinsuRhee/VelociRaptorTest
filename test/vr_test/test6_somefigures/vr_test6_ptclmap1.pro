PRO vr_test6_ptclmap1, ptcl, settings, n_snap, dsize=dsize, $
	xr=xr, yr=yr, n_pix=n_pix, bandwidth=bandwidth, ctable=ctable


	;;-----
	;; Figure Settings
	;;-----

	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=1.5 & !p.color=255B
	

	;;-----
	;; Draw
	;;-----
	cgPlot, 0, 0, xrange=xr, yrange=yr, position=[0.1, 0.1, 0.95, 0.95], $
		xstyle=4, ystyle=4, /nodata, background='black'

	x = float(ptcl(*,0))
	y = float(ptcl(*,1))
	z = fltarr(n_elements(x)) + 1e4
	kernel=1L
	js_denmap, x, y, z, xrange=xr, yrange=yr, n_pix=n_pix, dsize=dsize(0), psize=0.85, $
		num_thread=num_thread, kernel=kernel, bandwidth=bandwidth, ctable=ctable, /logscale, $
		dr=[2., 10.]

END
