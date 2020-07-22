Pro run

	cname	= 'c10006'
	dir_catalog	= '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2)+ '/galaxy/'
	dir_raw	= '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	dir_lib	= '/storage5/jinsu/idl_lib/lib/vraptor/'
	column_list     = ['ID', 'ID_mbp', 'Mvir', 'Mass_tot', 'Mass_200crit', $
		'Rvir', 'R_size', 'R_200crit', 'R_HalfMass', $
		'Xc', 'Yc', 'Zc', 'VXc', 'VYc', 'VZc', 'Lx', 'Ly', 'Lz', 'sigV', 'npart']
	num_thread	= 5L

	;;;;;
	mrange	= [1e8, 1e10]
	flux_list       = ['u', 'g', 'r', 'i', 'z', 'FUV', 'NUV', 'IR_F105W', 'IR_F125W', 'IR_F160W']
	lib_path        = '/storage5/jinsu/idl_lib/lib/vraptor/'
	for i=70L, 70L, 10L do begin
		n_snap = i
		gal	= read_vraptor(dir_catalog=dir_catalog, dir_raw=dir_raw, dir_lib=dir_lib, column_list=column_list, /galaxy, /silent, n_snap=n_snap, flux_list=flux_list, num_thread=num_thread, /verbose, /rv_match)

		print, '      ----- ', i, ' / ', ' 90'
	endfor
stop
End
