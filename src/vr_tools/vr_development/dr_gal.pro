Pro dr_gal 

	;;-----
	;; Data
	;;-----

	n_snap	= 70L
	cname	= 'c10006'
	path_data	= '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2)+ '/galaxy/'
	raw_data_path	= '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	lib_path	= '/storage5/jinsu/idl_lib/lib/vraptor/'

	skip:
	restore, 'load_gal.sav'

	ww	= ['mass', 'u', 'r']
	cut	= where(gal.mvir gt 1e9)
	for i=0L, n_elements(cut) - 1L do begin
		ind	= cut(i)
		xr	= [-gal.r_halfmass(ind), gal.r_halfmass(ind)]*1.5;[-0.75, 0.75]
		yr	= xr
		n_pix	= 1000L
		ctable	= 1

		for j=0L, 2L do begin
			cgPS_open, filename=string(i,format='(I2.2)') + '_' + strtrim(ww(j),2) + '.eps', /encapsulated
			cgDisplay, 1000, 500
			weight	= ww(j)
			pos	= [0.08, 0.13, 0.48, 0.93]
			!p.color = 255B & !p.font = -1 & !p.charsize=1.0
			cgPlot, 0, 0, psym=16, xrange=xr, yrange=yr, symsize=0.5, /nodata, position=pos, $
				xstyle=4, ystyle=4, background='black', axiscolor='white'

			draw_gal, gal, id=ind, proj='edgeon', weight=weight, n_pix=n_pix, $
				xr=xr, yr=yr, symsize=0.15, ctable=ctable, /logscale

			!p.charsize=2.0
			cgText, xr(0) + (xr(1) - xr(0))*0.1, yr(0) + (yr(1) - yr(0))*0.9, 'log M = ' + string(alog10(gal.mvir(ind)),format='(F6.3)'), color='white', /data
			!p.charsize=1.0

			cgAxis, xaxis=0, xstyle=1, xrange=xr, xtitle='X [kpc]', xticks=4, color='white', /save
			cgAxis, xaxis=1, xstyle=1, xrange=xr, color='white', xticks=4, xtickn=replicate(' ',5), /save
			cgAxis, yaxis=0, ystyle=1, xrange=yr, color='white', yticks=4, ytitle='Y [kpc]', /save
			cgAxis, yaxis=1, ystyle=1, xrange=yr, color='white', yticks=4, ytickn=replicate(' ', 5), /save

			pos	= pos + [0.5, 0., 0.5, 0.]
			cgPlot, 0, 0, xrange=xr, yrange=yr, /nodata, /noerase, position=pos, $
				xstyle=4, ystyle=4, background='black'
			draw_gal, gal, id=ind, proj='faceon', weight=weight, n_pix=n_pix, $
				xr=xr, yr=yr, symsize=0.15, ctable=ctable, /logscale

			cgAxis, xaxis=0, xstyle=1, xrange=xr, xtitle='X [kpc]', xticks=4, color='white', /save
			cgAxis, xaxis=1, xstyle=1, xrange=xr, color='white', xticks=4, xtickn=replicate(' ',5), /save
			cgAxis, yaxis=0, ystyle=1, xrange=yr, color='white', yticks=4, ytitle='Y [kpc]', /save
			cgAxis, yaxis=1, ystyle=1, xrange=yr, color='white', yticks=4, ytickn=replicate(' ', 5), /save

			cgPS_close
		endfor
	endfor
		stop
End
