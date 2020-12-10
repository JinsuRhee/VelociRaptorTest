PRO P_VRPerform_draw6_pan1, data, symsize=symsize, symcolor=symcolor, orgcolor=orgcolor, pos=pos, xr=xr

	;cgOplot, data.xxx.fof3d.ngroup, data.xxx.fof3d.svisit, psym=9, color=symcolor(0), symsize=symsize(0)
	;cgOplot, data.xxx.fof6d.ngroup, data.xxx.fof6d.svisit, psym=9, color=symcolor(1), symsize=symsize(0)

	;cgOplot, data.xxo.fof3d.ngroup, data.xxo.fof3d.svisit, psym=16, color=orgcolor(0), symsize=symsize(1)
	;cgOplot, data.xxo.fof6d.ngroup, data.xxo.fof6d.svisit, psym=16, color=orgcolor(1), symsize=symsize(1)

	cgOplot, [1e5, 1e8], [1., 1.], linestyle=1, thick=3, color='dark grey'
	cgOplot, data.xxx.fof3d.ngroup, data.xxo.fof3d.svisit * 1.0d / data.xxx.fof3d.svisit, $
		psym=16, color=orgcolor(0), symsize=symsize(0)

	cgOplot, data.xxo.fof6d.ngroup, data.xxo.fof6d.svisit * 1.0d / data.xxx.fof6d.svisit, $
		psym=16, color=orgcolor(1), symsize=symsize(0)

        !p.charsize=2.0
        cgLegend, /center_sym, colors=['white', 'white'], psyms=[16, 16], $
                titles=['3D_FOF', '6D_FOF'], $
                location=[pos(0) + (pos(2)-pos(0))*0.6, pos(1) + (pos(3) - pos(1))*0.3], $
                alignment=0, length=0, vspace=2.5, symsize=0.01, charthick=4.0, /box

        cgLegend, /center_sym, colors=[orgcolor], psyms=[16, 16], $
                titles=[' ', ' '], $
                location=[pos(0) + (pos(2)-pos(0))*0.635, pos(1) + (pos(3) - pos(1))*0.255], $
                alignment=0, length=0, vspace=2.5, symsize=1.5, charthick=3.0

	cgAxis, xaxis=0, xstyle=1, xr=xr, xtickv=[1e5, 1e6, 1e7], $
		xtickn=[' ', ' ', ' '], /save
	cgAxis, xaxis=1, xstyle=1, xr=xr, xtickv=[1e5, 1e6, 1e7], xtickn=[' ', ' ', ' '], /save
END
