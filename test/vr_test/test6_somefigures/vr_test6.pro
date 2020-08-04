PRO vr_test6, settings

	n_snap = 030L

	;;-----
	;; Read Particles
	;;-----
	ptcl = vr_test6_rdptcl(settings, n_snap, /save)


	;;-----
	;; 2D Map
	;;-----
	xr	= [14000., 18000.]
	yr	= [14000., 18000.]
	bandwidth= [3., 3.]
	n_pix	= 2000L
	ctable	= 0L
	vr_test6_ptclmap1, ptcl, settings, n_snap, dsize=[800., 800.], $
		xr=xr, yr=yr, bandwidth=bandwidth, n_pix=n_pix, ctable=ctable

	STOP


END
