;; For particles to find the hosted domain

Pro fd_domain_check

	cname	= 'c07887'
	
	path	= '/storage5/FORNAX/VE*/c07887/galaxy/'
	files	= file_search(path + 'snap_*/domain.sav')

	dx	= randomu(5,1000000)
	dy	= randomu(6,1000000)
	dz	= randomu(7,1000000)

	;for i=0L, n_elements(files)-1L do begin
	;for i=22L, n_elements(files)-1L do begin
	for i=18L, 18L do begin
		restore, files(i)

		for j=0L, 999999L do begin
			cut	= where(dom_x(*,0) lt dx(j) and dom_x(*,1) gt dx(j) and dom_y(*,0) lt dy(j) and dom_y(*,1) gt dy(j) and dom_z(*,0) lt dz(j) and dom_z(*,1) gt dz(j))
			if max(cut) lt 0L then begin
				print, dx(j), dy(j), dz(j)
				stop
			endif
		endfor

		print, i, ' - done'
	endfor


End
