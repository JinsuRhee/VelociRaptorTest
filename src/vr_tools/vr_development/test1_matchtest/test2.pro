Pro test2

	fname='/storage5/FORNAX/KISTI_OUTPUT/c10006/output_00040/part_00040.out'
	rd_part, part, file=fname, ncpu=10, icpu=170, /domain

	cut	= where(part.family eq 2L)
	xp	= part.xp(cut,*)
	id_p	= part.id(cut)
	dom	= part.domain(cut)
	stop
	restore, 'id_821.sav'
	nn = 0L
	for i=0L, n_elements(id)-1L do begin
		cut	= where(id_p eq id(i))
		if max(cut) lt 0L then continue
		print, i, ' // ', n_elements(id), id(i), id_p(cut), dom(cut)
		if dom(cut) ne 172 then stop
		nn = nn + 1L;n_elements(cut)
	endfor
	print, nn
	stop
end

