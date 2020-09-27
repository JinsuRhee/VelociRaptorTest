PRO vr_test9, settings

	n_pix	= 1000L
	n_snap	= 200L
	drange	= [4., 8.5]

	linking	= [0.20, 1.00]
	vr_test9_drawgal, settings, masscut=1e9, n_pix=n_pix, n_snap=n_snap, drange=drange, linking=linking, /eps, /cf
	STOP
	linking	= [0.20, 0.20]
	vr_test9_drawgal, settings, masscut=1e9, n_pix=n_pix, n_snap=n_snap, drange=drange, linking=linking, /eps, /cf

	linking	= [0.20, 0.50]
	vr_test9_drawgal, settings, masscut=1e9, n_pix=n_pix, n_snap=n_snap, drange=drange, linking=linking, /eps, /cf

	linking	= [0.20, 1.00]
	vr_test9_drawgal, settings, masscut=1e9, n_pix=n_pix, n_snap=n_snap, drange=drange, linking=linking, /eps, /cf

	;;----
	;;
	;;----
	linking	= [0.20, 0.20]
	vr_test9_drawgal, settings, masscut=1e9, n_pix=n_pix, n_snap=n_snap, drange=drange, linking=linking, /eps

	linking	= [0.20, 0.50]
	vr_test9_drawgal, settings, masscut=1e9, n_pix=n_pix, n_snap=n_snap, drange=drange, linking=linking, /eps

	linking	= [0.20, 1.00]
	vr_test9_drawgal, settings, masscut=1e9, n_pix=n_pix, n_snap=n_snap, drange=drange, linking=linking, /eps
END
