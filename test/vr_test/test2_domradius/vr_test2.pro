Pro vr_test2, settings

	;;-----
	;; Load Data
	;;----
	n_snap  = 60L
	cname   = 'c10006'
	
	dir_catalog     = '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2)+ '/galaxy/'
	dir_raw         = '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	dir_lib         = '/storage5/jinsu/idl_lib/lib/vraptor/'
	dcolumn= ['ID', 'Structuretype', 'ID_mbp', 'Mvir', 'Mass_tot', 'Mass_200crit', 'R_size', 'R_200crit', 'R_HalfMass', 'Rvir', 'Xc', 'Yc', 'Zc', 'VXc', 'VYc', 'VZc', $
	        'Lx', 'Ly', 'Lz', 'sigV', 'npart']
	num_thread      = 30L
	
	gal     = read_vraptor(dir_catalog=dir_catalog, dir_raw=dir_raw, dir_lib=dir_lib, dir_save=dir_out, $
	       column_list=dcolumn, flux_list=flux_list, /galaxy, /rv_match, $
	       /silent, n_snap=n_snap, num_thread=num_thread, /verbose);, /longint)


        n_gal	= n_elements(gal.id)
	frac	= dblarr(n_gal)

	for i=0L, n_gal - 1L do begin
                ind1    = gal.b_ind(i,*)
                ind2    = gal.u_ind(i,*)

                tt      = [gal.p_age(ind1(0):ind1(1)),gal.p_age(ind2(0):ind2(1))]

                frac(i) = n_elements(where(tt gt -1d7)) * 1.d / n_elements(tt)
        endfor

        js_stat, frac
        cgPlot, gal.mvir, frac, psym=16, /xlog, xrange=[1e3, 1e11]
        stop
End
