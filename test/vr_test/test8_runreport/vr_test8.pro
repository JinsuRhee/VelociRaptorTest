PRO vr_test8, settings

	vr_test8_rd_c07887, settings, rp_c07887, /skip
	vr_test8_rd_c10006, settings, rp_c10006, /skip
	vr_test8_rd_l10006, settings, rp_l10006, /skip
	vr_test8_rd_c39990, settings, rp_c39990, /skip
	vr_test8_rd_NH, settings, rp_NH

	;cgPS_open, settings.root_path + 'test/vr_test/test8*/report.eps', /encapsulated
	dsize   = [800., 800.]
	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=1.5 & !p.color=255B
	xrange	= [1e2, 1e10] & yrange=[1e2, 1e7]
	cgPlot, 0, 0, /nodata, /xlog, /ylog, xrange=xrange, yrange=yrange, $
		xtitle='# of PTCLs', ytitle='Times [s]', $
		position=[0.15, 0.15, 0.95, 0.95]

	cgOplot, rp_c07887(*,1), rp_c07887(*,0), psym=9, symsize=1.2, color='blue'
	cgOplot, rp_c10006(*,1), rp_c10006(*,0), psym=9, symsize=1.2, color='red'

	cgOplot, rp_l10006(*,1), rp_l10006(*,0), psym=16, symsize=1.0, color='red'
	cgOplot, rp_c39990(*,1), rp_c39990(*,0), psym=16, symsize=1.0, color='green'

	cgOplot, rp_NH(*,1), rp_NH(*,0), psym=16, symsize=1.0, color='black'

	cgOplot, [1e2, 1e10], [86400., 86400.], linestyle=2, thick=3
	cgText, 1e3, 1e5, '1 Day', /data, alignment=0
	cgOplot, [1e2, 1e10], [86400., 86400.]*7., linestyle=2, thick=3
	cgText, 1e3, 7e5, '1 Week', /data, alignment=0
	cgOplot, [1e2, 1e10], [86400., 86400.]*30., linestyle=2, thick=3
	cgText, 1e3, 3e6, '1 Month', /data, alignment=0

	cgLegend, Titles=['c07887', 'c10006', 'l10006', 'c39990'], location=[1e3, 7e4], alignment=0, /data, $
		length=0.0, vspace=2.5, symsize=1.5, psyms=[9, 9, 16, 16], /box, symcolors=['blue', 'red', 'red', 'green']
	;cgPS_close
	STOP

END
