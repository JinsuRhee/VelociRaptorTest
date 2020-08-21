PRO test3_gprop, settings, gal, p_ms=p_ms, p_cmd=p_cmd

	;;-----
	;; Main Sequence
	;;-----

IF KEYWORD_SET(p_ms) THEN BEGIN
	cut	= where(gal.SFR(*,0) gt 0.)
	cgDisplay, 800, 800
	!p.font = -1 & !p.charsize = 1.5 & !p.color = 255B
	cgPlot, 0, 0, /nodata, xrange=[8., 11.], yrange=[-1., 2.]
	cgOplot, alog10(gal.mass_tot(cut)), alog10(gal.SFR(cut,0)), psym=16
ENDIF

IF KEYWORD_SET(p_cmd) THEN BEGIN
	cut = where(gal.abmag(*,0,0) gt -1d7)
	u = gal.abmag(cut,0,0) & g = gal.abmag(cut,1,0) & r = gal.abmag(cut,2,0)
	mass = gal.mass_tot(cut)
	cgDisplay, 800, 800
	!p.font = -1 & !p.charsize = 1.5 & !p.color = 255B
	cgPlot, 0, 0, /nodata, xrange=[9., 11.], yrange=[-1., 1.]
	cgOplot, alog10(mass), g - r, psym=16, symsize=0.5
ENDIF

END
