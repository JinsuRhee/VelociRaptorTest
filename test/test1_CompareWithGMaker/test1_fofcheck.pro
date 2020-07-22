Pro test1_fofcheck, settings, vr, id, n_snap, xr, yr, zr

	step1	= 1L	;; 3D FoF

	f_rdptcl, ptcl, settings, n_snap, vr.id(id), ['Pos', 'Vel']

	inter_dist	= (xr(1)-xr(0))*(yr(1)-yr(0))*(zr(1)-zr(0))
	num	= js_bound([[ptcl.pos(*,0)], [ptcl.pos(*,1)], [ptcl.pos(*,2)]], [[xr], [yr], [zr]])
	inter_dist	= (inter_dist / n_elements(num))^(1./3)

IF step1 EQ 1L THEN BEGIN

	fofcheck	= lonarr(n_elements(ptcl.pos(*,0))) - 1L
	group_ptcl	= dblarr(n_elements(ptcl.pos(*,0)),1) - 1d8

		group_ptcl(*,0) = 1.
		;; 0	- mean ptcl distance

	nn = -1L
	mm = -1L
	REPEAT BEGIN
		cut	= where(fofcheck lt 0L)
		nn	= n_elements(cut)

		FOR i=0L, n_elements(fofcheck) - 1L DO BEGIN
			ind	= i;cut(i)
			dum	= (ptcl.pos(ind,0) - ptcl.pos(*,0))^2 + $
				(ptcl.pos(ind,1) - ptcl.pos(*,1))^2 + $
				(ptcl.pos(ind,2) - ptcl.pos(*,2))^2
			dum	= sqrt(dum)
			dum(ind)= max(dum)
			cut2	= where(dum eq min(dum))
			IF dum(cut2)/inter_dist ge 0.2 THEN CONTINUE

			IF fofcheck(cut2) lt 0L THEN BEGIN	;; Create FOF group
				fofcheck(cut2)	= ind
				fofcheck(ind)	= ind
				group_ptcl(ind,0)	= dum(cut2)/2.
				group_ptcl(cut2,0)	= dum(cut2)/2.
			ENDIF ELSE BEGIN			;; LINKING PTCL
				fofcheck(ind)	= fofcheck(cut2)
				cut3	= where(fofcheck eq fofcheck(ind))

				dum3	= 0.
				FOR j=0L, n_elements(cut3) - 1L DO BEGIN
					dum2	= (ptcl.pos(cut3(j),0) - ptcl.pos(cut3,0))^2 + $
						(ptcl.pos(cut3(j),1) - ptcl.pos(cut3,1))^2 + $
						(ptcl.pos(cut3(j),2) - ptcl.pos(cut3,2))^2
					dum2(where(dum2 eq 0.)) = 1.0d8
					dum3	= dum3 + min(dum2)
				ENDFOR
				group_ptcl(cut3,0)	= dum3/n_elements(cut3)
			ENDELSE
		ENDFOR
		print, n_elements(where(fofcheck ge 0L)), ' / ', n_elements(fofcheck)
	ENDREP UNTIL nn eq n_elements(where(fofcheck lt 0L))

	fofnum	= fofcheck
	fofnum	= fofnum(sort(fofnum))
	fofnum	= fofnum(uniq(fofnum))
	FOFID	= -1L
	FOR i=0L, n_elements(fofnum)-1L DO BEGIN
		cut	= where(fofcheck eq fofnum(i))
		IF n_elements(cut) lt 10L THEN CONTINUE
		FOFID	= [FOFID,fofnum(i)]
	ENDFOR
	FOFID	= FOFID(1L:*)




	;cgOplot, ptcl(0,0), ptcl(0,1), psym=16, symsize=1.5, color='blue'
	stop
ENDIF










End
