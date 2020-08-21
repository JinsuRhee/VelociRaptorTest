PRO vr_test6_ptclmap1, settings, n_snap, dsize=dsize, save=save, $
	xr=xr, yr=yr, n_pix=n_pix, bandwidth=bandwidth, ctable=ctable, skip=skip, eps=eps

IF ~KEYWORD_SET(skip) THEN BEGIN

	;;-----
	;; DATA LOAD
	;;-----

	IF KEYWORD_SET(save) THEN ptcl = vr_test6_rdptcl(settings, n_snap, /save)
	IF ~KEYWORD_SET(Save) THEN ptcl = vr_test6_rdptcl(settings, n_snap)

	;;-----
	;; Figure Settings
	;;-----

	iname	= settings.root_path + 'test/vr_test/test6*/org_map_ompreg.eps'
	IF KEYWORD_SET(eps) THEN cgPS_open, iname, /encapsulated
	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=1.5 & !p.color=255B


	;;-----
	;; Draw
	;;-----
	cgPlot, 0, 0, xrange=xr, yrange=yr, position=[0., 0., 1., 1.], $
		xstyle=4, ystyle=4, /nodata, background='black'

	x = float(ptcl.xp(*,0))
	y = float(ptcl.xp(*,1))
	z = fltarr(n_elements(x)) + 1e4
	kernel=1L
	js_denmap, x, y, z, xrange=xr, yrange=yr, n_pix=n_pix, dsize=dsize(0), pos=[0., 0., 1., 1.], $
		num_thread=num_thread, kernel=kernel, bandwidth=bandwidth, ctable=ctable, /logscale, $
		dr=[2., 11.], mode=-1

	STOP
	cut	= where(ptcl.mp GT 1e4)
	cgOplot, ptcl.xp(cut,0), ptcl.xp(cut,1), psym=16, symsize=2.0, color='white'
	;;-----
	;; OMP Domains
	;;-----
	n_omp = 4L & omp_x = fltarr(n_omp,2) & omp_y = fltarr(n_omp,2)

	omp_x(0,*)	= [11765.69524, 17181.858]
	omp_y(0,*)	= [11213.30509, 14345.37914]
	
	omp_x(1,*)	= [11856.33607, 17107.87056]
	omp_y(1,*)	= [14345.37917, 17623.97074]

	omp_x(2,*)	= [11652.64402, 17371.78785]
	omp_y(2,*)	= [10778.81858, 14826.48666]

	omp_x(3,*)	= [11787.41091, 16657.70102]
	omp_y(3,*)	= [14826.48667, 17606.65127]

	;FOR i=0L, 1L DO BEGIN;n_omp - 1L DO BEGIN
	;	line	= js_makeline(omp_x(i,*), omp_y(i,*))
	;	cgOplot, line(*,0), line(*,1), linestyle=0, thick=3, color='white'
	;ENDFOR

	lx = [-30., 30.] + 14179.7
	ly = [-30., 30.] + 14377.6

	line	= js_makeline(lx, ly)
	;cgOplot, line(*,0), line(*,1), linestyle=0, thick=5, color='white'
	IF KEYWORD_SET(eps) THEN cgPS_close
ENDIF
END
