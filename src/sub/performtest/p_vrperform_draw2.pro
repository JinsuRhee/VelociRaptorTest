PRO p_vrperform_draw2, settings, data, eps=eps

	P_VRPerform_draw2_data, settings, GAL, density, n_snap=200L, dencutval=[0.1, 0.5, 1.0], /save


	dsize	= [800., 800.]
	width	= 0.8
	height	= width * dsize(0)/dsize(1)
	hgap	= 0.16
	vgap 	= 0.12

	IF settings.P_VRPerform_eps THEN $
		cgPS_open, settings.root_path + 'images/' + settings.P_VRPerform_draw2_iname, /encapsulated

	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=2.0 & !p.charthick=5.0

	xr	= [1e8, 1e11]
	yr	= [1e6, 1e11]
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /ylog, $
		xtitle=textoidl('Stellar Mass [M' + sunsymbol() + ']'), $
		ytitle=textoidl('\rho_{0} [M' + sunsymbol() + ' Kpc^{-3}]')

	P_VRPerform_draw2_pan1, GAL, density, xr=xr
	
	IF settings.P_VRPerform_eps THEN cgPS_close

END
