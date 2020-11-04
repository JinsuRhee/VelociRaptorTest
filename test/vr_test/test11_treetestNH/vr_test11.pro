PRO vr_test11, settings

	n_snap	= 900L
	xr	= [-500.0, 500.0]
	yr	= [-500.0, 500.0]
	weight	= 'mass'
	n_pix	= 1000L
	id	= 20L
	vr_test11_drawgal, settings, ID=id, n_start=50L, n_final=187L, $
		xr=xr, yr=yr, weight=weight, proj='noproj', n_pix=n_pix, /eps
	STOP
END
