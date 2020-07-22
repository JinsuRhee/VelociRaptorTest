Pro draw


	;for i=0L, 3L do begin

	;	n_snap = 60L + 10*i
	;	restore, 'dum_' + string(n_snap,format='(I3.3)') + '.sav'

	;	vr_m	= vr.mvir
	;	gm_m	= gm.mvir

	;	vr_m	= vr_m(where(vr_m gt 1e4))
	;	gm_m	= gm_m(where(gm_m gt 1e4))

	;	y1	= histogram(alog10(vr_m),min=4, max=10, binsize=0.2, location=x1)
	;	y2	= histogram(alog10(gm_m),min=4, max=10, binsize=0.2, location=x2)

	;	cgPS_open, strtrim(n_snap,2) + '.eps', /encapsulated
	;	!p.font = -1 & !p.charsize=1.5
	;	cgPlot, x1, y1, linestyle=0, thick=3, /ylog, yrange=[1, 10000], xtitle='log (M_sun)', ytitle='N'
	;	cgOplot, x2, y2, linestyle=2, thick=3, color='red'


	;	cgPS_close

	;endfor


	n_snap = 090L
	restore, 'dum_' + string(n_snap,format='(I3.3)') + '.sav'

	vr_x    = vr.xc(where(vr.mvir gt 1e8))
	vr_y	= vr.yc(where(vr.mvir gt 1e8))

	vr_x	= vr_x * 3.086e21 / 3.08d21
	vr_y	= vr_y * 3.086e21 / 3.08d21

	gm_x    = gm.xx(where(gm.mvir gt 1e8))
	gm_y    = gm.yy(where(gm.mvir gt 1e8))

	cgPS_open, 'dist2.eps', /encapsulated
	cgDIsplay, 800, 800
	!p.font = -1 & !p.charsize=1.5
	cgPlot, vr_x, vr_y, psym=16, xrange=[1.3e4, 1.5e4], yrange=[1.3e4, 1.5e4], xtitle='X', ytitle='Y'
	cgOplot, gm_x, gm_y, psym=16, symsize=0.5, color='red'
	cgPS_close
	stop
End
