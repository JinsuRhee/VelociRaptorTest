PRO P_VRPerform_draw3_pan2, data, pos=pos, symsize=symsize, xr=xr, yr=yr, lcolor=lcolor, symcolor=symcolor, orgcolor=orgcolor, csize=csize

		a	= LINFIT(ALOG10(data.xox.fof3d.ngroup), ALOG10(data.xox.fof3d.stime))
		b	= LINFIT(ALOG10(data.xox.fof6d.ngroup), ALOG10(data.xox.fof6d.stime))

		xx	= FINDGEN(100)/99. * 3.0 + 5.0

	FOR i=0L, 19L DO BEGIN
		ydum	= 10^xx * xx / (5.0*10^(i-10.))
		cgOplot, 10^xx, ydum, linestyle=1
	ENDFOR

	cgOplot, data.xxx.fof3d.ngroup, data.xxx.fof3d.stime, psym=9, color=symcolor(0), symsize=symsize(0)
	cgOplot, data.xxx.fof6d.ngroup, data.xxx.fof6d.stime, psym=9, color=symcolor(1), symsize=symsize(0)

	cgOplot, data.xox.fof3d.ngroup, data.xox.fof3d.stime, psym=16, color=orgcolor(0), symsize=symsize(1)
	cgOplot, data.xox.fof6d.ngroup, data.xox.fof6d.stime, psym=16, color=orgcolor(1), symsize=symsize(1)

	cgOplot, 10^xx, 10^(a(0) + a(1) * xx), linestyle=2, thick=4, color=lcolor(0)
	cgOplot, 10^xx, 10^(b(0) + b(1) * xx), linestyle=2, thick=4, color=lcolor(1)

		x0	= 1.5e5
		x1	= 2.5e6
		y0	= 1.5e4
		y1	= 5e4
	cgColorFill, [x0, x1, x1, x0, x0], [y0, y0, y1, y1, y0], color='white', /data
	cgText, 1.5e5, 2e4, 'Split Only', /data, alignment=0, charsize=csize(0)

	cgAxis, xaxis=0, xstyle=1, xrange=xr, xtitle=textoidl('# of FOF particles'), /xlog, /save
	cgAxis, yaxis=0, ystyle=1, yrange=yr, /ylog, /save, $
		ytickv=[1e0, 1e1, 1e2, 1e3, 1e4, 1e5], ytickn=[' ', ' ', ' ', ' ', ' ', ' ']

	cgAxis, xaxis=1, xstyle=1, xrange=xr, xtickv=[1e5, 1e6, 1e7], xtickn=[' ', ' ', ' '], /xlog, /save
	cgAxis, yaxis=1, ystyle=1, yrange=yr, /ylog, ytickv=[1e0, 1e1, 1e2, 1e3, 1e4, 1e5], $
		ytickn=[' ', ' ', ' ', ' ', ' ', ' '], /save
	;cgText, (pos(2) + pos(0))/2, pos(3)*1.1, textoidl('Mass [M' + sunsymbol() + ']'), alignment=0.5, /normal
END
