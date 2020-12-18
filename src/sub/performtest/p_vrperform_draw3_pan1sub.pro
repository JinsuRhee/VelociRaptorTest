PRO p_vrperform_draw3_pan1sub, data, pos=pos, xr=xr, yr=yr, symcolor=symcolor, symsize=symsize

	cut	= WHERE(data.xox.fof3d.time / data.xxx.fof3d.time GT yr(1))
	cgOplot, data.xxx.fof3d.ngroup, data.xox.fof3d.time / data.xxx.fof3d.time, psym=16, symsize=symsize, color=symcolor(0)
	IF MAX(cut) GE 0L THEN $
		cgOplot, data.xxx.fof3d.ngroup(cut), FLTARR(N_ELEMENTS(cut))*0.0 + yr(1), $
		psym=49, color=symcolor(0), symsize=1.5

	cut	= WHERE(data.xox.fof6d.time / data.xxx.fof6d.time GT yr(1))
	cgOplot, data.xxx.fof6d.ngroup, data.xox.fof6d.time / data.xxx.fof6d.time, psym=16, symsize=symsize, color=symcolor(1)
	IF MAX(cut) GE 0L THEN $
		cgOplot, data.xxx.fof6d.ngroup(cut), FLTARR(N_ELEMENTS(cut))*0.0 + yr(1), $
		psym=49, color=symcolor(1), symsize=1.5

	cgOplot, xr, [1., 1.], linestyle=1, thick=3, color='dark grey'
	cgAxis, xaxis=0, xstyle=1, xrange=xr, xtickv=[1e5, 1e6, 1e7, 1e8], xtickn=[' ', ' ' , ' ', ' '], /xlog, xticklen=0.06, /save
	cgAxis, yaxis=0, ystyle=1, yrange=yr, ytickv=[0., 0.5, 1.0], ytickn=['0.00', '0.50', '1.00'], yticks=2, $
		yminor=5, ytitle='Frac', /save
	cgAxis, xaxis=1, xstyle=1, xrange=xr*8512.4066, xticklen=0.06, /xlog, /save
	cgAxis, yaxis=1, ystyle=1, yrange=yr, ytickv=[0., 0.5, 1.0], ytickn=[' ', ' ', ' '], yticks=2, $
		yminor=5, /save

	cgText, (pos(2) + pos(0))/2, pos(3)*1.08, textoidl('Mass [M' + sunsymbol() + ']'), alignment=0.5, /normal
END
