Pro rd_vr

	dcolumn= ['ID', 'ID_mbp', 'Mvir', 'Rvir', 'Xc', 'Yc', 'Zc', 'VXc', 'VYc', 'VZc', $
		'Lx', 'Ly', 'Lz', 'sigV', 'npart']

	;;-----
	;; Data
	;;-----

	for i=15L, 54L do begin
	n_snap	= i
	path_data	= '/storage5/FORNAX/VELOCI_RAPTOR/c07887/galaxy/'
	raw_data_path	= '/storage5/FORNAX/KISTI_OUTPUT/c07887/'
	lib_path	= '/storage5/jinsu/idl_lib/lib/vraptor/'
	flux_list	= ['u', 'g', 'r', 'i', 'z', 'FUV', 'NUV', 'IR_F105W', 'IR_F125W', 'IR_F160W']

	;;-----
	;; Load
	;;-----
	tic
	gal	= read_vraptor(path_data, data_list=dcolumn, horg='g', /silent, /particle, n_snap=n_snap, raw_data=raw_data_path, flux_list=flux_list, lib_path=lib_path)

	toc, /verbose
	print, i, ' - done'
	endfor
	stop

End
