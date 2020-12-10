PRO p_vrperform_draw5, settings, data

	cgDisplay, 800, 800
	cgPlot, data.xxx.fof3d.ngroup, data.xxx.fof3d.time, psym=9, symsize=1.0, color='dodger blue', /xlog, /ylog, /nodata
	cgOplot, data.xxx.fof6d.ngroup, data.xxx.fof6d.time, psym=9, symsize=1.0, color='light coral'

	;cgOplot, data.xxo.fof3d.ngroup, data.xxo.fof3d.time, psym=16, symsize=1.0, color='dodger blue'
	cgOplot, data.xxo.fof6d.ngroup, data.xxo.fof6d.time, psym=16, symsize=1.0, color='light coral'
	print, LINFIT(ALOG10(data.xxo.fof6d.ngroup), ALOG10(data.xxo.fof6d.time))

	;cgOplot, data.xoo.fof3d.ngroup, data.xoo.fof3d.time, psym=16, symsize=1.0, color='blue'
	cgOplot, data.xox.fof6d.ngroup, data.xox.fof6d.time, psym=16, symsize=1.0, color='red'
	print, LINFIT(ALOG10(data.xox.fof6d.ngroup), ALOG10(data.xox.fof6d.time))

	cgOplot, data.oxx.fof6d.ngroup, data.oxx.fof6d.time, psym=16, symsize=1.0, color='green'
	print, LINFIT(ALOG10(data.oxx.fof6d.ngroup), ALOG10(data.oxx.fof6d.time))

	cgOplot, data.xoo.fof6d.ngroup, data.xoo.fof6d.time, psym=16, symsize=1.0, color='blue'
	print, LINFIT(ALOG10(data.xoo.fof6d.ngroup), ALOG10(data.xoo.fof6d.time))

	cgOplot, data.oxo.fof6d.ngroup, data.oxo.fof6d.time, psym=16, symsize=1.0, color='purple'
	print, LINFIT(ALOG10(data.oxo.fof6d.ngroup), ALOG10(data.oxo.fof6d.time))

	cgOplot, data.oox.fof6d.ngroup, data.oox.fof6d.time, psym=16, symsize=1.0, color='orange'
	print, LINFIT(ALOG10(data.oox.fof6d.ngroup), ALOG10(data.oox.fof6d.time))

	cgOplot, data.xoo.fof6d.ngroup, data.xoo.fof6d.time, psym=16, symsize=1.0, color='grey'
	print, LINFIT(ALOG10(data.xoo.fof6d.ngroup), ALOG10(data.xoo.fof6d.time))

	cgOplot, data.ooo.fof6d.ngroup, data.ooo.fof6d.time, psym=16, symsize=1.0, color='dodger blue'
	print, LINFIT(ALOG10(data.ooo.fof6d.ngroup), ALOG10(data.ooo.fof6d.time))
	STOP
	dsize	= [800., 800.]
	width	= 0.8
	height	= width * dsize(0)/dsize(1)
	hgap	= 0.17
	vgap 	= 0.15

	symsize	= [1.2, 0.6]
	symcolor= ['blu3', 'pink']
	orgcolor= ['dodger blue', 'coral']
	IF settings.P_VRPerform_eps THEN $
		cgPS_open, settings.root_path + 'images/' + settings.P_VRPerform_draw4_iname, /encapsulated

	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=2.0 & !p.charthick=5.0

	;;-----
	;; Panel A
	;;-----
	xr	= [1e5, 8e7]
	yr	= [1e7, 5e11]
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /ylog, /noerase, $
		xtitle='# of FOF particles', ytitle='Split node visiting times'

	P_VRPerform_draw4_pan2, data, symsize=symsize, symcolor=symcolor, orgcolor=orgcolor, pos=pos

	IF settings.P_VRPerform_eps THEN cgPS_close

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
