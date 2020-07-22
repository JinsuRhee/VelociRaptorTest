Pro mtest

	;;-----
	;; Data
	;;-----

	n_snap	= 95 
	cname	= 'c10006'
	path_data	= '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2)+ '/galaxy/'
	raw_data_path	= '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	lib_path	= '/storage5/jinsu/idl_lib/lib/vraptor/'

	flux_list	= ['u', 'g', 'r', 'i', 'z', 'FUV', 'NUV', 'IR_F105W', 'IR_F125W', 'IR_F160W']
	dcolumn= ['ID', 'ID_mbp', 'Mvir', 'Rvir', 'Xc', 'Yc', 'Zc', 'VXc', 'VYc', 'VZc', $
		'Lx', 'Ly', 'Lz', 'sigV', 'npart']

	dmrange	= [1e8,1e10]
	;;-----
	;; Load
	;;-----
	dir_catalog	= '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2)+ '/galaxy/'
	dir_raw		= '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	dir_lib		= '/storage5/jinsu/idl_lib/lib/vraptor/'

	column_list	= ['ID', 'ID_mbp', 'Mvir', 'Rvir', 'Xc', 'Yc', 'Zc', $
		'VXc', 'VYc', 'VZc', 'Lx', 'Ly', 'Lz', 'sigV', 'npart']

	num_thread	= 20L

	tic
	gal	= read_vraptor(dir_catalog=path_data, dir_raw=dir_raw, dir_lib=dir_lib, column_list=dcolumn, /galaxy, $
		/silent, n_snap=n_snap, flux_list=flux_list,  num_thread=num_thread, /verbose)

	toc, /verbose

	n_gal	= n_elements(gal.id)
	frac	= dblarr(n_gal)

	for i=0L, n_gal-1L do begin
		ind1	= gal.b_ind(i,*)
		ind2	= gal.u_ind(i,*)

		tt	= [gal.p_age(ind1(0):ind1(1)),gal.p_age(ind2(0):ind2(1))]

		frac(i)	= n_elements(where(tt gt -1d7)) * 1.d / n_elements(tt)
		if i eq 1926L then print, n_elements(tt), n_elements(where(tt gt -1d7))
	endfor

	js_stat, frac
	cgPlot, gal.mvir, frac, psym=16, /xlog, xrange=[1e4, 1e11]
	stop
End
