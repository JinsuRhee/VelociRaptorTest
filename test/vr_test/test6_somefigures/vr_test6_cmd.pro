PRO vr_test6_cmd, settings, GAL, eps=eps

IF eps EQ 1L THEN $
        cgPS_open, settings.root_path + 'test/vr_test/test6*/cmd_140.eps', /encapsulated
dsize   = [800., 800.]
cgDisplay, dsize(0), dsize(1)
!p.font = -1 & !p.charsize=1.5 & !p.color=255B

xr      = [6.5, 12.]
yr      = [-1., 1.]
pos     = [0.15, 0.15, 0.9, 0.9]
cgPlot, 0., 0., /nodata, xrange=xr, yrange=yr, position=pos, xstyle=4, ystyle=4

;;;;;
cut     = WHERE(GAL.structuretype GE 10L and GAL.ABMag(*,1,0) GT -1.0d7)
mgal    = GAL.Mass_tot(cut)
gr	= GAL.ABMag(cut,1,0) - GAL.ABMag(cut,2,0)

;cgOplot, ALOG10(mgal), ur, psym=16, symsize=0.5
js_denmap, ALOG10(mgal), gr, DBLARR(N_ELEMENTS(mgal)) + 10.0d, $
	xrange=xr, yrange=yr, n_pix=500L, num_thread=settings.num_thread, $
	kernel=1L, mode=1L, ctable=33B, position=pos, dsize=800., $
	 /logscale, dr=[0.0, 2.0], symsize=0.5

cgAxis, xaxis=0, xstyle=1, xrange=xr, $
        xticks=6L, xtickv=['7', '8', '9', '10', '11', '12'], $
        xtitle='log (Mass / Msun)', /save
cgAxis, xaxis=1, xstyle=1, xrange=xr, xticks=6L, $
        xtickv=['7', '8', '9', '10', '11', '12'], xtickn=REPLICATE(' ', 6L), /save
cgAxis, yaxis=0, ystyle=1, xrange=yr, $
        yticks=4L, ytickv=['-1', '-0.5', '0', '0.5', '1'], $
        ytitle='g - r', /save
cgAxis, yaxis=1, ystyle=1, yrange=yr, yticks=4L, $
        ytickv=['-1', '-0.5', '0', '0.5', '1'], ytickn=REPLICATE(' ', 5L), /save
IF KEYWORD_SET(eps) THEN $
                        cgPS_close








IF eps EQ 1L THEN $
        cgPS_open, settings.root_path + 'test/vr_test/test6*/cmd_140_zoom.eps', /encapsulated
dsize   = [800., 800.]
cgDisplay, dsize(0), dsize(1)
!p.font = -1 & !p.charsize=1.5 & !p.color=255B

xr      = [9., 12.]
yr      = [-0.5, 0.5]
pos     = [0.15, 0.15, 0.9, 0.9]
cgPlot, 0., 0., /nodata, xrange=xr, yrange=yr, position=pos, xstyle=4, ystyle=4

;;;;;
cut     = WHERE(GAL.structuretype GE 10L and GAL.ABMag(*,1,0) GT -1.0d7)
mgal    = GAL.Mass_tot(cut)
gr	= GAL.ABMag(cut,1,0) - GAL.ABMag(cut,2,0)

;cgOplot, ALOG10(mgal), ur, psym=16, symsize=0.5
js_denmap, ALOG10(mgal), gr, DBLARR(N_ELEMENTS(mgal)) + 10.0d, $
	xrange=xr, yrange=yr, n_pix=100L, num_thread=settings.num_thread, $
	kernel=1L, mode=1L, ctable=33B, position=pos, dsize=800., $
	 /logscale, dr=[0.0, 1.35], symsize=0.5, bandwidth=[0.20, 0.05]

cgAxis, xaxis=0, xstyle=1, xrange=xr, $
        xticks=4L, xtickv=['9', '10', '11', '12'], $
        xtitle='log (Mass / Msun)', /save
cgAxis, xaxis=1, xstyle=1, xrange=xr, xticks=4L, $
        xtickv=['9', '10', '11', '12'], xtickn=REPLICATE(' ', 4L), /save
cgAxis, yaxis=0, ystyle=1, xrange=yr, $
        yticks=2L, ytickv=['-0.5', '0', '0.5'], $
        ytitle='g - r', /save
cgAxis, yaxis=1, ystyle=1, yrange=yr, yticks=2L, $
        ytickv=['-0.5', '0', '0.5'], ytickn=REPLICATE(' ', 3L), /save
IF KEYWORD_SET(eps) THEN $
                        cgPS_close

STOP

END
