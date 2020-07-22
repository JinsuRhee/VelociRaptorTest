;; For particles to find the hosted domain

Pro fd_domain

	cname	= 'c07887'
	
	path	= '/storage5/FORNAX/KISTI_OUTPUT/' + cname + '/'
	outputs	= file_search(path + 'output_*')

	split_for, 74L, 123L, commands=[$
		'dom_x	= fltarr(2400,2)', $
		'dom_y	= fltarr(2400,2)', $
		'dom_z	= fltarr(2400,2)', $

		'for n=1L, 2400L do begin', $

		'	;;-----', $
		'	;; Read Part', $
		'	;;-----', $

		'	fname	= outputs(i) + "/part_" + string(i+1,format="(I5.5)") + ".out"', $
		'	rd_part, part, file=fname, icpu=n, ncpu=1, /silent', $

		'	if part.stat eq "ng" then begin', $
		'		dom_x(n-1,*) = [0., 0.]', $
		'		dom_y(n-1,*) = [0., 0.]', $
		'		dom_z(n-1,*) = [0., 0.]', $
		'		continue', $
		'	endif', $
		'	', $
		'	;;-----', $
		'	;; Read Info', $
		'	;;-----', $

		'	rd_info, info, file=outputs(i) + "/info_" + string(i+1,format="(I5.5)") + ".txt"', $

		'	;;-----', $
		'	;; Compute Refined DM mass', $
		'	;;-----', $

		'	dmp_mass        = 1./(4096.^3) * (info.omega_m - info.omega_b) / info.omega_m', $

		'	cut_dm		= where(part.family eq 1L and abs(part.mp - dmp_mass)/dmp_mass lt 1e-5)', $
		'	xp		= part.xp(cut_dm,*)', $

		'	min = min(xp(*,0)) & max = max(xp(*,0))', $
		'	dom_x(n-1,0)	= min - (max - min)/100.', $
		'	dom_x(n-1,1)	= max + (max - min)/100.', $

		'	min = min(xp(*,1)) & max = max(xp(*,1))', $
		'	dom_y(n-1,0)	= min - (max - min)/100.', $
		'	dom_y(n-1,1)	= max + (max - min)/100.', $

		'	min = min(xp(*,2)) & max = max(xp(*,2))', $
		'	dom_z(n-1,0)	= min - (max - min)/100.', $
		'	dom_z(n-1,1)	= max + (max - min)/100.', $

		'	print, n, " // ", i', $
		'endfor', $

		'sname	= "/storage5/FORNAX/VELOCI_RAPTOR/" + strtrim(cname,2) + "/galaxy/snap_" + string(i+1,format="(I3.3)") + "/domain.sav" ', $
		'save, filename=sname, dom_x, dom_y, dom_z'], $
		varnames=['cname', 'path', 'outputs'], $
		nsplit=10L


End
