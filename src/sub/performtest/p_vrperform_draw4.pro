PRO p_vrperform_draw4, settings, data

	;;-----
	;; Data
	;;-----
	P_VRPerform_rdnc, settings, settings.P_VRPerform_nsnap(0), data2

	dsize	= [800., 1400.]
	width	= 0.80
	height	= width * dsize(0)/dsize(1)
	hgap	= 0.17
	vgap 	= 0.08
	

	symsize	= [1.2, 0.6]
	symcolor= ['blu3', 'pink']
	orgcolor= ['dodger blue', 'coral']
	IF settings.P_VRPerform_eps THEN $
		cgPS_open, settings.root_path + 'images/' + settings.P_VRPerform_draw4_iname, /encapsulated

	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=1.5 & !p.charthick=5.0

	;;-----
	;; Panel A
	;;-----
	xr	= [1e5, 8e7]
	;yr	= [1e7, 5e11]
	yr	= [0., 1.2]
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height] + [0., height, 0., height]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /noerase, $
		ytitle='Fraction', xstyle=4

	P_VRPerform_draw4_pan1, data, symsize=symsize, symcolor=symcolor, orgcolor=orgcolor, pos=pos, xr=xr

	;;-----
	;; Panel B
	;;-----
	!p.charsize=1.5
	pos	= pos - [0., height, 0., height]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=[0., 1.05], position=pos, /xlog, /noerase, $
		xtitle='# of FOF particles', ytitle='Fraction'

	;P_VRPerform_draw4_pan2, data2, orgcolor=orgcolor, symsize=symsize

	IF settings.P_VRPerform_eps THEN cgPS_close

	;;-----
	;; Panel B
	;;-----

	STOP
	;dsize	= [600., 1200.]
	;width	= 0.8
	;height	= width * dsize(0)/dsize(1)
	;hgap	= 0.18
	;vgap 	= 0.08

	;hgap2	= 0.10

	;symsize	= [0.6, 0.3]
	;symcolor= ['blu3', 'pink']
	;orgcolor= ['dodger blue', 'coral']
	;;lcolor	= ['YGB5', 'orange red']
	;;csize	= [1.2]
	;IF settings.P_VRPerform_eps THEN $
	;	cgPS_open, settings.root_path + 'images/' + settings.P_VRPerform_draw4_iname, /encapsulated

	;cgDisplay, dsize(0), dsize(1)
	;!p.font = -1 & !p.charsize=1.5 & !p.charthick=3.0

	;xr	= [1e7, 5e11]
	;yr	= [1e0, 1e5]

	;;;-----
	;;; Panel A
	;;;-----
	;pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height] + [0., hgap2, 0., hgap2] + [0., height, 0., height]
	;cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /ylog, $
	;	xtitle='Split node visiting times', ytitle='Run Time in split nodes [s]'

	;P_VRPerform_draw4_pan1, data, symsize=symsize, symcolor=symcolor, orgcolor=orgcolor

	;;;-----
	;;; Panel B
	;;;-----
	;xr	= [1e5, 8e7]
	;yr	= [1e7, 5e11]
	;pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height]
	;cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /ylog, /noerase, $
	;	xtitle='# of FOF particles', ytitle='Split node visiting times'

	;P_VRPerform_draw4_pan2, data, symsize=symsize, symcolor=symcolor, orgcolor=orgcolor

	;IF settings.P_VRPerform_eps THEN cgPS_close
	STOP
END
