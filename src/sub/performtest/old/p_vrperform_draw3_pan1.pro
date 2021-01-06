PRO P_VRPerform_draw3_pan1, data, pos=pos, symsize=symsize, xr=xr, yr=yr, lcolor=lcolor, symcolor=symcolor, orgcolor=orgcolor, csize=csize

		a	= LINFIT(ALOG10(data.xox.fof3d.ngroup), ALOG10(data.xox.fof3d.time))
		b	= LINFIT(ALOG10(data.xox.fof6d.ngroup), ALOG10(data.xox.fof6d.time))

		xx	= FINDGEN(100)/99. * 3.0 + 5.0

	FOR i=0L, 19L DO BEGIN
		ydum	= 10^xx * xx / (5.0*10^(i-10.))
		cgOplot, 10^xx, ydum, linestyle=1
	ENDFOR

	cgOplot, data.xxx.fof3d.ngroup, data.xxx.fof3d.time, psym=9, color=symcolor(0), symsize=symsize(0)
	cgOplot, data.xxx.fof6d.ngroup, data.xxx.fof6d.time, psym=9, color=symcolor(1), symsize=symsize(0)

	cgOplot, data.xox.fof3d.ngroup, data.xox.fof3d.time, psym=16, color=orgcolor(0), symsize=symsize(1)
	cgOplot, data.xox.fof6d.ngroup, data.xox.fof6d.time, psym=16, color=orgcolor(1), symsize=symsize(1)

	cgOplot, 10^xx, 10^(a(0) + a(1) * xx), linestyle=2, thick=4, color=lcolor(0)
	cgOplot, 10^xx, 10^(b(0) + b(1) * xx), linestyle=2, thick=4, color=lcolor(1)

		x0	= pos(0) + (pos(2) - pos(0)) * 0.51
		x1	= pos(0) + (pos(2) - pos(0)) * 0.965
		y0	= pos(1) + (pos(3) - pos(1)) * 0.10
		y1	= pos(1) + (pos(3) - pos(1)) * 0.38
	cgColorFill, [x0, x1, x1, x0, x0], [y0, y0, y1, y1, y0], color='black', /normal
		thick	= 0.003
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

		x0	= 1.5e5
		x1	= 2.8e5
		y0	= 1.5e4
		y1	= 5e4
	cgColorFill, [x0, x1, x1, x0, x0], [y0, y0, y1, y1, y0], color='white', /data
	cgText, 1.5e5, 2e4, 'All', /data, alignment=0, charsize=csize(0)

	cgAxis, xaxis=0, xstyle=1, xrange=xr, xtitle=textoidl('# of FOF particles'), /xlog, /save
	cgAxis, yaxis=0, ystyle=1, yrange=yr, ytitle=textoidl('Run Time [s]'), ytickv=[1e0, 1e1, 1e2, 1e3, 1e4], $
		yticks=4, yminor=9, $
		ytickn=[textoidl('10^0'), textoidl('10^1'), textoidl('10^2'), textoidl('10^3'), textoidl('10^4')], /ylog, /save

	;cgAxis, xaxis=1, xstyle=1, xrange=xr*8512.4066, /xlog, /save
	cgAxis, xaxis=1, xstyle=1, xrange=xr, xtickv=[1e5, 1e6, 1e7, 1e8], xtickn=[' ', ' ', ' ', ' '], /save
	cgAxis, yaxis=1, ystyle=1, yrange=yr, /ylog, ytickv=[1e0, 1e1, 1e2, 1e3, 1e4], yticks=4, yminor=9, $
		ytickn=[' ', ' ', ' ', ' ', ' '], /save
	;cgText, (pos(2) + pos(0))/2, pos(3)*1.1, textoidl('Mass [M' + sunsymbol() + ']'), alignment=0.5, /normal
END
