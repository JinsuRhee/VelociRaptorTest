PRO p_vrperform_draw3_pan3sub, data, pos=pos, xr=xr, yr=yr, symcolor=symcolor, symsize=symsize

	cgOplot, data.xxx.fof3d.ngroup, data.xox.fof3d.ltime / data.xxx.fof3d.ltime, psym=16, symsize=symsize, color=symcolor(0)
	cgOplot, data.xxx.fof6d.ngroup, data.xox.fof6d.ltime / data.xxx.fof6d.ltime, psym=16, symsize=symsize, color=symcolor(1)

	cgOplot, xr, [1., 1.], linestyle=1, thick=3, color='dark grey'
	cgAxis, xaxis=0, xstyle=1, xrange=xr, xtickv=[1e5, 1e6, 1e7, 1e8], xtickn=[' ', ' ' , ' ', ' '], /xlog, xticklen=0.06, /save
	cgAxis, xaxis=1, xstyle=1, xrange=xr*8512.4066, xticklen=0.06, /xlog, /save

	cgAxis, yaxis=0, ystyle=1, yrange=yr, ytickv=[0., 0.5, 1.0], ytickn=[' ', ' ', ' '], yticks=2, yminor=5
	cgAxis, yaxis=1, ystyle=1, yrange=yr, ytickv=[0., 0.5, 1.0], ytickn=[' ', ' ', ' '], yticks=2, yminor=5
	cgText, (pos(2) + pos(0))/2, pos(3)*1.08, textoidl('Mass [M' + sunsymbol() + ']'), alignment=0.5, /normal
END
