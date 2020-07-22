Pro f_rdptcl, ptcl, settings, n_snap, ID, Pprop

	dir	= Settings.dir_save + $
		'VR_Galaxy/snap_' + string(n_snap,format='(I3.3)') + '/'

	flist	= file_search(dir + 'GAL_' + string(ID,format='(I6.6)') + '.hdf5')

	;;-----
	;; Open File
	;;-----
	fid	= H5F_OPEN(flist)

	;;-----
	;; Read Ptcl Number First
	;;-----
	did1	= H5D_OPEN(fid, '/P_Prop/P_Nbdn')
	did2	= H5D_OPEN(fid, '/P_Prop/P_Nubd')
	numpart	= H5D_READ(did1) + H5D_READ(did2)
	H5D_close, did1
	H5D_close, did2

	;;-----
	;; Allocate Memory
	;;-----
	For i=0L, n_elements(Pprop) - 1L Do Begin
		tmp	= Pprop(i) + ' = dblarr(numpart)'
		If Pprop(i) eq 'Pos' or Pprop(i) eq 'Vel' then $
			tmp	= Pprop(i) + ' = dblarr(numpart,3)'

		If Pprop(i) eq 'Flux' then $
			tmp	= Pprop(i) + ' = dblarr(numpart, n_elements(settings.flux_list))'

		void	= execute(tmp)
	Endfor


	;;-----
	;; Read Galaxies
	;;-----

	indP1	= 0L
	indP2	= numpart-1L

	For j=0L, n_elements(Pprop) - 1L Do Begin
		did	= H5D_OPEN(fid, '/P_Prop/P_' + $
			strtrim(Pprop(j),2))

		tmp	= Pprop(j) + ' = H5D_READ(did)'
		void	= execute(tmp)

		H5D_close, did
	Endfor


	H5F_close, fid

	;;-----
	;; Create Structure
	;;-----

	For j=0L, n_elements(Pprop)-1L Do Begin
		if j eq 0L then $
			tmp	= 'PP = create_struct(Pprop(j), ' + Pprop(j) + ')'
		if j ge 1L then $
			tmp	= 'PP = create_struct(PP, Pprop(j), ' + Pprop(j) + ')'
		void	= execute(tmp)
	Endfor

	ptcl	= PP

End
