PRO p_vrperform_draw5, settings, data, eps=eps

	dsize	= [1600., 800.]
	width	= 0.29
	height	= width * dsize(0)/dsize(1)
	hgap	= 0.09
	vgap 	= 0.12
	symsize	= [0.6, 0.45]
	symsize2= 0.5
	symcolor= ['blu3', 'pink']
	orgcolor= ['dodger blue', 'coral']
	lcolor	= ['YGB5', 'orange red']
	csize	= [1.2]
	IF settings.P_VRPerform_eps THEN $
		cgPS_open, settings.root_path + 'images/' + settings.P_VRPerform_draw5_iname, /encapsulated

	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=1.0 & !p.charthick=3.0

	xr	= [1e5, 8e7]
	yr	= [1e0, 8e4]
	yr2	= [0., 1.3]
	;;-----
	;; Panel A
	;;-----
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /ylog, $
		xstyle=4, ystyle=4

	P_VRPerform_draw5_pan1, data, pos=pos, symsize=symsize, xr=xr, yr=yr, lcolor=lcolor, symcolor=symcolor, orgcolor=orgcolor, csize=csize

	;;-----
	;; Panel A sub
	;;-----
	pos	= [hgap, vgap, hgap, vgap] + [0., height, 0., height] + [0., 0., width, height/3.]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr2, position=pos, /noerase, /xlog, xstyle=4, ystyle=4
		;ytickv=[0., 0.5, 1.0], ytickn=['0.00', '0.50', '1.00'], yticks=2, yminor=5, ytitle='Rel- Time'

	P_VRPerform_draw5_pan1sub, data, pos=pos, xr=xr, yr=yr2, symcolor=orgcolor, symsize=symsize2

	;;-----
	;; Panel B
	;;-----
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height] + $
		[width, 0, width, 0]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /ylog, /noerase, $
		xstyle=4, ystyle=4

	P_VRPerform_draw5_pan2, data, pos=pos, symsize=symsize, xr=xr, yr=yr, lcolor=lcolor, symcolor=symcolor, orgcolor=orgcolor, csize=csize

	;;-----
	;; Panel B sub
	;;-----
	pos	= [hgap, vgap, hgap, vgap] + [0., height, 0., height] + [0., 0., width, height/3.] + $
		[width, 0, width, 0]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr2, position=pos, /noerase, /xlog, xstyle=4, ystyle=4

	P_VRPerform_draw5_pan2sub, data, pos=pos, xr=xr, yr=yr2, symcolor=orgcolor, symsize=symsize2


	;;-----
	;; Panel C
	;;-----	
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height] + $
		[width, 0, width, 0] + [width, 0, width, 0]

	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /ylog, /noerase, $
		xstyle=4, ystyle=4
		
	P_VRPerform_draw5_pan3, data, pos=pos, symsize=symsize, xr=xr, yr=yr, lcolor=lcolor, symcolor=symcolor, orgcolor=orgcolor, csize=csize

	;;-----
	;; Panel B sub
	;;-----
	pos	= [hgap, vgap, hgap, vgap] + [0., height, 0., height] + [0., 0., width, height/3.] + $
		[width, 0, width, 0] * 2.0
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr2, position=pos, /noerase, /xlog, xstyle=4, ystyle=4

	P_VRPerform_draw5_pan3sub, data, pos=pos, xr=xr, yr=yr2, symcolor=orgcolor, symsize=symsize2

	IF settings.P_VRPerform_eps THEN cgPS_close

END
