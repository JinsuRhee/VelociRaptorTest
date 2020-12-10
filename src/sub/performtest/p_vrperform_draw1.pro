PRO p_vrperform_draw1, settings, data, eps=eps

	;P_VRPerform_draw1_data, settings, GAL, density, n_snap=200L, dencutval=[0.1, 0.5, 1.0], /save


	dsize	= [800., 800.]
	width	= 0.8
	height	= width * dsize(0)/dsize(1)
	hgap	= 0.15
	vgap	= 0.08

	IF settings.P_VRPerform_eps EQ 1L THEN $
		cgPS_open, settings.root_path + '/images/' + settings.P_VRPerform_draw1_iname, /encapsulated

	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=1.5 & !p.charthick=3.0
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

;;;	cgDisplay, 800, 800
;;;	cgPlot, data.xxx.fof3d.ngroup, data.xxx.fof3d.time, psym=16, symsize=0.8, /xlog, /ylog, yrange=[1e0, 1e5]
;;;	cgOplot, data.ooo.fof3d.ngroup, data.ooo.fof3d.time, psym=16, symsize=0.8, color='red'
;;;	;cgOplot, data.xox.fof3d.ngroup, data.xox.fof3d.time, psym=16, symsize=0.8, color='blue'
;;;
;;;	a	= LINFIT(ALOG10(data.xxx.fof3d.ngroup), ALOG10(data.xxx.fof3d.time))
;;;	b	= LINFIT(ALOG10(data.ooo.fof3d.ngroup), ALOG10(data.ooo.fof3d.time))
;;;
;;;	xx	= FINDGEN(100)/99 * 2. + 5.
;;;	y1	= a(0) + xx * a(1)
;;;	y2	= b(0) + xx * b(1)
;;;
;;;	cgOplot, 10^xx, 10^y1, linestyle=0, thick=3
;;;
;;;	cgOplot, 10^xx, 10^y2, linestyle=0, color='red', thick=3
;;;
;;;	FOR i=0L, 19L DO BEGIN
;;;		ydum	= (xx-5)*2.0 + i - 10
;;;		cgOplot, 10^xx, 10^ydum, linestyle=2
;;;
;;;		ydum	= 10^xx * xx / (5.0*10^(i-10.))
;;;		cgOplot, 10^xx, ydum, linestyle=2, color='red'
;;;	ENDFOR	
;;;	PRINT, a(1), b(1)
;;;	STOP
;;;	IF settings.P_VRPerform_eps EQ 1L THEN $
;;;		cgPS_open, settings.root_path + 'images/' + settings.P_VRPerform_draw1_iname1, /encapsulated
;;;
;;;	Symsize1= 0.4
;;;	color1	= 'dark grey'
;;;	color2	= 'dodger blue'
;;;	Dsize	= [1800., 1200.]
;;;	cgDisplay, Dsize(0), Dsize(1)
;;;	!p.font = -1 & !p.charsize=0.85 & !p.charthick=3.0
;;;
;;;	;;-----
;;;	;; # 200
;;;	;;-----
;;;	Pos	= [0.06, 0.59, 0.32, 0.98]
;;;	cgPlot, data.xxxxx.fof3d.ngroup, data.xxxxx.fof3d.time, psym=16, symsize=symsize1, /xlog, /ylog, $
;;;		xtitle = '# of Ptcls in a FOF', ytitle='Time [s]', position=Pos, color=color1
;;;	cgOplot, data.xxxxx.fof6d.ngroup, data.xxxxx.fof6d.time, psym=16, symsize=symsize1, color=color2
;;;
;;;	STOP
;;;	cgLegend, /center_sym, /data, colors=['white', 'white'], $
;;;		location=[1.3e6, 2e1], psyms=[16, 16], titles=['3DFOF', '6DFOF'], length=0., vspace=2., $
;;;		charsize=1.0, charthick=3.0
;;;
;;;	cgLegend, /center_sym, /data, colors=[color1, color2], $
;;;		location=[1.5e6, 1.75e1], psyms=[16, 16], length=0., vspace=2., titles=[' ', ' ']
;;;	cgText, 1.5e5, 2e4, 'Snap# 200', alignment=0, charsize=1.0, charthick=3.0, /data
;;;
;;;	Pos	= [0.39, 0.59, 0.65, 0.98]
;;;	cgPlot, data.xxxxx.fof3d.svisit, data.xxxxx.fof3d.time, psym=16, symsize=symsize1, /xlog, /ylog, $
;;;		xtitle = 'Visiting Times (Split Node)', ytitle='Time [s]', position=Pos, /noerase, $
;;;		color=color1
;;;	cgOplot, data.xxxxx.fof6d.svisit, data.xxxxx.fof6d.time, psym=16, symsize=symsize1, color=color2
;;;
;;;	Pos	= [0.72, 0.59, 0.98, 0.98]
;;;	cgPlot, data.xxxxx.fof3d.lvisit, data.xxxxx.fof3d.time, psym=16, symsize=symsize1, /xlog, /ylog, $
;;;		xtitle = 'Visiting Times (Leaf Node)', ytitle='Time [s]', position=Pos, /noerase, $
;;;		color=color1
;;;	cgOplot, data.xxxxx.fof6d.lvisit, data.xxxxx.fof6d.time, psym=16, symsize=symsize1, color=color2
;;;
;;;	;;----
;;;	;; # 600
;;;	;;-----
;;;	Pos	= [0.06, 0.09, 0.32, 0.48]
;;;	cgPlot, data.xxxxx.fof3d.ngroup, data.xxxxx.fof3d.time, psym=16, symsize=symsize1, /xlog, /ylog, $
;;;		xtitle = '# of Ptcls in a FOF', ytitle='Time [s]', position=Pos, color=color1, /noerase, /nodata
;;;	;cgOplot, data.xxxxx.fof6d.ngroup, data.xxxxx.fof6d.time, psym=16, symsize=symsize1, color=color2
;;;
;;;	cgText, 1.5e5, 2e4, 'Snap# 600', alignment=0, charsize=1.0, charthick=3.0, /data
;;;
;;;	Pos	= [0.39, 0.09, 0.65, 0.48]
;;;	cgPlot, data.xxxxx.fof3d.svisit, data.xxxxx.fof3d.time, psym=16, symsize=symsize1, /xlog, /ylog, $
;;;		xtitle = 'Visiting Times (Split Node)', ytitle='Time [s]', position=Pos, /noerase, $
;;;		color=color1, /nodata
;;;	;cgOplot, data.xxxxx.fof6d.svisit, data.xxxxx.fof6d.time, psym=16, symsize=symsize1, color=color2
;;;
;;;	Pos	= [0.72, 0.09, 0.98, 0.48]
;;;	cgPlot, data.xxxxx.fof3d.lvisit, data.xxxxx.fof3d.time, psym=16, symsize=symsize1, /xlog, /ylog, $
;;;		xtitle = 'Visiting Times (Leaf Node)', ytitle='Time [s]', position=Pos, /noerase, $
;;;		color=color1, /nodata
;;;	;cgOplot, data.xxxxx.fof6d.lvisit, data.xxxxx.fof6d.time, psym=16, symsize=symsize1, color=color2
;;;	IF settings.P_VRPerform_eps EQ 1L THEN cgPS_Close
;;;
;;;	STOP
;;
;;	;;-----
;;	;;
;;	;;-----
;;	IF KEYWORD_SET(eps) THEN cgPS_open, settings.root_path + 'images/' + settings.P_VRPerform_draw1_iname2, /encapsulated
;;
;;	DSize	= [1600., 800.]
;;	cgDisplay, Dsize(0), Dsize(1)
;;	!p.font = -1 & !p.charsize=1.0 & !p.charthick=2.0
;;
;;	Pos	= [0.08, 0.18, 0.48, 0.98]
;;	cgPlot, data.xxxxx.fof3d.svisit, data.xxxxx.fof3d.time, psym=16, symsize=0.6, /xlog, /ylog, $
;;		xtitle = '# of Visiting Times (Split Node)', Ytitle='Time [s]', Position=Pos
;;	cgOplot, data.xoooo.fof3d.svisit, data.xoxxx.fof3d.time, psym=16, color='red'
;;
;;	cgOplot, data.ooooo.fof3d.svisit, data.ooooo.fof3d.time, psym=16, color='blue'
;;
;;	Pos	= [0.58, 0.18, 0.98, 0.98]
;;	cgPlot, data.xoooo.fof3d.ngroup, data.xxxxx.fof3d.time/data.xoooo.fof3d.time, psym=16, symsize=0.6, color='red', /xlog, /ylog, $
;;		xtitle = '# of Ptcls in a FOF', Ytitle='Speed Gain', Position=Pos, /noerase
;;	cgOplot, data.ooooo.fof3d.ngroup, data.xxxxx.fof3d.time/data.ooooo.fof3d.time, psym=16, symsize=0.6, color='blue'
;;	IF KEYWORD_SET(eps) THEN cgPS_Close
;;	STOP
END
