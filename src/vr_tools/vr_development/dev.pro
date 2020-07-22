Pro dev

	;;-----
	;; Data
	;;-----

	n_snap	= 70L
	cname	= 'c10006'
	path_data	= '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2)+ '/galaxy/'
	raw_data_path	= '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	lib_path	= '/storage5/jinsu/idl_lib/lib/vraptor/'



	dmrange	= [1e8,1e10]

	;goto, skip
	;;-----
	;; Load
	;;-----
	dir_catalog	= '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2)+ '/galaxy/'
	dir_raw		= '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	dir_lib		= '/storage5/jinsu/idl_lib/lib/vraptor/'
	dir_save	= '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	dcolumn= ['ID', 'ID_mbp', 'Mvir', 'Mass_tot', 'Mass_200crit', 'R_size', 'R_200crit', 'R_HalfMass', 'Rvir', 'Xc', 'Yc', 'Zc', 'VXc', 'VYc', 'VZc', $
		'Lx', 'Ly', 'Lz', 'sigV', 'npart']

	flux_list	= ['u', 'g', 'r', 'i', 'z', 'FUV', 'NUV', 'IR_F105W', 'IR_F125W', 'IR_F160W']

	;n_snap	= 187L
	;dir_catalog	= '/storage5/FORNAX/VELOCI_RAPTOR/YZiCS/c39990/halo/'
	;column_list	= ['ID', 'ID_mbp', 'Mvir', 'Rvir', 'Xc', 'Yc', 'Zc', $
	;	'VXc', 'VYc', 'VZc', 'Lx', 'Ly', 'Lz', 'sigV', 'npart']

	num_thread	= 10L

	tic
	gal	= read_vraptor2(dir_catalog=dir_catalog, dir_raw=dir_raw, dir_lib=dir_lib, dir_save=dir_out, $
		column_list=dcolumn, flux_list=flux_list, /galaxy, $
		/silent, n_snap=n_snap, num_thread=num_thread, /verbose)
	

	toc, /verbose
	stop
	;stop
	;save, filename='load_gal_90.sav',gal
	skip:

	stop
	restore, 'load_gal.sav'
	;;----
	;;----
	xr	= [-1., 1.]
	yr	= [-1., 1.]
	n_pix	= 200L
	ctable	= 1
	cgDisplay, 1000, 500
	weight	= 'u'
	pos	= [0.08, 0.13, 0.48, 0.93]
	!p.color = 255B & !p.font = -1 & !p.charsize=1.0
	cgPlot, 0, 0, psym=16, xrange=xr, yrange=yr, symsize=0.5, /nodata, position=pos, $
		axiscolor='white', xtitle='X [kpc]', ytitle='Y [kpc]', background='black'

	ind	= where(gal.mvir eq max(gal.mvir))

	draw_gal, gal, id=ind, proj='edgeon', weight=weight, n_pix=n_pix, $
		xr=xr, yr=yr, symsize=0.15, ctable=ctable, num_thread=10L, /logscale


	pos	= pos + [0.5, 0., 0.5, 0.]
	cgPlot, 0, 0, xrange=xr, yrange=yr, /nodata, /noerase, position=pos, $
		axiscolor='white', xtitle='X [kpc]', ytitle='Y [kpc]', background='black'
	draw_gal, gal, id=ind, proj='faceon', weight=weight, n_pix=n_pix, $
		xr=xr, yr=yr, symsize=0.15, ctable=ctable, num_thread=10L, /logscale



	stop
	;;-----
	;; Write as a HDF file
	;;----
	path	= '/storage5/FORNAX/VELOCI_RAPTOR/test/'
	write_vraptor, gal, n_snap=n_snap, path=path, horg='g', data_list=dcolumn

	toc, /verbose
	stop

	;; Center - center of mass
	;; Center - position of the most bound ptcl

	;; Pos - kpc
	;; Vel - km/s
	;; age - Gyr
	;; sf - scale factor
	;; met - metallicity
	;; mp - solar mass
	;; Flux - Chabrier IMF // Sloand Band u g r i z // GALEX UV bands // HST IR bands
	;;	'u', 'g', 'r', 'i', 'z', 'FUV', 'NUV', 'IR_F105W', 'IR_F125W', 'IR_F160W'
	;;	[flux density/L_sun]
End
