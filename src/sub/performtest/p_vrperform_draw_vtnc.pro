;;-----
;; Panel
;;-----
PRO p_vrperform_draw_vtnc_pan1, data, symsize=symsize, symcolor=symcolor, orgcolor=orgcolor, $
	pos=pos, xr=xr, pannum=pannum

	IF pannum EQ 0L THEN BEGIN
		x	= data.xxx.fof3d.ngroup
		vf	= data.xox.fof3d.svisit * 1.0d / data.xxx.fof3d.svisit
		cf	= data.xox.fof3d.sclosed *1.0d / data.xox.fof3d.numsnode
	ENDIF ELSE IF pannum EQ 1L THEN BEGIN
		x	= data.xxx.fof6d.ngroup
		vf	= data.xox.fof6d.svisit * 1.0d / data.xxx.fof6d.svisit
		cf	= data.xox.fof6d.sclosed *1.0d / data.xox.fof6d.numsnode
	ENDIF

        ;;-----
        ;; Visiting Time Fraction
        ;;-----

	cgOplot, x, vf, psym=16, color=orgcolor(pannum), symsize=symsize(0)

	;;-----
	;; Closed Fraction
	;;-----
	
	cgOplot, x, cf, psym=9, color=orgcolor(pannum), symsize=symsize(1)

	;;-----
	;; Text
	;;-----
	text	= ['3D FOF', '6D FOF']

	!p.charsize=1.5
	cgText, 1e7, 1.1, text(pannum), /data, charthick=5

	;;-----
	;; Legend
	;;-----
	!p.charsize=1.2
	cgLegend, /center_sym, colors=[orgcolor(pannum), orgcolor(pannum)], psyms=[16, 9], $
		titles=['Visiting times', 'Closed nodes'], $
		location=[pos(0) + (pos(2)-pos(0))*0.6, pos(1) + (pos(3) - pos(1))*0.4], $
		alignment=0, length=0, vspace=2.5, symsize=1, charthick=4.0, /box
	;;-----
	;; Guide Line
	;;-----
	cgOplot, xr, [1., 1.], linestyle=1, thick=3, color='dark grey'

	;;-----
	;; Axis
	;;-----
        IF pannum EQ 0L THEN $
		cgAxis, xaxis=0, xstyle=1, xr=xr, xtickv=[1e5, 1e6, 1e7], $
                xtickn=[' ', ' ', ' '], /save
        cgAxis, xaxis=1, xstyle=1, xr=xr, xtickv=[1e5, 1e6, 1e7], xtickn=[' ', ' ', ' '], /save

END

;;-----
;; Main
;;-----
PRO p_vrperform_draw_vtnc, settings, data

	;;-----
	;; Data
	;;-----
	;P_VRPerform_rdnc, settings, settings.P_VRPerform_nsnap(0), data2

	dsize	= [800., 1400.]
	width	= 0.80
	height	= width * dsize(0)/dsize(1)
	hgap	= 0.17
	vgap 	= 0.08
	

	symsize	= [1.2, 0.6]
	symcolor= ['blu3', 'pink']
	orgcolor= ['dodger blue', 'coral']
	IF settings.P_VRPerform_eps THEN $
		cgPS_open, settings.root_path + 'images/' + settings.P_VRPerform_draw_vtnc_iname, /encapsulated

	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=1.5 & !p.charthick=5.0

	;;-----
	;; Panel A
	;;-----
	xr	= [1e5, 8e7]
	yr	= [0., 1.25]
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height] + [0., height, 0., height]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /noerase, $
		ytitle='Fraction', xstyle=4

	P_VRPerform_draw_vtnc_pan1, data, symsize=symsize, symcolor=symcolor, $
		orgcolor=orgcolor, pos=pos, xr=xr, pannum=0L

	;;-----
	;; Panel B
	;;-----
	!p.charsize=1.5
	pos	= pos - [0., height, 0., height]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /noerase, $
		xtitle='# of FOF particles', ytitle='Fraction'

	P_VRPerform_draw_vtnc_pan1, data, symsize=symsize, symcolor=symcolor, $
		orgcolor=orgcolor, pos=pos, xr=xr, pannum=1L

	IF settings.P_VRPerform_eps THEN cgPS_close
END
