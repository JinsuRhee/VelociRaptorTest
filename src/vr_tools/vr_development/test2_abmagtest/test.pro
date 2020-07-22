Pro test

	n_snap	= 90L

	cname   = 'c10006'
	dir_catalog     = '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2)+ '/galaxy/'
	dir_raw         = '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	dir_lib         = '/storage5/jinsu/idl_lib/lib/vraptor/'
	dcolumn= ['ID', 'ID_mbp', 'Mvir', 'Mass_tot', 'Mass_200crit', 'R_size', 'R_200crit', 'R_HalfMass', 'Rvir', 'Xc', 'Yc', 'Zc', 'VXc', 'VYc', 'VZc', $
                'Lx', 'Ly', 'Lz', 'sigV', 'npart']
	flux_list       = ['u', 'g', 'r', 'i', 'z', 'FUV', 'NUV', 'IR_F105W', 'IR_F125W', 'IR_F160W']

	num_thread	= 10L
	gal     = read_vraptor(dir_catalog=dir_catalog, dir_raw=dir_raw, dir_lib=dir_lib, column_list=dcolumn, /galaxy,  $
                /silent, n_snap=n_snap, flux_list=flux_list,  num_thread=num_thread, /verbose)


	rd_info, info, file=dir_raw + 'output_' + string(n_snap,format='(I5.5)') + '/info_' + string(n_snap, format='(I5.5)') + '.txt'
	
	;;-----

		restore, 'w4_galaxies.sav'
	m	= gal.mvir
	u	= gal.abmag(*,0)
	g	= gal.abmag(*,1)
	r	= gal.abmag(*,2)
	mag	= {u:u, g:g, r:r}
	tn	= tag_names(mag)
	obmag	= {u:g_data.u_ab, g:g_data.g_ab, r:g_data.r_ab}
	for ii=0L, 2L do begin
		r = mag.(ii)

		cgPS_open, filename='snap_' + strtrim(n_snap,2) + '_' + strtrim(tn(ii),2) + '.eps', /encapsulated
		cgDisplay, 800, 800
		!p.color = 0B & !p.font = -1 & !p.charsize=2.0
		cgPlot, m, r, psym=16, symsize=0.5, /xlog, xrange=[1e6, 1e11], yrange=[-22., -10.]

		cut	= where(r gt -1d7 and m gt 1e7)
		lin	= linfit(alog10(m(cut)), r(cut))
		xx	= findgen(100)/99. * 5. + 6.
		cgOplot, 10^xx, xx*lin(1) + lin(0), linestyle=0, color='black', thick=3

		ind	= long(randomu(10,10000)*n_elements(g_data.ra))
		cgOplot, 10^g_data.smass(ind), obmag.(ii)(ind), psym=16, symsize=0.3, color='red'

		lin	= linfit(g_data.smass, obmag.(ii))
		cgOplot, 10^xx, xx*lin(1) + lin(0), linestyle=0, color='red', thick=3

		cgLegend, titles=['YZiCS2', 'SDSS'], color=['black', 'red'], vspace=3.0, location=[1e9, -11], alignment=0, length=0., psym=[16, 16], symsize=2., charthick=3, /box, /data
		cgText, 1e9, -13.5, 'a = ' + string(info.aexp,format='(F5.3)'), /data, charthick=3
		cgPS_close
	endfor
	stop
End
