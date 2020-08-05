FUNCTION vr_test4_rdlog, settings, numdom=numdom, save=save

IF ~keyword_set(save) THEN BEGIN
	file	= settings.root_path + 'test/vr_test/test4*/logfile.log'
	openr, 10, file
	nn	= file_lines(file)

	index	= lonarr(8)
	FOR i=0L, nn-1L DO BEGIN
		dum	= ' '
		readf, 10, dum
		dum	= strsplit(dum, '-', /extract)
		dum	= dum(1)

		dum	= strsplit(dum, '/', /extract)

		numomp	= long(dum(0))
		void	= execute('time' + strtrim(numomp,2) + '= js_makearr(' + $
			'time' + strtrim(numomp,2) + ', ' + strtrim(index(numomp),2) + $
			', ' + strtrim(dum(1),2) + ', 100L, "D" )')

		void	= execute('X' + strtrim(numomp,2) + '= js_makearr(' + $
			'X' + strtrim(numomp,2) + ', ' + strtrim(index(numomp),2) + $
			', ' + strtrim(dum(3),2) + ', 100L, "D" )')

		void	= execute('Y' + strtrim(numomp,2) + '= js_makearr(' + $
			'Y' + strtrim(numomp,2) + ', ' + strtrim(index(numomp),2) + $
			', ' + strtrim(dum(4),2) + ', 100L, "D" )')

		void	= execute('Z' + strtrim(numomp,2) + '= js_makearr(' + $
			'Z' + strtrim(numomp,2) + ', ' + strtrim(index(numomp),2) + $
			', ' + strtrim(dum(5),2) + ', 100L, "D" )')
		index(numomp) ++
	ENDFOR

	FOR i=0L, 7L DO void = execute('time' + strtrim(i,2) + ' = time' + $
		strtrim(i,2) + '(0L:' + strtrim(index(i) - 1L,2) + ')')
	FOR i=0L, 7L DO void = execute('X' + strtrim(i,2) + ' = X' + $
		strtrim(i,2) + '(0L:' + strtrim(index(i) - 1L,2) + ')')
	FOR i=0L, 7L DO void = execute('Y' + strtrim(i,2) + ' = Y' + $
		strtrim(i,2) + '(0L:' + strtrim(index(i) - 1L,2) + ')')
	FOR i=0L, 7L DO void = execute('Z' + strtrim(i,2) + ' = Z' + $
		strtrim(i,2) + '(0L:' + strtrim(index(i) - 1L,2) + ')')

	FOR i=0L, 7L DO BEGIN
		void	= execute('list' + strtrim(i,2) + ' = create_struct' + $
			'("t", time' + strtrim(i,2) + ', ' + $
			'"X", X' + strtrim(i,2) + ', ' + $
			'"Y", Y' + strtrim(i,2) + ', ' + $
			'"Z", Z' + strtrim(i,2) + ')')
	ENDFOR

	list	= create_struct('l0', list0, 'l1', list1, $
		'l2', list2, 'l3', list3, 'l4', list4, $
		'l5', list5, 'l6', list6, 'l7', list7)

	close, 10
	save, filename=settings.root_path + 'test/vr_test/test4*/log.sav', list
ENDIF ELSE BEGIN

	restore, settings.root_path + 'test/vr_test/test4*/log.sav'
ENDELSE

runtime	= dblarr(8)
	runtime(5)	= 2268.
	runtime(3)	= 3479.97
	runtime(0)	= 4329.03
	runtime(7)	= 4677.78
	runtime(1)	= 6825.44
	runtime(6)	= 7853.25
	runtime(2)	= 10414.28
	runtime(4)	= 11478.03
runtime	= alog10(runtime)

time	= list.(numdom).t
time	= alog10(time)
yy	= histogram(time, min=1., max=5., binsize=1., location=xx)
xx	= xx - 0.5
cgPlot, xx, yy, psym=10, thick=2
cgOplot, [runtime(numdom), runtime(numdom)], [0., max(yy)], linestyle=2, thick=2

stop
return, list

END
