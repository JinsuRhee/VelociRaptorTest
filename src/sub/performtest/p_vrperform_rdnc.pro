PRO P_VRPerform_rdnc, settings, nsnap, data, skip=skip

data	= {name:'name'}

IF ~KEYWORD_SET(SKIP) THEN BEGIN
	dumname	= ['o', 'x']
	FOR i0=1L, 1L DO BEGIN
	FOR i1=0L, 0L DO BEGIN
	FOR i2=1L, 1L DO BEGIN
		tmp_name	= $
			STRTRIM(dumname(i0),2) + $
			STRTRIM(dumname(i1),2) + $
			STRTRIM(dumname(i2),2)
		fname	= settings.P_VRPerform_dir + 'snap_' + $
			tmp_name + '_test_' + $
			STRING(nsnap, format='(I3.3)') + $
			'/logfile.log'

		IF STRLEN(FILE_SEARCH(fname)) LE 10L THEN BEGIN
			PRINT, tmp_name
			CONTINUE
		ENDIF

		fof3d_npart = [0L] & fof3d_ngroup = [0L] & fof3d_svisit = [0.0d] & fof3d_lvisit = [0.0d] & fof3d_time = [0.0d] & fof3d_level = [0L] & fof3d_ltime = [0.0d] & fof3d_stime = [0.0d] & fof3d_nloop = [0.0d] & fof3d_numsnode = [0L] & fof3d_numlnode = [0L] & fof3d_sc = [0L] & fof3d_lc = [0L]
		n0 = 0L & n1 = 0L & n2 = 0L & n3 = 0L & n4 = 0L & n5 = 0L & n6 = 0L & n7 = 0L & n8 = 0L & n9 = 0L & n10 = 0L
		fof6d_npart = [0L] & fof6d_ngroup = [0L] & fof6d_svisit = [0.0d] & fof6d_lvisit = [0.0d] & fof6d_time = [0.0d] & fof6d_level = [0L] & fof6d_ltime = [0.0d] & fof6d_stime = [0.0d] & fof6d_nloop = [0.0d] & fof6d_numsnode = [0L] & fof6d_numlnode = [0L] & fof6d_sc = [0L] & fof6d_lc = [0L]
		m0 = 0L & m1 = 0L & m2 = 0L & m3 = 0L & m4 = 0L & m5 = 0L & m6 = 0L & m7 = 0L & m8 = 0L & m9 = 0L & m10 = 0L

		OPENR, 10, fname
		FOR i=0L, FILE_LINES(fname)-1L DO BEGIN
			dum	= ' '
			READF, 10, dum
			IF STRPOS(dum, '%123123') GE 0L THEN BEGIN
				dum	= STRMID(dum, 8L, STRLEN(dum))
				dum	= STRSPLIT(dum, '/', /extract)
					n_part	= LONG(dum(0))
					n_dim	= LONG(dum(1))
					n_group	= LONG(dum(2))
					n_Svisit= DOUBLE(dum(3))
					n_Lvisit= DOUBLE(dum(4))

					;; Lvisiting times
						dum2	= dum(6)
						dum2	=  STRSPLIT(dum2, ':', /extract)

					n_ltime	= DOUBLE(dum2(1))

					;n_time	= DOUBLE(dum(1))
					n_level	= LONG(alog10(n_part*1.0d / 32.0) / alog10(2.0) + 1.0d)
					n_snode	= LONG(dum(8))
					n_lnode = LONG(dum(9))
					;n_loop	= DOUBLE(dum(10))

						dum2	= dum(11)
						dum2	= STRMID(dum2, 8L, STRLEN(dum2))
						n_sc	= LONG(dum2)

						n_lc	= LONG(dum(12))

				; FOF 3D
				IF n_dim EQ 3L THEN BEGIN
					js_makearr, fof3d_npart, n_part, n0, unitsize=10000L, type='L'
					js_makearr, fof3d_ngroup, n_group, n1, unitsize=10000L, type='L'
					js_makearr, fof3d_svisit, n_Svisit, n2, unitsize=10000L, type='D'
					js_makearr, fof3d_lvisit, n_Lvisit, n3, unitsize=10000L, type='D'
					js_makearr, fof3d_ltime, n_ltime, n4, unitsize=10000L, type='D'
					js_makearr, fof3d_level, n_level, n5, unitsize=10000L, type='L'
					js_makearr, fof3d_numsnode, n_snode, n6, unitsize=10000L, type='L'
					js_makearr, fof3d_numlnode, n_lnode, n7, unitsize=10000L, type='L'
					;js_makearr, fof3d_nloop, n_loop, n8, unitsize=10000L, type='D'
					js_makearr, fof3d_sc, n_sc, n9, unitsize=10000L, type='L'
					js_makearr, fof3d_lc, n_lc, n10, unitsize=10000L, type='L'
				ENDIF

				; FOF 6D
				IF n_dim EQ 6L THEN BEGIN
					js_makearr, fof6d_npart, n_part, m0, unitsize=10000L, type='L'
					js_makearr, fof6d_ngroup, n_group, m1, unitsize=10000L, type='L'
					js_makearr, fof6d_svisit, n_Svisit, m2, unitsize=10000L, type='D'
					js_makearr, fof6d_lvisit, n_Lvisit, m3, unitsize=10000L, type='D'
					js_makearr, fof6d_ltime, n_ltime, m4, unitsize=10000L, type='D'
					js_makearr, fof6d_level, n_level, m5, unitsize=10000L, type='L'
					js_makearr, fof6d_numsnode, n_snode, m6, unitsize=10000L, type='L'
					js_makearr, fof6d_numlnode, n_lnode, m7, unitsize=10000L, type='L'
					;js_makearr, fof6d_nloop, n_loop, m8, unitsize=10000L, type='D'
					js_makearr, fof6d_sc, n_sc, m9, unitsize=10000L, type='L'
					js_makearr, fof6d_lc, n_lc, m10, unitsize=10000L, type='L'
				ENDIF
			ENDIF
		ENDFOR
		CLOSE, 10
		fof3d_npart	= fof3d_npart(0L:n0-1L)
		fof3d_ngroup	= fof3d_ngroup(0L:n1-1L)
		fof3d_svisit	= fof3d_svisit(0L:n2-1L)
		fof3d_lvisit	= fof3d_lvisit(0L:n3-1L)
		fof3d_ltime	= fof3d_ltime(0L:n4-1L)
			fof3d_time	= fof3d_ltime
			fof3d_stime	= fof3d_ltime
		fof3d_level	= fof3d_level(0L:n5-1L)
		fof3d_numsnode	= fof3d_numsnode(0L:n6-1L)
		fof3d_numlnode	= fof3d_numlnode(0L:n7-1L)
		;fof3d_nloop	= fof3d_nloop(0L:n8-1L)
		fof3d_sc	= fof3d_sc(0L:n9-1L)
		fof3d_lc	= fof3d_lc(0L:n10-1L)

		fof6d_npart	= fof6d_npart(0L:m0-1L)
		fof6d_ngroup	= fof6d_ngroup(0L:m1-1L)
		fof6d_svisit	= fof6d_svisit(0L:m2-1L)
		fof6d_lvisit	= fof6d_lvisit(0L:m3-1L)
		fof6d_ltime	= fof6d_ltime(0L:m4-1L)
			fof6d_time	= fof6d_ltime
			fof6d_stime	= fof6d_ltime
		fof6d_level	= fof6d_level(0L:m5-1L)
		fof6d_numsnode	= fof6d_numsnode(0L:m6-1L)
		fof6d_numlnode	= fof6d_numlnode(0L:m7-1L)
		;fof6d_nloop	= fof6d_nloop(0L:m8-1L)
		fof6d_sc	= fof6d_sc(0L:m9-1L)
		fof6d_lc	= fof6d_lc(0L:m10-1L)

		fof3d	= {npart:fof3d_npart, $
			ngroup:fof3d_ngroup, $
			svisit:fof3d_svisit, $
			lvisit:fof3d_lvisit, $
			time:fof3d_time, $
			stime:fof3d_stime, ltime:fof3d_ltime, $
			level:fof3d_level(0L:n5-1L), $
			;nloop:0.0d, $
			numsnode:fof3d_numsnode, numlnode:fof3d_numlnode, $
			sclosed:fof3d_sc, lclosed:fof3d_lc}

		fof6d	= {npart:fof6d_npart, $
			ngroup:fof6d_ngroup, $
			svisit:fof6d_svisit, $
			lvisit:fof6d_lvisit, $
			time:fof6d_time, $
			stime:fof6d_stime, ltime:fof6d_ltime, $
			;nloop:0.0d, $
			level:fof6d_level, $
			numsnode:fof6d_numsnode, numlnode:fof6d_numlnode, $
			sclosed:fof6d_sc, lclosed:fof6d_lc}

		sort_cut= SORT(fof3d.ngroup)
		FOR j=0L, N_TAGS(fof3d)-1L DO fof3d.(j) = fof3d.(j)(sort_cut)

		sort_cut= SORT(fof6d.ngroup)
		FOR j=0L, N_TAGS(fof6d)-1L DO fof6d.(j) = fof6d.(j)(sort_cut)

		dum	= {fof3d:fof3d, fof6d:fof6d}
		data	= CREATE_STRUCT(data,tmp_name,dum)

	ENDFOR
	ENDFOR
	ENDFOR

ENDIF ELSE BEGIN

ENDELSE


END
