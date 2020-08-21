PRO vr_test8_rd_l10006, settings, rp_l10006, skip=skip

IF ~KEYWORD_SET(skip) THEN BEGIN
	path	= '/storage5/FORNAX/VELOCI_RAPTOR/l10006/galaxy/run_linkingcheck/'
	files	= file_search(path + 'snap_*')

	n1 = 0L & n2 = 0L
	pp	= [0.0]
	tt	= [0.0]
	FOR i=0L, N_ELEMENTS(files) - 1L DO BEGIN
		dum	= file_search(files(i) + '/logfile.log')
		IF STRLEN(dum) LT 5L THEN CONTINUE
		spawn, 'grep "finished running VR" ' + STRTRIM(files(i),2) + '/logfile.log', dum

		dum = [dum]
		IF STRLEN(dum(0)) LE 5L THEN CONTINUE

		dum	= ' '
		OPENR, 10, files(i) + '/logfile.log'
		nt	= 0L
		REPEAT BEGIN
			READF, 10, dum
			dum2	= STRPOS(dum, 'Read header')
			IF dum2 GE 0L THEN BEGIN
				nt	= 1L
				READF, 10, dum
			ENDIF
		ENDREP UNTIL nt GE 1L

		i1	= STRPOS(dum, 'are') + 3L
		i2	= STRPOS(dum, 'particles') - 1L
		dum	= STRMID(dum, i1, i2 - i1)
		CLOSE, 10
		dumP	= FLOAT(dum)

		dum	= ' '
		OPENR, 10, files(i) + '/logfile.log'
		READF, 10, dum
		dum_old	= dum
		nt	= 0L
		REPEAT BEGIN
			READF, 10, dum
			aa	= STRPOS(dum,'finished running VR')
			IF aa GE 0L THEN BEGIN
				b2	= STRPOS(dum_old, 'in all') - 1L
				b1	= STRPOS(dum_old, 'took') + 4L
				bb	= STRMID(dum_old, b1, b2 - b1)
				nt	= 1L
			ENDIF ELSE BEGIN
				dum_old	= dum
			ENDELSE
		ENDREP UNTIL nt GE 1L
		CLOSE, 10
		dumT	= FLOAT(bb)

		js_makearr, pp, [dumP], n1, unitsize=10L, type='F'
		js_makearr, tt, [dumT], n2, unitsize=10L, type='F'
	ENDFOR
	pp	= pp(0L:n1-1L)
	tt	= tt(0L:n2-1L)
	rp_l10006	= [[tt], [pp]]

	SAVE, filename=settings.root_path + 'test/vr_test/test8*/l10006.sav', rp_l10006
ENDIF ELSE BEGIN
	RESTORE, settings.root_path + 'test/vr_test/test8*/l10006.sav'
ENDELSE


END
