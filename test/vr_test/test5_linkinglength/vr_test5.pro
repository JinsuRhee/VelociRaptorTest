PRO vr_test5, settings

	;;-----
	;; General Settings
	;;-----
	n_snap = 30L

	;;-----
	;; Read Data
	;;-----

	vr_test5_rdvr, settings, vr, g1, g1_raw, n_snap=n_snap, /save

	;;-----
	;; 2D Map
	;;-----
	npix	= 1000L
	bb	= [0.001,0.001]*2.*0.5
	ctable	= 0
	vr_test5_2dmap, settings, vr, g1, g1_raw, n_snap=n_snap, $
	       npix=npix, maxis=[0L, 1L], rfact=0.3, $
	       kernel=1, bandwidth=bb, ctable=ctable, drange=[3., 7.], /raw

	stop
END
