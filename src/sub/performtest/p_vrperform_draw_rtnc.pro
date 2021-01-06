;;-----
;; Procedure for sub panels
;;-----
PRO P_VRPerform_draw_rtnc_pan1, data, pos=pos, symsize=symsize, $
	xr=xr, yr=yr, lcolor=lcolor, symcolor=symcolor, orgcolor=orgcolor, csize=csize, pannum=pannum

	;;-----
	;; DATA SET
	;;-----
	x3d	= data.xxx.fof3d.ngroup
	x6d	= data.xxx.fof6d.ngroup
	IF pannum EQ 0L THEN BEGIN
		t3d_aft	= data.xox.fof3d.time
		t3d_org	= data.xxx.fof3d.time

		t6d_aft	= data.xox.fof6d.time
		t6d_org	= data.xxx.fof6d.time
	ENDIF ELSE IF pannum EQ 1L THEN BEGIN
		t3d_aft	= data.xox.fof3d.stime
		t3d_org	= data.xxx.fof3d.stime

		t6d_aft	= data.xox.fof6d.stime
		t6d_org	= data.xxx.fof6d.stime
	ENDIF ELSE IF pannum EQ 2L THEN BEGIN
		t3d_aft	= data.xox.fof3d.ltime
		t3d_org	= data.xxx.fof3d.ltime

		t6d_aft	= data.xox.fof6d.ltime
		t6d_org	= data.xxx.fof6d.ltime
	ENDIF

	;;-----
	;; FIT LINE
	;;-----
		a	= LINFIT(ALOG10(x3d), ALOG10(t3d_aft))
		b	= LINFIT(ALOG10(x6d), ALOG10(t6d_aft))

                xx      = FINDGEN(100)/99. * 3.0 + 5.0

        FOR i=0L, 19L DO BEGIN
                ydum    = 10^xx * xx / (5.0*10^(i-10.))
                cgOplot, 10^xx, ydum, linestyle=1
        ENDFOR

	;;-----
	;; DRAW
	;;-----
        cgOplot, x3d, t3d_org, psym=9, color=symcolor(0), symsize=symsize(0)
        cgOplot, x6d, t6d_org, psym=9, color=symcolor(1), symsize=symsize(0)

        cgOplot, x3d, t3d_aft, psym=16, color=orgcolor(0), symsize=symsize(1)
        cgOplot, x6d, t6d_aft, psym=16, color=orgcolor(1), symsize=symsize(1)

        cgOplot, 10^xx, 10^(a(0) + a(1) * xx), linestyle=2, thick=4, color=lcolor(0)
        cgOplot, 10^xx, 10^(b(0) + b(1) * xx), linestyle=2, thick=4, color=lcolor(1)

	;;-----
	;; LEGEND
	;;-----
	IF pannum EQ 0L THEN BEGIN
	                x0      = pos(0) + (pos(2) - pos(0)) * 0.51
			x1      = pos(0) + (pos(2) - pos(0)) * 0.965
			y0      = pos(1) + (pos(3) - pos(1)) * 0.10
			y1      = pos(1) + (pos(3) - pos(1)) * 0.38
		cgColorFill, [x0, x1, x1, x0, x0], [y0, y0, y1, y1, y0], color='black', /normal
			thick   = 0.003
			x0 += thick/2. & x1 -= thick/2. & y0 += thick & y1 -= thick
		cgColorFill, [x0, x1, x1, x0, x0], [y0, y0, y1, y1, y0], color='white', /normal
		!p.charsize=0.75
		cgLegend, /center_sym, colors=['white', 'white', 'white', 'white'], psyms=[9, 9, 16, 16], $
			titles=['3D_FOF Org', '6D_FOF Org', '3D_FOF w/ NC', '6D_FOF w/ NC'], $
			location=[pos(0) + (pos(2)-pos(0))*0.5, pos(1) + (pos(3) - pos(1))*0.35], $
			alignment=0, length=0, vspace=1., symsize=0.01, charthick=3.0

		cgLegend, /center_sym, colors=[symcolor, orgcolor], psyms=[9, 9, 16, 16], $
			titles=[' ', ' ', ' ', ' '], $
			location=[pos(0) + (pos(2)-pos(0))*0.55, pos(1) + (pos(3) - pos(1))*0.33], $
			alignment=0, length=0, vspace=1., symsize=0.5, charthick=3.0
		!p.charsize=1.0
	ENDIF

	;;-----
	;; TEXT
	;;-----
	text	= ['All', 'Split Only', 'Leaf Only']
	        x0      = [1.5e5, 1.5e5, 1.5e5]
                x1      = [2.8e5, 2.5e6, 2.5e6]
                y0      = [1.5e4, 1.5e4, 1.5e4]
                y1      = [5e4, 5e4, 5e4]
        cgColorFill, [x0(pannum), x1(pannum), x1(pannum), x0(pannum), x0(pannum)], $
		[y0(pannum), y0(pannum), y1(pannum), y1(pannum), y0(pannum)], color='white', /data
        cgText, 1.5e5, 2e4, text(pannum), /data, alignment=0, charsize=csize(0)

	;;-----
	;; AXIS
	;;-----
        cgAxis, xaxis=0, xstyle=1, xrange=xr, xtitle=textoidl('# of FOF particles'), /xlog, /save
	IF pannum EQ 0L THEN $
        	cgAxis, yaxis=0, ystyle=1, yrange=yr, ytitle=textoidl('Run Time [s]'), $
		ytickv=[1e0, 1e1, 1e2, 1e3, 1e4], yticks=4, yminor=9, $
                ytickn=[textoidl('10^0'), textoidl('10^1'), textoidl('10^2'), $
		textoidl('10^3'), textoidl('10^4')], /ylog, /save
	IF pannum GE 1L THEN $
		cgAxis, yaxis=0, ystyle=1, yrange=yr, /ylog, /save, $
		ytickv=[1e0, 1e1, 1e2, 1e3, 1e4, 1e5], ytickn=[' ', ' ', ' ', ' ', ' ', ' ']
	
        cgAxis, xaxis=1, xstyle=1, xrange=xr, xtickv=[1e5, 1e6, 1e7, 1e8], $
		xtickn=[' ', ' ', ' ', ' '], /save
        cgAxis, yaxis=1, ystyle=1, yrange=yr, /ylog, ytickv=[1e0, 1e1, 1e2, 1e3, 1e4], $
		yticks=4, yminor=9, ytickn=[' ', ' ', ' ', ' ', ' '], /save
END

;;-----
;; SubSub Panels
;;-----

PRO P_VRPerform_draw_rtnc_subpan1, data, pos=pos, xr=xr, yr=yr, $
	symcolor=symcolor, symsize=symsize, pannum=pannum

	;;-----
	;; DATA SET
	;;-----
	x3d	= data.xxx.fof3d.ngroup
	x6d	= data.xxx.fof6d.ngroup
	IF pannum EQ 0L THEN BEGIN
		t3d	= data.xox.fof3d.time / data.xxx.fof3d.time
		t6d	= data.xox.fof6d.time / data.xxx.fof6d.time
	ENDIF ELSE IF pannum EQ 1L THEN BEGIN
		t3d	= data.xox.fof3d.stime / data.xxx.fof3d.stime
		t6d	= data.xox.fof6d.stime / data.xxx.fof6d.stime
	ENDIF ELSE IF pannum EQ 2L THEN BEGIN
		t3d	= data.xox.fof3d.ltime / data.xxx.fof3d.ltime
		t6d	= data.xox.fof6d.ltime / data.xxx.fof6d.ltime
	ENDIF

	;;-----
	;; DRAW
	;;-----
	cut     = WHERE(t3d GT yr(1), ndata)

	cgOplot, x3d, t3d, psym=16, symsize=symsize, color=symcolor(0)

	IF ndata GE 1L THEN $
		cgOplot, x3d(cut), FLTARR(ndata)*0.0 + yr(1), psym=49, color=symcolor(0), symsize=1.5

	cut	= WHERE(t6d GT yr(1), ndata)

	cgOplot, x6d, t6d, psym=16, symsize=symsize, color=symcolor(1)

	IF ndata GE 1L THEN $
		cgOplot, x6d(cut), FLTARR(ndata)*0.0 + yr(1), psym=49, color=symcolor(1), symsize=1.5

        cgOplot, xr, [1., 1.], linestyle=1, thick=3, color='dark grey'

        cgAxis, xaxis=0, xstyle=1, xrange=xr, xtickv=[1e5, 1e6, 1e7, 1e8], $
		xtickn=[' ', ' ' , ' ', ' '], /xlog, xticklen=0.06, /save
	IF pannum EQ 0L THEN $
		cgAxis, yaxis=0, ystyle=1, yrange=yr, ytickv=[0., 0.5, 1.0], $
		ytickn=['0.00', '0.50', '1.00'], yticks=2, $
                yminor=5, ytitle='Frac-', /save
	IF pannum GE 1L THEN $
		cgAxis, yaxis=0, ystyle=1, yrange=yr, ytickv=[0., 0.5, 1.0], $
		ytickn=[' ', ' ', ' '], yticks=2, yminor=5

        cgAxis, xaxis=1, xstyle=1, xrange=xr*8512.4066, xticklen=0.06, /xlog, /save
        cgAxis, yaxis=1, ystyle=1, yrange=yr, ytickv=[0., 0.5, 1.0], ytickn=[' ', ' ', ' '], yticks=2, $
                yminor=5, /save

        cgText, (pos(2) + pos(0))/2, pos(3)*1.08, textoidl('Mass [M' + sunsymbol() + ']'), $
		alignment=0.5, /normal

END

;;-----
;; Main
;;-----
PRO p_vrperform_draw_rtnc, settings, data, eps=eps

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
		cgPS_open, settings.root_path + 'images/' + settings.P_VRPerform_draw_rtnc_iname, /encapsulated

	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=1.0 & !p.charthick=3.0

	xr	= [1e5, 8e7]
	yr	= [1e0, 8e4]
	yr2	= [0., 1.3]
	;;-----
	;; Panel A
	;;-----
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /ylog, xstyle=4, ystyle=4

	P_VRPerform_draw_rtnc_pan1, data, pos=pos, symsize=symsize, xr=xr, yr=yr, $
		lcolor=lcolor, symcolor=symcolor, orgcolor=orgcolor, csize=csize, pannum=0L

	;;-----
	;; Panel A sub
	;;-----
	pos	= [hgap, vgap, hgap, vgap] + [0., height, 0., height] + [0., 0., width, height/3.]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr2, position=pos, /noerase, /xlog, xstyle=4, ystyle=4

	P_VRPerform_draw_rtnc_subpan1, data, pos=pos, xr=xr, yr=yr2, $
		symcolor=orgcolor, symsize=symsize2, pannum=0L

	;;-----
	;; Panel B
	;;-----
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height] + $
		[width, 0, width, 0]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /ylog, /noerase, $
		xstyle=4, ystyle=4

	P_VRPerform_draw_rtnc_pan1, data, pos=pos, symsize=symsize, xr=xr, yr=yr, $
		lcolor=lcolor, symcolor=symcolor, orgcolor=orgcolor, csize=csize, pannum=1L

	;;-----
	;; Panel B sub
	;;-----
	pos	= [hgap, vgap, hgap, vgap] + [0., height, 0., height] + [0., 0., width, height/3.] + $
		[width, 0, width, 0]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr2, position=pos, /noerase, /xlog, xstyle=4, ystyle=4

	P_VRPerform_draw_rtnc_subpan1, data, pos=pos, xr=xr, yr=yr2, $
		symcolor=orgcolor, symsize=symsize2, pannum=1L


	;;-----
	;; Panel C
	;;-----	
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height] + $
		[width, 0, width, 0] + [width, 0, width, 0]

	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /ylog, /noerase, $
		xstyle=4, ystyle=4
		
	P_VRPerform_draw_rtnc_pan1, data, pos=pos, symsize=symsize, xr=xr, yr=yr, $
		lcolor=lcolor, symcolor=symcolor, orgcolor=orgcolor, csize=csize, pannum=2L

	;;-----
	;; Panel C sub
	;;-----
	pos	= [hgap, vgap, hgap, vgap] + [0., height, 0., height] + [0., 0., width, height/3.] + $
		[width, 0, width, 0] * 2.0
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr2, position=pos, /noerase, /xlog, xstyle=4, ystyle=4

	P_VRPerform_draw_rtnc_subpan1, data, pos=pos, xr=xr, yr=yr2, $
		symcolor=orgcolor, symsize=symsize2, pannum=2L

	IF settings.P_VRPerform_eps THEN cgPS_close

END
