PRO vr_test6_ms, settings, GAL, eps=eps

IF eps EQ 1L THEN $
        cgPS_open, settings.root_path + 'test/vr_test/test6*/ms.eps', /encapsulated
dsize   = [800., 800.]
cgDisplay, dsize(0), dsize(1)
!p.font = -1 & !p.charsize=1.5 & !p.color=255B

xr      = [6., 12.]
yr      = [-3., 3.]
pos     = [0.1, 0.1, 0.9, 0.9]
cgPlot, 0., 0., /nodata, xrange=xr, yrange=yr, position=pos, xstyle=4, ystyle=4

;;;;;
cut     = WHERE(GAL.structuretype GE 0L AND GAL.SFR GT 0.)
mgal    = GAL.Mass_tot(cut)
SFR	= GAL.SFR(cut)


;cgOplot, ALOG10(mgal), ALOG10(SFR), psym=16, symsize=0.5
js_denmap, ALOG10(mgal), ALOG10(SFR), DBLARR(N_ELEMENTS(mgal)) + 10.0d, $
	xrange=xr, yrange=yr, n_pix=500L, num_thread=settings.num_thread, $
	kernel=1L, mode=1L, ctable=33B, position=pos, dsize=800., $
	 /logscale, dr=[0.0, 2.5], symsize=0.5

XX	= FINDGEN(100)/99.*6.0 + 6.0
YY	= ALOG10((10.0^XX) / (0.1 * 1.0d9))
cgOplot, XX, YY, linestyle=2, thick=2, color='black'

cgAxis, xaxis=0, xstyle=1, xrange=xr, $
        xticks=7L, xtickv=['6', '7', '8', '9', '10', '11', '12'], $
        xtitle='log (Mass / Msun)', /save
cgAxis, xaxis=1, xstyle=1, xrange=xr, xticks=7L, $
        xtickv=['6', '7', '8', '9', '10', '11', '12'], xtickn=REPLICATE(' ', 7L), /save
cgAxis, yaxis=0, ystyle=1, xrange=yr, $
        yticks=6L, ytickv=['-3', '-2', '-1', '0', '1', '2', '3'], $
        ytitle='log (SFR / Msun / yr)', /save
cgAxis, yaxis=1, ystyle=1, yrange=yr, yticks=6L, $
        ytickv=['-3', '-2', '-1', '0', '1', '2', '3'], ytickn=REPLICATE(' ', 7L), /save
IF KEYWORD_SET(eps) THEN $
                        cgPS_close


IF eps EQ 1L THEN $
        cgPS_open, settings.root_path + 'test/vr_test/test6*/ms_gal.eps', /encapsulated
dsize   = [800., 800.]
cgDisplay, dsize(0), dsize(1)
!p.font = -1 & !p.charsize=1.5 & !p.color=255B

xr      = [6., 12.]
yr      = [-3., 3.]
pos     = [0.1, 0.1, 0.9, 0.9]
cgPlot, 0., 0., /nodata, xrange=xr, yrange=yr, position=pos, xstyle=4, ystyle=4

;;;;;
cut     = WHERE(GAL.structuretype GE 10L AND GAL.SFR GT 0.)
mgal    = GAL.Mass_tot(cut)
SFR	= GAL.SFR(cut)


;cgOplot, ALOG10(mgal), ALOG10(SFR), psym=16, symsize=0.5
js_denmap, ALOG10(mgal), ALOG10(SFR), DBLARR(N_ELEMENTS(mgal)) + 10.0d, $
	xrange=xr, yrange=yr, n_pix=500L, num_thread=settings.num_thread, $
	kernel=1L, mode=1L, ctable=33B, position=pos, dsize=800., $
	 /logscale, dr=[0.0, 2.5], symsize=0.5

XX	= FINDGEN(100)/99.*6.0 + 6.0
YY	= ALOG10((10.0^XX) / (0.1 * 1.0d9))
cgOplot, XX, YY, linestyle=2, thick=2, color='black'

cgAxis, xaxis=0, xstyle=1, xrange=xr, $
        xticks=7L, xtickv=['6', '7', '8', '9', '10', '11', '12'], $
        xtitle='log (Mass / Msun)', /save
cgAxis, xaxis=1, xstyle=1, xrange=xr, xticks=7L, $
        xtickv=['6', '7', '8', '9', '10', '11', '12'], xtickn=REPLICATE(' ', 7L), /save
cgAxis, yaxis=0, ystyle=1, xrange=yr, $
        yticks=6L, ytickv=['-3', '-2', '-1', '0', '1', '2', '3'], $
        ytitle='log (SFR / Msun / yr)', /save
cgAxis, yaxis=1, ystyle=1, yrange=yr, yticks=6L, $
        ytickv=['-3', '-2', '-1', '0', '1', '2', '3'], ytickn=REPLICATE(' ', 7L), /save
IF KEYWORD_SET(eps) THEN $
                        cgPS_close

END
