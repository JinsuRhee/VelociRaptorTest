PRO P_VRPerform_draw4_pan1, data, symsize=symsize, symcolor=symcolor, orgcolor=orgcolor, pos=pos, xr=xr

	;;-----
	;; Visiting Time Fraction
	;;-----
	cgOplot, data.xxx.fof3d.ngroup, $
		data.xox.fof3d.svisit * 1.0d / data.xxx.fof3d.svisit, psym=16, color=orgcolor(0), symsize=symsize(0)

	;cgOplot, data.xxx.fof6d.ngroup, $
	;	data.xox.fof6d.svisit * 1.0d / data.xxx.fof6d.svisit, psym=16, color=orgcolor(1), symsize=symsize(0)

	;;-----
	;; Closed Fraction
	;;-----
	cgOplot, data.xxx.fof3d.ngroup, data.xox.fof3d.sclosed / data.xox.fof3d.numsnode, $
		psym=9, color=orgcolor(0), symsize=symsize(1)

	;yy	= data.xox.fof6d.sclosed / data.xox.fof6d.numsnode
	;cgOplot, data.xxx.fof6d.ngroup, yy, psym=9, color=orgcolor(1), symsize=symsize(1)

        !p.charsize=1.5
	;cgText, 1e7, 1.1, 'Split Nodes', /data, charthick=5
	cgText, 1e7, 1.1, '3D FOF', /data, charthick=5

	!p.charsize=1.2
        cgLegend, /center_sym, colors=[orgcolor(0), orgcolor(0)], psyms=[16, 9], $
                titles=['Visiting times', 'Closed nodes'], $
                location=[pos(0) + (pos(2)-pos(0))*0.6, pos(1) + (pos(3) - pos(1))*0.4], $
                alignment=0, length=0, vspace=2.5, symsize=1, charthick=4.0, /box
        ;cgLegend, /center_sym, colors=[orgcolor, orgcolor], psyms=[16, 16, 9, 9], $
        ;        titles=['3D_FOF V-times', '6D_FOF V-times', '3D_FOF Closed', '6D_FOF Closed'], $
        ;        location=[pos(0) + (pos(2)-pos(0))*0.6, pos(1) + (pos(3) - pos(1))*0.4], $
        ;        alignment=0, length=0, vspace=2.5, symsize=1, charthick=4.0, /box

        ;cgLegend, /center_sym, colors=[orgcolor], psyms=[16, 16], $
        ;        titles=[' ', ' '], $
        ;        location=[pos(0) + (pos(2)-pos(0))*0.635, pos(1) + (pos(3) - pos(1))*0.255], $
        ;        alignment=0, length=0, vspace=2.5, symsize=1.5, charthick=3.0

	cgOplot, xr, [1., 1.], linestyle=1, thick=3, color='dark grey'

	cgAxis, xaxis=0, xstyle=1, xr=xr, xtickv=[1e5, 1e6, 1e7], $
		xtickn=[' ', ' ', ' '], /save
	cgAxis, xaxis=1, xstyle=1, xr=xr, xtickv=[1e5, 1e6, 1e7], xtickn=[' ', ' ', ' '], /save
END
