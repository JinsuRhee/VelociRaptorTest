Pro test

	n_snap	= 40L
	cname	= 'c10006'
	dir_catalog     = '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2)+ '/galaxy/'
	dir_raw         = '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	dir_lib         = '/storage5/jinsu/idl_lib/lib/vraptor/'
	dcolumn= ['ID', 'ID_mbp', 'Mvir', 'Mass_tot', 'Mass_200crit', 'R_size', 'R_200crit', 'R_HalfMass', 'Rvir', 'Xc', 'Yc', 'Zc', 'VXc', 'VYc', 'VZc', 'Lx', 'Ly', 'Lz', 'sigV', 'npart']

	num_thread      = 20L

	gal     = read_vraptor(dir_catalog=dir_catalog, dir_raw=dir_raw, dir_lib=dir_lib, column_list=dcolumn, /galaxy, /silent, n_snap=n_snap, flux_list=flux_list,  num_thread=num_thread, /verbose)

	cut	= where(gal.mvir ge max(gal.mvir))
	cut	= 821L

	pos	= [gal.xc(cut), gal.yc(cut), gal.zc(cut)]
	infoname=dir_raw + 'output_' + string(n_snap,format='(I5.5)') + '/info_' + string(n_snap,format='(I5.5)') + '.txt'
	rd_info, siminfo, file=infoname
	pos	= pos * 3.086d21 / siminfo.unit_l
	rr	= gal.r_size(cut) * 3.086d21 / siminfo.unit_l

	dom	= lonarr(2400) - 1L
	fname  = dir_raw + 'output_' + string(n_snap,format='(I5.5)') + $
                '/part_' + string(n_snap,format='(I5.5)') + '.out'

	rfact	= 10.
	print, gal.mvir(cut)
	for i=0, 2399L do begin
		rd_part, part, file=fname, ncpu=1, icpu=i, /time, /metal, /vel, /silent
		cut_pt1	= where(part.family eq 2L)
		xx	= part.xp(cut_pt1,*)

		cut1	= where(abs(xx(*,0) - pos(0)) lt mean(rfact*rr) and $
			abs(xx(*,1) - pos(1)) lt mean(rfact*rr) and $
			abs(xx(*,2) - pos(2)) lt mean(rfact*rr))
		;dis	= (xx(*,0) - pos(0))^2 + (xx(*,1) - pos(1))^2 + (xx(*,2) - pos(2))^2
		;dis	= sqrt(dis)
		;cut_pt	= where(dis lt mean(rfact * rr))
		;if max(cut_pt) ge 0L then dom(i) = 1L
		if max(cut1) ge 0L then dom(i) = 1L

		print, i, ' / ', 2399L, ' / ', n_elements(cut_pt1), ' / ', n_elements(cut1)
	endfor
	stop
end


