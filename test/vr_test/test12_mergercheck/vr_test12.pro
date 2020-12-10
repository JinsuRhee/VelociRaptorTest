PRO vr_test12, settings

	;id0	= 2L
	;n0	= 90L
	;n1	= 149L
	;n_snap	= 920L

	id0	= 4L
	n0	= 50L
	n1	= 107L
	n_snap	= 900L

	vr_test12_maketree, settings, tree, nsnap=n_snap, id0=id0, /vr, /skip

	vr_test12_findvr, settings, tree, vr_compid, n0=n0, n1=n1, id0=id0

	IF id0 EQ 4L THEN vr_test12_findyz, settings, tree, yz_compid, n0=n0, n1=n1, id0=id0, nsnap=n_snap

	xr	= [-500., 500.]
	yr	= [-500., 500.]
	n_pix	= 1000L
	;vr_test12_draw, settings, tree, vr_compid, yz_compid, n0=n0, n1=n1, xr=xr, yr=yr, n_pix=n_pix, id0=id0, $
	;	/vr;/yz, /eps




	vr_test12_draw_cft, settings, tree, vr_compid, yz_compid, n0=n0, n1=n1, xr=xr, yr=yr, n_pix=n_pix, id0=id0, $
		/vr, /eps;/yz;, /eps

	STOP

	SKIP:

	;vr_test12_mergeimg, settings, n0, n1
	cftnum	= 0L
	;vr_test12_vdist, settings, id0, n0, n1, vr_compid, tree, cftnum, /eps
	vr_test12_vdist2, settings, id0, n0, n1, vr_compid, tree, cftnum;, /eps
	STOP



END
