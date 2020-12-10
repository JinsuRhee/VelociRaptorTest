PRO P_VRPerform_rd, settings, nsnap, data, skip=skip

data	= {name:'name'}

IF ~KEYWORD_SET(SKIP) THEN BEGIN
	dumname	= ['o', 'x']
	FOR i0=1L, 1L DO BEGIN
	FOR i1=1L, 1L DO BEGIN
	FOR i2=1L, 1L DO BEGIN
		tmp_name	= $
			STRTRIM(dumname(i0),2) + $
			STRTRIM(dumname(i1),2) + $
			STRTRIM(dumname(i2),2)
		fname	= settings.P_VRPerform_dir + 'snap_' + $
			tmp_name + '_' + $
			STRING(nsnap, format='(I3.3)') + $
			'/logfile.log'

		fname2	= settings.P_VRPerform_dir + 'snap_' + $
			tmp_name + '_nt_' + $
			STRING(nsnap, format='(I3.3)') + $
			'/logfile.log'

		IF STRLEN(FILE_SEARCH(fname)) LE 10L THEN BEGIN
			PRINT, tmp_name
			CONTINUE
		ENDIF

		fofarr	= DBLARR(2,16,10000)
		fofind	= [0L, 0L]

		OPENR, 10, fname
		FOR i=0L, FILE_LINES(fname)-1L DO BEGIN
			dum	= ' '
			READF, 10, dum
			IF STRPOS(dum, '%123123') GE 0L THEN BEGIN
				dum	= STRSPLIT(dum, '/', /extract)
				dum	= dum(1L:*)

				n_dim	= STRSPLIT(dum(1), ':', /extract)
				n_dim	= LONG(n_dim(1))
				IF n_dim EQ 3L THEN n_dim = 0L
				IF n_dim EQ 6L THEN n_dim = 1L

				FOR j=0L, N_ELEMENTS(dum)-1L DO BEGIN
					dumtmp	= STRSPLIT(dum(j), ':', /extract)
					fofarr(n_dim,j,fofind(n_dim)) = DOUBLE(dumtmp(1))
				ENDFOR
				fofind(n_dim) ++
			ENDIF
		ENDFOR
		CLOSE, 10
		fofind(0) --
		fofind(1) --

		OPENR, 11, fname2
		FOR i=0L, FILE_LINES(fname2)-1L DO BEGIN
			dum	= ' '
			READF, 11, dum
			IF STRPOS(dum, '%123123') GE 0L THEN BEGIN
				dum	= STRSPLIT(dum, '/', /extract)
				dum	= dum(1L:*)

				n_dim	= STRSPLIT(dum(1), ':', /extract)
				n_dim	= LONG(n_dim(1))
				IF n_dim EQ 3L THEN n_dim = 0L
				IF n_dim EQ 6L THEN n_dim = 1L

				n_ptcl	= STRSPLIT(dum(2), ':', /extract)
				n_ptcl	= LONG(n_ptcl(1))

				FOR j=0L, N_ELEMENTS(dum)-1L DO BEGIN
					IF STRPOS(dum(j), 'Total Time') GE 0L THEN BEGIN
						tot_time	= STRSPLIT(dum(j), ':', /extract)
						tot_time	= DOUBLE(tot_time(1))
						cut	= WHERE(fofarr(n_dim,2L,*) EQ n_ptcl)
						fofarr(n_dim,j,cut) = tot_time
						BREAK
					ENDIF
				ENDFOR
			ENDIF ELSE IF STRPOS(dum, "Done saving hierarchy") GE 0L THEN BEGIN
				READF, 11, dum
				dum	= STRSPLIT(dum, 'took', /extract)
				dum	= dum(1)
				dum	= STRSPLIT(dum, 'in', /extract)
				dum	= dum(0)
				run_time	= DOUBLE(dum)
				BREAK
			ENDIF
		ENDFOR
		CLOSE, 11

		fof3dt	= fofarr(0L,0L:*,0L:fofind(0))
		fof6dt	= fofarr(1L,0L:*,0L:fofind(1))

		fof3d	= {	numindom:	REFORM(	LONG	(	fof3dt(0L,0L,*)	), fofind(0) + 1L ), $
				ngroup:		REFORM(	LONG	(	fof3dt(0L,2L,*)	), fofind(0) + 1L ), $
				numsnode:	REFORM(	LONG	(	fof3dt(0L,3L,*)	), fofind(0) + 1L ), $
				numlnode:	REFORM(	LONG	(	fof3dt(0L,4L,*)	), fofind(0) + 1L ), $
				svisit:		REFORM(	DOUBLE	(	fof3dt(0L,5L,*)	), fofind(0) + 1L ), $
				lvisit:		REFORM(	DOUBLE	(	fof3dt(0L,6L,*)	), fofind(0) + 1L ), $
				sskip:		REFORM(	DOUBLE	(	fof3dt(0L,7L,*)	), fofind(0) + 1L ), $
				lskip:		REFORM(	DOUBLE	(	fof3dt(0L,8L,*)	), fofind(0) + 1L ), $
				senclosed:	REFORM(	DOUBLE	(	fof3dt(0L,9L,*)	), fofind(0) + 1L ), $
				lenclosed:	REFORM(	DOUBLE	(	fof3dt(0L,10L,*)), fofind(0) + 1L ), $
				sclosed:	REFORM(	DOUBLE	(	fof3dt(0L,11L,*)), fofind(0) + 1L ), $
				lclosed:	REFORM(	DOUBLE	(	fof3dt(0L,12L,*)), fofind(0) + 1L ), $
				stime:		REFORM(	DOUBLE	(	fof3dt(0L,13L,*)), fofind(0) + 1L ), $
				ltime:		REFORM(	DOUBLE	(	fof3dt(0L,14L,*)), fofind(0) + 1L ), $
				time:		REFORM(	DOUBLE	(	fof3dt(0L,15L,*)), fofind(0) + 1L ) }

		fof6d	= {	numindom:	REFORM( LONG	(	fof6dt(0L,0L,*)	), fofind(1) + 1L ), $
				ngroup:		REFORM( LONG	(	fof6dt(0L,2L,*)	), fofind(1) + 1L ), $
				numsnode:	REFORM( LONG	(	fof6dt(0L,3L,*)	), fofind(1) + 1L ), $
				numlnode:	REFORM( LONG	(	fof6dt(0L,4L,*)	), fofind(1) + 1L ), $
				svisit:		REFORM( DOUBLE	(	fof6dt(0L,5L,*)	), fofind(1) + 1L ), $
				lvisit:		REFORM( DOUBLE	(	fof6dt(0L,6L,*)	), fofind(1) + 1L ), $
				sskip:		REFORM( DOUBLE	(	fof6dt(0L,7L,*)	), fofind(1) + 1L ), $
				lskip:		REFORM( DOUBLE	(	fof6dt(0L,8L,*)	), fofind(1) + 1L ), $
				senclosed:	REFORM( DOUBLE	(	fof6dt(0L,9L,*)	), fofind(1) + 1L ), $
				lenclosed:	REFORM( DOUBLE	(	fof6dt(0L,10L,*)), fofind(1) + 1L ), $
				sclosed:	REFORM( DOUBLE	(	fof6dt(0L,11L,*)), fofind(1) + 1L ), $
				lclosed:	REFORM( DOUBLE	(	fof6dt(0L,12L,*)), fofind(1) + 1L ), $
				stime:		REFORM( DOUBLE	(	fof6dt(0L,13L,*)), fofind(1) + 1L ), $
				ltime:		REFORM( DOUBLE	(	fof6dt(0L,14L,*)), fofind(1) + 1L ), $
				time:		REFORM( DOUBLE	(	fof6dt(0L,15L,*)), fofind(1) + 1L ) }

		fof3d.stime	= fof3d.time - fof3d.ltime
		fof6d.stime	= fof6d.time - fof6d.ltime

		sort_cut= SORT(fof3d.ngroup)
		FOR j=0L, N_TAGS(fof3d)-1L DO fof3d.(j) = fof3d.(j)(sort_cut)

		sort_cut= SORT(fof6d.ngroup)
		FOR j=0L, N_TAGS(fof6d)-1L DO fof6d.(j) = fof6d.(j)(sort_cut)

		FOR j=0L, N_TAGS(fof3d)-1L DO fof3d.(j) = REFORM(fof3d.(j),N_ELEMENTS(fof3d.(j)))
		FOR j=0L, N_TAGS(fof6d)-1L DO fof6d.(j) = REFORM(fof6d.(j),N_ELEMENTS(fof6d.(j)))

		dum	= {fof3d:fof3d, fof6d:fof6d, total_time:run_time}
		data	= CREATE_STRUCT(data,tmp_name,dum)

		STOP
		;a	= linfit(alog10(fof3d.ngroup), alog10(fof3d.time))
		;b	= linfit(alog10(fof6d.ngroup), alog10(fof6d.time))
		;IF tmp_name eq 'xxxxx' THEN STOP
		;PRINT, a(1), b(1), tmp_name
	ENDFOR
	ENDFOR
	ENDFOR

ENDIF ELSE BEGIN

	RESTORE, '/storage6/jinsu/var/Paper5*/data.sav'
ENDELSE


END
