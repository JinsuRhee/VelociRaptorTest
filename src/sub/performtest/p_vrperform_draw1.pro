PRO p_vrperform_draw1, settings, data, eps=eps

	;P_VRPerform_draw1_data, settings, GAL, density, n_snap=200L, dencutval=[0.1, 0.5, 1.0], /save


	dsize	= [800., 800.]
	width	= 0.75
	height	= width * dsize(0)/dsize(1)
	hgap	= 0.18
	vgap	= 0.12

	IF settings.P_VRPerform_eps EQ 1L THEN $
		cgPS_open, settings.root_path + '/images/' + settings.P_VRPerform_draw1_iname, /encapsulated

	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=2.0 & !p.charthick=5.0
	;;-----
	;; Panel A - Gal ptcl num VS. Time
	;;-----
	xr	= [1e5, 1e7]
	yr	= [1e0, 5e4]
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height]
	cgPlot, 0, 0, /nodata, xstyle=4, ystyle=4, position=pos, xrange=xr, yrange=yr, /xlog, /ylog

	P_VRPerform_draw1_pan1, data, xr, yr

	IF settings.P_VRPerform_eps EQ 1L THEN cgPS_close


END
