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

	IF settings.simname EQ 'YZiCS2' THEN BEGIN
		dir_catalog = '/storage5/FORNAX/VELOCI_RAPTOR/' + STRTRIM(settings.cname,2) + '/galaxy/'
		dir_raw	= '/storage5/FORNAX/KISTI_OUTPUT/' + STRTRIM(settings.cname,2) + '/snapshots/'
		dir_save= '/storage5/FORNAX/KISTI_OUTPUT/' + STRTRIM(settings.cname,2) + '/'
	ENDIF

	IF settings.simname EQ 'NH' THEN BEGIN
		;dir_catalog     = '/storage5/FORNAX/VELOCI_RAPTOR/' + STRTRIM(settings.cname,2) + '/galaxy/'
		dir_catalog	= '/storage6/jinsu/NH/galaxy/'
		dir_raw         = '/storage1/NewHorizon/snapshots/'
		dir_save        = '/storage1/NewHorizon/Vraptor/'
	ENDIF

	IF settings.simname EQ 'YZiCS' THEN BEGIN
		dir_catalog    = '/storage5/FORNAX/VELOCI_RAPTOR/YZiCS/c' + STRTRIM(settings.cname,2) + '/galaxy/'
		dir_raw	= '/storage3/Clusters/' + STRTRIM(settings.cname,2) + '/snapshots/'
		dir_save= '/storage3/Clusters/Vraptor/c' + STRTRIM(settings.cname,2) + '/'
	ENDIF

	settings	= create_struct(settings, 'dir_catalog', dir_catalog, $
		'dir_raw', dir_raw, 'dir_save', dir_save)
End
