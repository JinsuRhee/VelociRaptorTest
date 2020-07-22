Pro f_rdgal, gal, settings, n_snap, Gprop=Gprop, Pprop=Pprop, mrange=mrange

	dir	= Settings.dir_save + $
		'VR_Galaxy/snap_' + string(n_snap,format='(I3.3)') + '/'
	;flist	= file_search(dir + 'GAL_*')

        ;ftr_name	= Settings.root_path + 'src/sub/fortran/f_rdgal.so'
	;larr = lonarr(20) & darr = dblarr(20)
	;	larr(0)	= n_snap
	;	larr(1) = Settings.num_thread
	;	larr(2) = n_elements(flist)	;; # of Galaxies
	;	larr(10)= strlen(dir)

	;void	= call_external(ftr_name, 'f_rdgal', $
	;	larr, darr, dir)

	;stop
	dir	= Settings.dir_save + $
		'VR_Galaxy/snap_' + string(n_snap,format='(I3.3)') + '/'

	flist	= file_search(dir + 'GAL_*')
	n_gal	= n_elements(flist)


	;;-----
	;; Mass Cut
	;;-----
	if keyword_set(mrange) then begin
		flist2	= file_search(dir + 'mlist.sav')
		if strlen(flist2) ge 5L then begin
			restore, dir + 'mlist.sav'
		endif else begin
			mdum	= dblarr(n_gal)
			for i=0L, n_gal - 1L do begin
				fid	= H5F_OPEN(flist(i))
				did	= H5D_OPEN(fid, '/G_Prop/G_Mass_tot')
				mdum(i)	= H5D_READ(did)
				H5D_close, did
				H5F_close, fid
			endfor
			save, filename=dir + 'mlist.sav', mdum
		endelse
	endif else begin
		mrange	= fltarr(2)
		mrange(0) = -1.
		mrange(1) = 1e20
		mdum	= dblarr(n_gal) + 1.
	endelse

	;;-----
	;; NPart Check
	;;-----
	flist2	= file_search(dir + 'npart.sav')
	If strlen(flist2) ge 5L Then Begin
		restore, dir + 'npart.sav'
	Endif Else Begin
		numpart	= lonarr(n_gal)
		For i=0L, n_gal - 1L do begin
		       fid	= H5F_OPEN(flist(i))
		       did1	= H5D_OPEN(fid, '/P_Prop/P_Nbdn')
		       did2	= H5D_OPEN(fid, '/P_Prop/P_Nubd')
		       numpart(i)	= H5D_READ(did1) + H5D_READ(did2)
		       H5D_close, did1
		       H5D_close, did2
		       H5F_close, fid
		Endfor
		save, filename=dir + 'npart.sav', numpart
	EndElse

	;;-----
	;; Allocate Memory
	;;-----
	cut	= where(mdum ge mrange(0) and mdum le mrange(1))
	nn	= n_elements(cut)

	;;Gals
	If keyword_set(Gprop) Then Begin
		For i=0L, n_elements(Gprop) - 1L DO BEGIN
		       tmp	= Gprop(i) + ' = dblarr(nn)'
		       if Gprop(i) eq 'ID' then $
			       tmp = Gprop(i) + ' = lonarr(nn)'

		       if Gprop(i) eq 'ABmag' then $
			       tmp = Gprop(i) + ' = dblarr(nn, n_elements(settings.flux_list))'

		       void	= execute(tmp)
		EndFor
	Endif



	;;Ptcls
	If keyword_set(Pprop) Then Begin
		nn_pt	= long(total(numpart(cut)))
		p_ind	= lonarr(nn,2)
		For i=0L, n_elements(Pprop) - 1L Do Begin
			tmp	= Pprop(i) + ' = dblarr(nn_pt)'
			If Pprop(i) eq 'Pos' or Pprop(i) eq 'Vel' then $
				tmp	= Pprop(i) + ' = dblarr(nn_pt,3)'

			If Pprop(i) eq 'Flux' then $
				tmp	= Pprop(i) + ' = dblarr(nn_pt, n_elements(settings.flux_list))'

			void	= execute(tmp)
		Endfor
	Endif


	;;-----
	;; Read Galaxies
	;;-----

	indG	= 0L
	indP1	= 0L
	indP2	= 0L
	For i=0L, n_gal - 1L Do Begin
		If(mdum(i) lt mrange(0)) Then Continue
		If(mdum(i) gt mrange(1)) Then Continue

		fid	= H5F_OPEN(flist(i))
		If keyword_set(Gprop) then begin
			For j=0L, n_elements(Gprop) - 1L Do Begin
				did	= H5D_OPEN(fid, '/G_Prop/G_' + $
					strtrim(Gprop(j),2))

				tmp	= Gprop(j) + '(indG) = H5D_READ(did)'

				if Gprop(j) eq 'ABmag' then $
					tmp	= Gprop(j) + '(indG,*) = H5D_READ(did)'
				void	= execute(tmp)
				H5D_close, did
			Endfor
		Endif

		If keyword_set(Pprop) Then Begin
			indP2	= indP1 + numpart(i) - 1L
			For j=0L, n_elements(Pprop) - 1L Do Begin
				did	= H5D_OPEN(fid, '/P_Prop/P_' + $
					strtrim(Pprop(j),2))

				tmp	= Pprop(j) + '(indP1:indP2) = H5D_READ(did)'

				if Pprop(j) eq 'Pos' or Pprop(j) eq 'Vel' or Pprop(j) eq 'Flux' then $
					tmp	= Pprop(j) + '(indP1:indP2,*) = H5D_READ(did)'

				void	= execute(tmp)

				H5D_close, did
			Endfor

			p_ind(indG,0)	= indP1
			p_ind(indG,1)	= indP2
			indP1	= indP2 + 1L
		Endif

		H5F_close, fid
		indG ++

	Endfor

	;;-----
	;; Create Structure
	;;-----

	If keyword_set(Gprop) Then Begin
		For j=0L, n_elements(Gprop)-1L Do Begin
			if j eq 0L then $
				tmp	= 'GP = create_struct(Gprop(j), ' + Gprop(j) + ')'
			if j ge 1L then $
				tmp	= 'GP = create_struct(GP, Gprop(j), ' + Gprop(j) + ')'
			void	= execute(tmp)
		Endfor
	Endif Else Begin
		GP = 'No data'
	Endelse

	If keyword_set(Pprop) Then Begin
		For j=0L, n_elements(Pprop)-1L Do Begin
			if j eq 0L then $
				tmp	= 'PP = create_struct(Pprop(j), ' + Pprop(j) + ')'
			if j ge 1L then $
				tmp	= 'PP = create_struct(PP, Pprop(j), ' + Pprop(j) + ')'
			void	= execute(tmp)
		Endfor
	Endif Else Begin
		PP = 'No data'
	Endelse

	gal	= {GP:GP, PP:PP}

End
