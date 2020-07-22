Pro f_rdgal, gal, settings, n_snap, Gprop, mrange=mrange

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
	;; Allocate Memory
	;;-----
	cut	= where(mdum ge mrange(0) and mdum le mrange(1))
	nn	= n_elements(cut)

	For i=0L, n_elements(Gprop) - 1L DO BEGIN
	       tmp	= Gprop(i) + ' = dblarr(nn)'
	       if Gprop(i) eq 'ID' then $
		       tmp = Gprop(i) + ' = lonarr(nn)'

	       if Gprop(i) eq 'ABmag' then $
		       tmp = Gprop(i) + ' = dblarr(nn, n_elements(settings.flux_list))'

	       void	= execute(tmp)
	EndFor

	;;-----
	;; Read Galaxies
	;;-----

	indG	= 0L
	For i=0L, n_gal - 1L Do Begin
		If(mdum(i) lt mrange(0)) Then Continue
		If(mdum(i) gt mrange(1)) Then Continue

		fid	= H5F_OPEN(flist(i))
		For j=0L, n_elements(Gprop) - 1L Do Begin
			did	= H5D_OPEN(fid, '/G_Prop/G_' + $
				strtrim(Gprop(j),2))

			tmp	= Gprop(j) + '(indG) = H5D_READ(did)'

			if Gprop(j) eq 'ABmag' then $
				tmp	= Gprop(j) + '(indG,*) = H5D_READ(did)'
			void	= execute(tmp)
			H5D_close, did
		Endfor

		did	= H5D_open(fid, '/Domain_List')
		if i eq 0L then dlist = H5D_READ(did)
		if i eq 0L then n_mpi=n_elements(dlist)
		if i eq 0L then d_list=lonarr(n_gal,n_mpi)
		d_list(i,*) = H5D_READ(did)
		H5D_close, did

		did	= H5D_open(fid, '/Flux_List')
		f_list	= H5D_READ(did)
		H5D_close, did

		H5F_close, fid
		indG ++
	Endfor

	;;-----
	;; Create Structure
	;;-----

	For j=0L, n_elements(Gprop)-1L Do Begin
		if j eq 0L then $
			tmp	= 'GP = create_struct(Gprop(j), ' + Gprop(j) + ')'
		if j ge 1L then $
			tmp	= 'GP = create_struct(GP, Gprop(j), ' + Gprop(j) + ')'
		void	= execute(tmp)
	Endfor

	GP	= create_struct(GP,'Domain_List', d_list, 'Flux_List', f_list)
	gal	= GP

End
