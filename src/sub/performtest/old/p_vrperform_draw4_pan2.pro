PRO P_VRPerform_draw4_pan2, data, orgcolor=orgcolor, symsize=symsize, pos=pos, xr=xr

	;;-----
	;; Visiting Time Fractin
	;;-----
	cgOplot, data.xxx.fof6d.ngroup, $
		data.xox.fof6d.svisit * 1.0d / data.xxx.fof6d.svisit, psym=16, color=orgcolor(1), $
		symsize=symsize(0)

	;;-----
	;; Closed Fraction
	;;-----
	cgOplot, data.xxx.fof6d.ngroup, data.xox.fof6d.sclosed / data.xox.fof6d.numsnode, $
		psym=9, color=orgcolor(1), symsize=symsize(1)

	;;-----
	;;
	;;-----
	!p.charsize=1.5
	cgText, 1e7, 1.1, '6D FOF', /data, charthick=5

	!p.charsize=1.2
	cgLegend, /center_sym, colors=[orgcolor(1), orgcolor(1)], psyms=[16, 9], $
		titles=['Visiting times', 'Closed nodes'], $
		location=[pos(0) + (pos(2)-pos(0))*0.6, pos(1) + (pos(3) - pos(1))*0.4], $
		alignment=0, length=0, vspace=2.5, symsize=1, charthick=4.0, /box

	cgOplot, xr, [1., 1.], linestyle=1, thick=3, color='dark grey'


END
