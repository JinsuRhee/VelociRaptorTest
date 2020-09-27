PRO vr_test6, settings

	n_snap = 140L

	;;-----
	;; 2D Map
	;;-----
	xr	= [19000., 33000.]
	yr	= [19000., 33000.]
	bandwidth= [3., 3.]
	n_pix	= 2000L
	ctable	= 0L

	;; Original Map
	vr_test6_ptclmap1, settings, n_snap, dsize=[800., 800.], $
		xr=xr, yr=yr, bandwidth=bandwidth, n_pix=n_pix, ctable=ctable, /save, /eps, /skip

	;; Massive Galaxie
	n_pix	= 2000L
	rfact	= 20.0
	;bw	= [2.0d, 2.0d] * 1.0d-3
	drange	= [2.0, 6.5]
	proj	= 'edgeon'
	weight	= 'mass'
	vr_test6_mgal, settings, n_snap, rfact=rfact, n_pix=n_pix, kernel=1L, drange=drange, proj=proj, weight=weight, /eps, /skip

	weight = 'mass'
	vr_test6_mgalgas, settings, n_snap, rfact=rfact, n_pix=n_pix, kernel=1L, proj='noproj', drange=drange, weight=weight, id=2135L
	STOP
	;;-----
	;; CMD
	;;-----

	vr_test6_figure, settings, n_snap, /f_cmd, /eps, /skip

	STOP

	;; OMP region
	xr	= [-30., 30.] + 14179.7
	yr	= [-30., 30.] + 14377.6
	bandwidth= [0.05, 0.05]
	n_pix	= 2000L
	ctable	= 0L
	vr_test6_ptclmap2, ptcl, settings, n_snap, dsize=[800., 800.], $
		xr=xr, yr=yr, bandwidth=bandwidth, n_pix=n_pix, ctable=ctable, /eps, /skip

	STOP


END
