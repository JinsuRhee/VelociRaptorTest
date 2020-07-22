Pro rd_log

	FN_c0		= file_search('/storage5/FORNAX/VEL*/c07887/galaxy/snap_0*/logfile.log')
	FN_c1		= file_search('/storage5/FORNAX/VEL*/c10006/galaxy/snap_0*/logfile.log')

	;;;;;
	FN_c0_npt	= lonarr(n_elements(FN_c0)-1L) + 1L
	FN_c1_npt	= lonarr(n_elements(FN_c1)-1L) + 1L

	FN_c0_time	= fltarr(n_elements(FN_c0)-1L) + 1.
	FN_c1_time	= fltarr(n_elements(FN_c1)-1L) + 1.

	for i=0L, 61L do begin; n_elements(FN_c0) - 2L do begin
		if i eq 60L then continue
		spawn, 'grep "particles in total that require" ' + FN_c0(i), aa
		ind1	= strpos(aa, 'particles')
		aa	= strmid(aa,10,ind1 - 10)
		FN_c0_npt(i)= long(aa)

		spawn, 'grep "in all" ' + FN_c0(i), aa
		aa	= aa(0)
		aa	= strsplit(aa,'took',/extract)
		aa	= aa(1)
		aa	= strsplit(aa,'in all',/extract)
		aa	= aa(0)
		FN_c0_time(i) = float(aa)
	endfor

	for i=0L, n_elements(FN_c1) - 2L do begin
		spawn, 'grep "particles in total that require" ' + FN_c1(i), aa
		ind1	= strpos(aa, 'particles')
		aa	= strmid(aa,10,ind1 - 10)
		FN_c1_npt(i)= long(aa)

		spawn, 'grep "in all" ' + FN_c1(i), aa
		aa	= aa(0)
		aa	= strsplit(aa,'took',/extract)
		aa	= aa(1)
		aa	= strsplit(aa,'in all',/extract)
		aa	= aa(0)
		FN_c1_time(i) = float(aa)
	endfor

	cgPlot, FN_c0_npt, FN_c0_time, psym=9, /xlog, /ylog, xrange=[1e6,1e9], yrange=[1e2, 1e6], xtitle = 'N_ptcl', ytitle='Time (s)'
	cgOplot, FN_c1_npt,FN_c1_time, psym=16, color='red'

	FN_c1_r_npt = [100628459]
	FN_c1_r_time = [45076.21113]

	cgOplot, FN_c1_r_npt, FN_c1_r_time, psym=16, color='blue'
	;cut	= where(FN_c0_npt gt 0.)
	;X0	= alog10(FN_c0_npt(cut))
	;Y0	= alog10(FN_c0_time(cut))




End
