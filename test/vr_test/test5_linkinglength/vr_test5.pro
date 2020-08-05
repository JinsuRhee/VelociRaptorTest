PRO vr_test5, settings

	;;-----
	;; Read Data
	;;-----

	vr_test5_rdvr, settings, vr, g1, n_snap=21L, /save

	;;-----
	;; 2D Map
	;;-----
	npix	= 1000L
	bb	= [0.00001,0.00001]
	vr_test5_2dmap, settings, vr, g1, $
	       npix=npix, maxis=[0L, 1L], rfact=3.0, $
	       kernel=1, bandwidth=bb

	stop
END
