PRO vr_test6_ptclmap2, ptcl, settings, n_snap, dsize=dsize, $
	xr=xr, yr=yr, n_pix=n_pix, bandwidth=bandwidth, ctable=ctable, skip=skip, eps=eps

IF ~KEYWORD_SET(skip) THEN BEGIN
	;;-----
	;; Figure Settings
	;;-----

	iname	= settings.root_path + 'test/vr_test/test6*/omp1.eps'
	IF KEYWORD_SET(eps) THEN cgPS_open, iname, /encapsulated
	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=1.5 & !p.color=255B
	

	;;-----
	;; Draw
	;;-----
	cgPlot, 0, 0, xrange=xr, yrange=yr, position=[0., 0., 1., 1.], $
		xstyle=4, ystyle=4, /nodata, background='black'

	x = float(ptcl(*,0))
	y = float(ptcl(*,1))
	z = fltarr(n_elements(x)) + 1e4
	kernel=1L
	js_denmap, x, y, z, xrange=xr, yrange=yr, n_pix=n_pix, dsize=dsize(0), psize=1.0, $
		num_thread=num_thread, kernel=kernel, bandwidth=bandwidth, ctable=ctable, /logscale, $
		dr=[0., 8.]

	lx = [0., 1.409710649] + xr(0) + (xr(1) - xr(0)) * 0.1
	ly = [0., 1.409710649] + yr(0) + (yr(1) - yr(0)) * 0.1

	line	= js_makeline(lx, ly)
	cgOplot, line(*,0), line(*,1), linestyle=0, thick=3, color='white'

	IF KEYWORD_SET(EPS) THEN cgPS_close
ENDIF
END
