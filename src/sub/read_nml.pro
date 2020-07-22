Pro read_nml, settings, file=file

	settings = {dum:'dum'}
	
	openr, 10, file
	for i=0L, file_lines(file)-1L do begin
		v1	= string(' ')
		readf, 10, v1
		v1	= strtrim(v1,2)
		if strlen(v1) eq 0L then continue

		in	= strpos(v1, '#')
		if max(in) ge 0L then continue

		void	= execute(v1)	; define a variable

		tag_name= strsplit(v1, '=', /extract)
		tag_name= tag_name(0)
		v2	= 'settings = create_struct(settings,"' + strtrim(tag_name,2) + '",' + $
			strtrim(tag_name,2) + ')'
		void	= execute(v2)
	endfor
	close, 10

End
