Pro p_VRrun, settings

	N1	= Settings.P_VRrun_snap(0)
	N2	= Settings.P_VRrun_snap(1)
	DN	= Settings.P_VRrun_snap(2)

	for i=N1, N2, DN do begin
		n_snap	= i
		Dir_catalog	= settings.dir_catalog + $
			settings.dir_catalog_pre + $
			string(n_snap,format='(I3.3)') + $
			settings.dir_catalog_suf + '/'
		tmp	= 'void = read_vraptor(' + $
			'Dir_catalog    = dir_catalog,' + $
			'Dir_raw	= Settings.dir_raw,' + $
			'Dir_lib	= Settings.dir_lib,' + $
			'Dir_save	= Settings.dir_save,' + $
			'Column_list	= Settings.column_list,' + $
			'Flux_list	= Settings.flux_list,' + $
			'N_snap		= n_snap,' + $
			'Num_thread	= Settings.num_thread,' + $
			'SFR_t		= Settings.P_VRrun_SFR_t,' + $
			'SFR_r		= Settings.P_VRrun_SFR_r,' + $
			'Mag_r		= Settings.P_VRrun_mag_r,' + $
			'/silent, /verbose'

		if Settings.cname eq 'l10006' then $
			tmp = tmp + ', /longint'
		if Settings.P_VRrun_horg eq 'g' then tmp = tmp + ', /galaxy'
		if Settings.P_VRrun_horg eq 'h' then tmp = tmp + ', /halo'

		for j=0L, n_elements(Settings.P_VRrun_step) - 1L do $
			tmp = tmp + ', /' + strtrim(Settings.P_VRrun_step(j),2)

		tmp	= tmp + ')'
		void	= execute(tmp)
		print, '      ----- ', i, ' / ', N2
	endfor


			

End

