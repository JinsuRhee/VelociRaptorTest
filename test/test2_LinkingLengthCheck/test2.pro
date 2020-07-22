Pro test2, settings

	n_snap	= 60L
	step1	= 2L	;; Read Data
	step2	= 1L	;; Size-Mass

	;gorg	- org 	Velocity_linking_length = 0.2
	;g_t1	- 	Velocity_linking_length = 0.1
	;g_t2	-	Velocity_linking_length = 0.05
	;g_t3	- 	Significance_level=2.0 (Default = 1.0)
	;g_t4	- 	Velocity_opening_angle=0.01 (Default = 0.1)
	;g_t5	-	Outlier_threshold=5.0 (Default = 2.5)
	;g_t6	-	Halo_6D_linking_length_factor=0.10 (Default = 0.2)
	;g_t7	-	Unbind flag

IF step1 EQ 1L THEN BEGIN
	cname	= 'c10006'
	dir_catalog     = '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2)+ '/galaxy/'
	dir_raw         = '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	dir_lib         = '/storage5/jinsu/idl_lib/lib/vraptor/'
	dir_save        = '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	dcolumn= ['ID', 'ID_mbp', 'Mvir', 'Mass_tot', 'Mass_200crit', 'R_size', 'R_200crit', 'R_HalfMass', 'Rvir', 'Xc', 'Yc', 'Zc', 'VXc', 'VYc', 'VZc', $
                'Lx', 'Ly', 'Lz', 'sigV', 'npart', 'Structuretype']
	flux_list       = ['u', 'g', 'r', 'i', 'z', 'FUV', 'NUV', 'IR_F105W', 'IR_F125W', 'IR_F160W']

	;gorg	= read_vraptor(dir_catalog=dir_catalog, dir_raw=dir_raw, dir_lib=dir_lib, dir_save=dir_out, $
        ;        column_list=dcolumn, flux_list=flux_list, /galaxy, /rv_match, $
        ;        /silent, n_snap=n_snap, num_thread=num_thread, /verbose)

	;save, filename=settings.root_path + 'test/test2*/org.sav', gorg
	;stop
	;g_t1	= read_vraptor(dir_catalog=dir_catalog, dir_raw=dir_raw, dir_lib=dir_lib, dir_save=dir_out, $
        ;        column_list=dcolumn, flux_list=flux_list, /galaxy, /rv_match, $
        ;        /silent, n_snap=n_snap, num_thread=num_thread, /verbose)
	;save, filename=settings.root_path + 'test/test2*/t1.sav', g_t1

	;g_t2	= read_vraptor(dir_catalog=dir_catalog, dir_raw=dir_raw, dir_lib=dir_lib, dir_save=dir_out, $
        ;        column_list=dcolumn, flux_list=flux_list, /galaxy, /rv_match, $
        ;        /silent, n_snap=n_snap, num_thread=num_thread, /verbose)
	;save, filename=settings.root_path + 'test/test2*/t2.sav', g_t2

	;g_t3	= read_vraptor(dir_catalog=dir_catalog, dir_raw=dir_raw, dir_lib=dir_lib, dir_save=dir_out, $
        ;        column_list=dcolumn, flux_list=flux_list, /galaxy, /rv_raw, $
        ;        /silent, n_snap=n_snap, num_thread=num_thread, /verbose)
	;save, filename=settings.root_path + 'test/test2*/t3.sav', g_t3

	g_t7	= read_vraptor_t(dir_catalog=dir_catalog, dir_raw=dir_raw, dir_lib=dir_lib, dir_save=dir_out, $
                column_list=dcolumn, flux_list=flux_list, /galaxy, /rv_raw, $
                /silent, n_snap=n_snap, num_thread=num_thread, /verbose)
	save, filename=settings.root_path + 'test/test2*/t7.sav', g_t7
ENDIF

	restore, settings.root_path + 'test/test2*/org.sav'
	restore, settings.root_path + 'test/test2*/t1.sav'
	restore, settings.root_path + 'test/test2*/t2.sav'
	restore, settings.root_path + 'test/test2*/t3.sav'
	restore, settings.root_path + 'test/test2*/t4.sav'
	restore, settings.root_path + 'test/test2*/t5.sav'
	restore, settings.root_path + 'test/test2*/t6.sav'
	restore, settings.root_path + 'test/test2*/t7.sav'
IF step2 EQ 1L THEN BEGIN

	test2_sizemass, settings, gorg, g_t7

	print, '^-^'
	wait, 123123
ENDIF

End
