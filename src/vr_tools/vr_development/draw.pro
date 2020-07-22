Pro draw

	dcolumn= ['ID', 'ID_mbp', 'Mvir', 'Rvir', 'Xc', 'Yc', 'Zc', 'VXc', 'VYc', 'VZc', $
		'Lx', 'Ly', 'Lz', 'sigV', 'npart']

	;;-----
	;; Data
	;;-----

	n_snap	= 87
	cname	= 'c10006'
	path_data	= '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2)+ '/galaxy/'
	raw_data_path	= '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/'
	lib_path	= '/storage5/jinsu/idl_lib/lib/vraptor/'
	flux_list	= ['u', 'g', 'r', 'i', 'z', 'FUV', 'NUV', 'IR_F105W', 'IR_F125W', 'IR_F160W']

	;;-----
	;; Load
	;;-----
	tic
	gal	= read_vraptor(path_data, data_list=dcolumn, horg='g', /silent, /particle, n_snap=n_snap, raw_data=raw_data_path, flux_list=flux_list, lib_path=lib_path)

	toc, /verbose

	;;-----
	;; Most Massive Galaxy
	;;-----

	ind	= where(gal.mvir eq max(gal.mvir))
	xc = gal.xc(ind) & yc = gal.yc(ind) & zc = gal.zc(ind) & rr = gal.rvir(ind)
	dom_list	= gal.dom_list(where(gal.gal_list eq ind))

	bdn_ind	= [gal.b_ind(ind,0), gal.b_ind(ind,1)]
	ubd_ind	= [gal.u_ind(ind,0), gal.u_ind(ind,1)]

	id_b	= gal.p_id(bdn_ind(0):bdn_ind(1))
	p_b	= gal.p_pos(bdn_ind(0):bdn_ind(1),*)
	uf_b	= gal.p_u(bdn_ind(0):bdn_ind(1))
	gf_b	= gal.p_g(bdn_ind(0):bdn_ind(1))
	rf_b	= gal.p_r(bdn_ind(0):bdn_ind(1))
	mp_b	= gal.p_mass(bdn_ind(0):bdn_ind(1))

	id_u	= gal.p_id(ubd_ind(0):ubd_ind(1))
	p_u	= gal.p_pos(ubd_ind(0):ubd_ind(1),*)
	uf_u	= gal.p_u(ubd_ind(0):ubd_ind(1))
	gf_u	= gal.p_g(ubd_ind(0):ubd_ind(1))
	rf_u	= gal.p_r(ubd_ind(0):ubd_ind(1))
	mp_u	= gal.p_mass(ubd_ind(0):ubd_ind(1))

	lvec	= [gal.lx(ind), gal.ly(ind), gal.lz(ind)]
	print, gal.mvir(ind)/1e8
	;print, xc, yc, zc, rr

	mbpid	= gal.id_mbp(ind)
	cut	= where(id_b eq mbpid)
	xc	= p_b(cut,0)
	yc	= p_b(cut,1)
	zc	= p_b(cut,2)

	p_b(*,0) = p_b(*,0) - mean(xc)
	p_b(*,1) = p_b(*,1) - mean(yc)
	p_b(*,2) = p_b(*,2) - mean(zc)
	p_u(*,0) = p_u(*,0) - mean(xc)
	p_u(*,1) = p_u(*,1) - mean(yc)
	p_u(*,2) = p_u(*,2) - mean(zc)

	js_stat, p_b(*,0)

	xr = [-0.15, 0.15]
	yr = [-0.15, 0.15]
	;; Draw
	cgDisplay, 1000, 500
	pos	= [0.05, 0.08, 0.5, 0.98]
	!p.color = 255B & !p.font = -1 & !p.charsize=1.0
	cgPlot, 0, 0, psym=16, xrange=xr, yrange=yr, symsize=0.5, /nodata, position=pos, $
		axiscolor='white', xtitle='X [kpc]', ytitle='Y [kpc]', background='black'

	draw_gal, pos=[p_b,p_u], mass=[mp_b,mp_u], flux=[uf_b,uf_u], rot_axis=lvec, proj='edgeon', weight='flux', n_pix=2000L, $
		xr=xr, yr=yr, symsize=0.2, ctable=3

	pos	= pos + [0.49, 0., 0.49, 0.]
	cgPlot, 0, 0, xrange=xr, yrange=yr, /nodata, position=pos, $
		axiscolor='white', xtitle='X [kpc]', background='black', /noerase

;	draw_gas, $
;		center=[xc, yc, zc], xr=xr, yr=yr, height=xr, $
;		n_snap=n_snap, cname='c07887'
	stop

	;; Pos - kpc
	;; Vel - km/s
	;; age - Gyr
	;; sf - scale factor
	;; met - metallicity
	;; mp - solar mass
	;; Flux - Chabrier IMF // Sloand Band u g r i z //
End
