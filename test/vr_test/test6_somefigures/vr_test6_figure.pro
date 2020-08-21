PRO vr_test6_figure, settings, n_snap, skip=skip, eps=eps, $
	f_sizemass=f_sizemass, f_ms=f_ms, f_cmd=f_cmd

IF ~KEYWORD_SET(skip) THEN BEGIN

	GAL	= f_rdgal(settings, n_snap, [settings.column_list, 'ABmag', 'SFR'])

	IF KEYWORD_SET(f_sizemass) THEN vr_test6_sizemass, settings, GAL, eps=KEYWORD_SET(eps)

	IF KEYWORD_SET(f_ms) THEN vr_test6_ms, settings, GAL, eps=KEYWORD_SET(eps)

	IF KEYWORD_SET(f_cmd) THEN vr_test6_cmd, settings, GAL, eps=KEYWORD_SET(eps)

	;u = GAL.ABmag(*,0,0) & g = GAL.ABmag(*,1,0) & r = GAL.ABmag(*,2,0)

	;cgOplot, ALOG10(mgal), g - r, psym=16, symsize=0.7
	STOP

ENDIF

END
