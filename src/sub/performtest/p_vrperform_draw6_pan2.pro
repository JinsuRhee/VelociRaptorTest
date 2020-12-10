PRO P_VRPerform_draw6_pan2, data, symsize=symsize, symcolor=symcolor, orgcolor=orgcolor, pos=pos, xr=xr

	;cgOplot, data.xxx.fof3d.ngroup, data.xxx.fof3d.lvisit, psym=9, color=symcolor(0), symsize=symsize(0)
	;cgOplot, data.xxx.fof6d.ngroup, data.xxx.fof6d.lvisit, psym=9, color=symcolor(1), symsize=symsize(0)

	;cgOplot, data.xxo.fof3d.ngroup, data.xxo.fof3d.lvisit, psym=16, color=orgcolor(0), symsize=symsize(1)
	;cgOplot, data.xxo.fof6d.ngroup, data.xxo.fof6d.lvisit, psym=16, color=orgcolor(1), symsize=symsize(1)

	cgOplot, [1e5, 1e8], [1., 1.], linestyle=1, thick=3, color='dark grey'
	cgOplot, data.xxo.fof3d.ngroup, data.xxo.fof3d.lvisit * 1.0d / data.xxx.fof3d.lvisit, $
		psym=16, color=orgcolor(0), symsize=symsize(0)
	cgOplot, data.xxo.fof6d.ngroup, data.xxo.fof6d.lvisit * 1.0d / data.xxx.fof6d.lvisit, $
		psym=16, color=orgcolor(1), symsize=symsize(0)

        !p.charsize=1.0
        ;cgLegend, /center_sym, colors=['white', 'white', 'white', 'white'], psyms=[9, 9, 16, 16], $
        ;        titles=['3D_FOF Org', '6D_FOF Org', '3D_FOF w/ NS', '6D_FOF w/ NS'], $
        ;        location=[pos(0) + (pos(2)-pos(0))*0.6, pos(1) + (pos(3) - pos(1))*0.3], $
        ;        alignment=0, length=0, vspace=2.5, symsize=0.01, charthick=4.0

        ;cgLegend, /center_sym, colors=[symcolor, orgcolor], psyms=[9, 9, 16, 16], $
        ;        titles=[' ', ' ', ' ', ' '], $
        ;        location=[pos(0) + (pos(2)-pos(0))*0.6, pos(1) + (pos(3) - pos(1))*0.295], $
        ;        alignment=0, length=0, vspace=2.5, symsize=1.5, charthick=3.0

	cgAxis, xaxis=0, xstyle=1, xr=xr, xtickv=[1e5, 1e6, 1e7], $
		xtickn=[' ', ' ', ' '], /save
	cgAxis, xaxis=1, xstyle=1, xr=xr, xtickv=[1e5, 1e6, 1e7], xtickn=[' ', ' ', ' '], /save
END
