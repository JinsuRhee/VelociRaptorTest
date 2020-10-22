PRO vr_test10_match, settings, old, new, skip=skip

IF ~KEYWORD_SET(skip) THEN BEGIN

	;;-----
	;; Match by id_mbp
	;;-----

	mbp_old	= old.id_mbp
	mbp_new	= new.id_mbp

	match = js_binmatch(mbp_old, mbp_new)

	;;-----
	;; Match by id_minpt
	;;-----

	mpt_old	= old.id_minpot
	mpt_new	= new.id_minpot

	match2	= js_binmatch(mpt_old, mpt_new)
	FOR i=0L, N_ELEMENTS(old.id)-1L DO BEGIN
		IF match2(i) GE 0L THEN BEGIN
			IF match(i) GE 0L AND match(i) ne match2(i) THEN STOP
			match(i) = match2(i)
		ENDIF
	ENDFOR

	STOP
ENDIF ELSE BEGIN

ENDELSE

END
