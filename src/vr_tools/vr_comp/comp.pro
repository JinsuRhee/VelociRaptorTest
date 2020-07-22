Pro comp

	cname	= 'c10006'
	n_snap	= 93L

	;;-----
	;; VR Data
	;;-----
	dir_catalog     = '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2)+ '/galaxy/'
	dir_raw         = '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	dir_lib         = '/storage5/jinsu/idl_lib/lib/vraptor/'
	flux_list       = ['u', 'g', 'r', 'i', 'z', 'FUV', 'NUV', 'IR_F105W', 'IR_F125W', 'IR_F160W']

	column_list     = ['ID', 'ID_mbp', 'Mvir', 'Rvir', 'R_size', 'R_HalfMass', 'Xc', 'Yc', 'Zc', $
		'VXc', 'VYc', 'VZc', 'Lx', 'Ly', 'Lz', 'sigV', 'npart']
	num_thread      = 20L

	vr	= read_vraptor(dir_catalog=dir_catalog, dir_raw=dir_raw, dir_lib=dir_lib, column_list=column_list, /galaxy, $
		 /silent, n_snap=n_snap, flux_list=flux_list,  num_thread=num_thread, /verbose)

	;;-----
	;; GMaker Data
	;;	1) Distance > kpc from 0 to 100
	;;	2) Speed > km/s
	;;	3) Rvir > kpc
	;;	4) Mvir > Msun
	;;-----

	fname	= dir_raw + 'galaxy/tree_bricks' + string(n_snap,format='(I3.3)')
	finfo	= dir_raw + '/output_' + string(n_snap,format='(I5.5)') + '/info_' + string(n_snap,format='(I5.5)') + '.txt'
	gm	= read_halo(fileDM=fname, fileinfo=finfo, /verbose)

	rd_info, siminfo, file=finfo
	save, filename='dum_' + string(n_snap,format='(I3.3)') + '.sav', vr, gm, siminfo
End
