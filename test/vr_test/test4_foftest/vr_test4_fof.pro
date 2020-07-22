PRO vr_test4_fof, settings, xp, domain, target_dom

	;cut     = js_bound(xp,transpose(reform(domain(target_dom(0),*,*),3,2)))
	;xp	= xp(cut,*)

	numparts	= 6766635L
	numnodes	= 524287L

	;;-----

	fdist = sqrt(1.987284114d) & fdist2 = fdist*fdist
	iGroup = 0L & iHead = 0L & iTail = 0L

	pHead	= lindgen(numparts)
	pTail	= lindgen(numparts)
	pNext	= lonarr(numparts) - 1L
	pGroup	= lonarr(numparts)
	pLen	= lonarr(numparts)
	Fifo	= lonarr(numparts)
	off	= dblarr(6)
	pBucketFlag	= lonarr(numnodes)
	pGroupHead 	= lonarr(numparts)

	maxlen	= 0L

	;;-----
		;readcol, settings.root_path + 'test/vr_test/test4*/idlist.dat', pId, format='L', numline=6766635L
		;save, filename=settings.root_path + 'test/vr_test/test4*/idlist.sav', pId
		restore, settings.root_path + 'test/vr_test/test4*/idlist.sav'

		;openr, 10, settings.root_path + 'test/vr_test/test4*/tlist.dat'
		;nid		= lonarr(numparts)
		;bucket_start	= lonarr(numparts)
		;bucket_end	= lonarr(numparts)
		;FOR i=0L, numparts-1L DO BEGIN
		;       str	= ' '
		;       readf, 10, str
		;       str	= strsplit(str, '/', /extract)
		;       nid(i)	= long(str(0))
		;       bucket_start(i)	= long(str(2))
		;       bucket_end(i)	= long(str(3))
		;ENDFOR
		;save, filename=settings.root_path + 'test/vr_test/test4*/tlist.sav', nid, bucket_start, bucket_end
		;close, 10
		restore, settings.root_path + 'test/vr_test/test4*/tlist.sav'

		;openr, 11, settings.root_path + 'test/vr_test/test4*/dlist.dat'
		;Phase	= dblarr(numparts,3)
		;xbnd	= dblarr(numparts,3,2)
		;FOR i=0L, numparts-1L DO BEGIN
		;	str	= ' '
		;	readf, 11, str
		;	str	= strsplit(str, '/', /extract)
		;	xbnd[i,0,*] = [double(str(1)), double(str(2))]
		;	xbnd[i,1,*] = [double(str(3)), double(str(4))]
		;	xbnd[i,2,*] = [double(str(5)), double(str(6))]
		;	Phase[i,*] = [double(str(7)), double(str(8)), double(str(9))]
		;ENDFOR
		;save, filename=settings.root_path + 'test/vr_test/test4*/dlist.sav', xbnd, Phase
		;close, 11
		restore, settings.root_path + 'test/vr_test/test4*/dlist.sav'

		;openr, 12, settings.root_path + 'test/vr_test/test4*/pos.dat'
		;pos	= dblarr(numparts,3)
		;FOR i=0L, numparts-1L DO BEGIN
		;	str	= ' '
		;	readf, 12, str
		;	str	= strsplit(str, '/', /extract)
		;	pos[i,*] = [double(str(0)), double(str(1)), double(str(2))]
		;ENDFOR
		;save, filename=settings.root_path + 'test/vr_test/test4*/pos.sav', pos
		;close, 12
		restore, settings.root_path + 'test/vr_test/test4*/pos.sav'
	;;-----
	FOR i=0L, numparts-1L DO BEGIN
		id	= pID(i)

		IF(pGroup(id) ne 0) THEN CONTINUE;

		iGroup ++ & pGroup[id] = iGroup
		pLen[iGroup] = 1
		pGroupHead[iGroup] = i;
		Fifo[iTail] = i & iTail ++
		IF(iTail EQ numparts) THEN iTail=0

		REPEAT BEGIN
			iid = Fifo[iHead] & iHead ++
			IF(iHead EQ numparts) THEN iHead=0

			off(0:2)	= 0.d
			;;-----
			;;IF(pBucketFlag[nid(iid)]
			flag	= pHead[bucket_start(iTail)]
			maxr0 = 0.d & maxr1 = 0.d
			FOR j=0L, 2L DO maxr0 = maxr0 + $
				(Phase[iid,j] - xbnd[iTail,j,0]) * (Phase[iid,j] - xbnd[iTail,j,0])
			FOR j=0L, 2L DO maxr1 = maxr1 + $
				(Phase[iid,j] - xbnd[iTail,j,1]) * (Phase[iid,j] - xbnd[iTail,j,1])

			;if(iid EQ 21) THEN print, iid, bucket_start(iTail), bucket_start(iTail), iTail, xbnd[iTail,0,0], xbnd[iTail,0,1], maxr0, maxr1

			;if(iTail EQ 22) THEN print, iid, Phase(iid,*), xbnd(iid,0,*), xbnd(iid,1,*), xbnd(iid,2,*)

			;if(iTail EQ 26) THEN print, iid, Phase(iid,*), xbnd(iid,0,*), xbnd(iid,1,*), xbnd(iid,2,*)
			;print, iid, bucket_start(iTail), bucket_end(iTail), iTail, xbnd[iTail,0,0], xbnd[iTail, 0, 1]
			if(iTail GE 30) THEN STOP
			;;-----
			IF(maxr0 LT fdist2 AND maxr1 LT fdist2) THEN BEGIN
				FOR j=bucket_start(iTail), bucket_end(iTail) - 1L DO BEGIN
					id0	= pId(j)
					IF(pGroup[id0]) THEN CONTINUE
					pGroup[id0] = iGroup
					Fifo[iTail] = j & iTail ++
					pLen[iGroup] = pLen[iGroup] + 1L

					pNext[pTail[pHead[iid]]] = pHead[j]
					pTail[pHead[iid]] = pTail[pHead[j]]
					pHead[j]=pHead[iid]

					IF(iTail EQ numparts) THEN iTail = 0
				ENDFOR
			ENDIF ELSE BEGIN
				FOR j=bucket_start(iTail), bucket_end(iTail) -1L DO BEGIN
					IF(flag NE pHead[j]) THEN flag = 0
					id0	= pId(j)
					IF(pGroup[id0]) THEN CONTINUE
					dist2	= (pos[iid,0] - pos[j,0])^2 + $
						(pos[iid,1] - pos[j,1])^2 + $
						(pos[iid,2] - pos[j,2])^2

					IF(dist2 LT fdist2) THEN BEGIN
						pGroup[j] = iGroup
						Fifo[iTail] = j & iTail ++
						pLen[iGroup] = pLen[iGroup] + 1L

						pNext[pTail[pHead[iid]]] = pHead[j]
						pTail[pHead[iid]] = pTail[j]
						pHead[j] = pHead[iid]

						IF(iTail EQ numparts) THEN iTail = 0
						flag = 0
						print, j, dist2, fdist2
					ENDIF
				ENDFOR
				stop
			ENDELSE

		ENDREP UNTIL iHead EQ iTail

		;print, i, ' / ', iHead, ' / ', iGroup, ' / ', pLen[iGroup]
		IF(pLen[iGroup]<100) THEN BEGIN
			ii=pHead[pGroupHead[iGroup]]
			REPEAT BEGIN
				pGroup[pId[ii]] = -1
				ii	= pNext[ii]
			ENDREP UNTIL ii EQ -1
			pLen[iGroup] = 0 & iGroup = iGroup - 1L
		ENDIF

		IF(maxlen LT pLen[iGroup]) THEN maxlen = pLen[iGroup]

		IF i GE 100L THEN STOP

	ENDFOR

END
