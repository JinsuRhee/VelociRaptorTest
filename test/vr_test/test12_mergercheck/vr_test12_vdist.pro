PRO vr_test12_vdist, settings, id0, n0, n1, vr_compid, tree, cftnum, eps=eps

	snapnum	= 95L
	test1 = 0L
	test2 = 0L

	img_disp = 0L

	IF cftnum EQ 0L THEN BEGIN
		HGAL	= f_rdgal(settings, tree.vr.snaplist(snapnum), settings.column_list, id=tree.vr.id(snapnum))
		CGAL	= f_rdgal(settings, tree.vr.snaplist(snapnum), settings.column_list, id=vr_compid(snapnum))

		HPTCL	= f_rdptcl(settings, tree.vr.id(snapnum), /p_pos, /p_vel, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(snapnum), /longint, /yzics)
		CPTCL	= f_rdptcl(settings, vr_compid(snapnum), /p_pos, /p_vel, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(snapnum), /longint, /yzics)

		cut	= WHERE($
			SQRT((HPTCL.xp(*,0) - CGAL.xc(0))^2 + (HPTCL.xp(*,1) - CGAL.yc(0))^2 + $
			(HPTCL.xp(*,2) - CGAL.zc(0))^2) LT 5.0 * CGAL.r_halfmass(0)); $; AND $
			;AND HPTCL.vp(*,2) - CGAL.vzc(0) LT 100.)
	ENDIF


	IF test1 EQ 1L THEN BEGIN
		;;-----
		;; TEST
		;;-----
		REFGAL	= f_rdgal(settings, tree.vr.snaplist(snapnum), settings.column_list, id=tree.vr.id(snapnum))
		xr = [-500., 500.] & yr = xr & n_pix = 1000L
		Dsize	= [1000., 1000.]
		cgDisplay, Dsize(0), Dsize(1)
		!p.font = -1 & !p.charsize = 1.5 & !p.color = 255B

		POS	= [0., 0., 1., 1.]
		cgPlot, 0, 0, xrange=xr, yrange=yr, position=POS, xstyle=4, ystyle=4, /nodata, background='black'

		PTCL	= f_rdptcl(settings, tree.vr.id(snapnum), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(snapnum), /longint, /yzics, /raw, boxrange=xr(1))

		draw_gal, PTCL.xp, PTCL.mp, REFGAL, 0L, xr=xr, yr=yr, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=0L, /logscale, $
			position=POS, kernel=1L, drange=[2.0, 10.0]

		cgOplot, HGAL.xc(0) - REFGAL.xc(0), HGAL.yc(0) - REFGAL.yc(0), psym=16, symsize=0.8, color='red'
		cgOplot, CGAL.xc(0) - REFGAL.xc(0), CGAL.yc(0) - REFGAL.yc(0), psym=16, symsize=0.8, color='blue'

	ENDIF

	IF test2 EQ 1L THEN BEGIN
		xr = [-50., 50.] & yr = xr & n_pix = 1000L
		Dsize	= [1000., 1000.]
		cgDisplay, Dsize(0), Dsize(1)
		!p.font = -1 & !p.charsize = 1.5 & !p.color = 255B
		POS	= [0., 0., 1., 1.]
		cgPlot, 0, 0, xrange=xr, yrange=yr, position=POS, xstyle=4, ystyle=4, /nodata, background='black'

		HPTCL.mp(cut)	= HPTCL.mp(cut) * 0.
		draw_gal, HPTCL.xp, HPTCL.mp, HGAL, 0L, xr=xr, yr=yr, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=1L, /logscale, $
			position=POS, kernel=1L, drange=[2.0, 10.0]

		STOP
	ENDIF

	xr	= [-500., 500.]
	;;-----
	;; Extract Data
	;;-----
	vx	= HISTOGRAM(CPTCL.vp(*,0) - CGAL.vxc(0), min=xr(0), max=xr(1), binsize=10., location=xx)
	vy	= HISTOGRAM(CPTCL.vp(*,1) - CGAL.vyc(0), min=xr(0), max=xr(1), binsize=10., location=yy)
	vz	= HISTOGRAM(CPTCL.vp(*,2) - CGAL.vzc(0), min=xr(0), max=xr(1), binsize=10., location=zz)
	vx	= vx*1.0 / TOTAL(vx)
	vy	= vy*1.0 / TOTAL(vy)
	vz	= vz*1.0 / TOTAL(vz)
	vdata	= {vx:vx, vy:vy, vz:vz, xx:xx, yy:yy, zz:zz}
	
	vx2	= HISTOGRAM(HPTCL.vp(cut,0) - CGAL.vxc(0), min=xr(0), max=xr(1), binsize=10., location=xx2)
	vy2	= HISTOGRAM(HPTCL.vp(cut,1) - CGAL.vyc(0), min=xr(0), max=xr(1), binsize=10., location=yy2)
	vz2	= HISTOGRAM(HPTCL.vp(cut,2) - CGAL.vzc(0), min=xr(0), max=xr(1), binsize=10., location=zz2)
	vx2	= vx2*1.0 / TOTAL(vx2)
	vy2	= vy2*1.0 / TOTAL(vy2)
	vz2	= vz2*1.0 / TOTAL(vz2)
	vdata2	= {vx:vx2, vy:vy2, vz:vz2, xx:xx2, yy:yy2, zz:zz2}

	IF KEYWORD_SET(eps) THEN cgPS_open, settings.root_path + 'test/vr_test/test12*/vdist_' + STRING(id0,format='(I4.4)') + '.eps', $
		/encapsulated

	Dsize	= [1500., 500.]
	cgDisplay, Dsize(0), Dsize(1)

	!p.charsize = 1.0 & !p.font = -1 & !p.color=255B
	POS	= [0.05, 0.15, 0.33, 0.99]
	cgPlot, vdata.xx, vdata.vx, linestyle=0, /noerase, xr=xr, yr=yr, background='black', position=POS
	cgOplot, vdata2.xx, vdata2.vx, linestyle=2, thick=3, color='red'

	POS	= [0.38, 0.15, 0.66, 0.99]
	cgPlot, vdata.yy, vdata.vy, linestyle=0, /noerase, xr=xr, yr=yr, background='black', position=POS
	cgOplot, vdata2.yy, vdata2.vy, linestyle=2, thick=3, color='red'
	

	POS	= [0.71, 0.15, 0.99, 0.99]
	cgPlot, vdata.zz, vdata.vz, linestyle=0, /noerase, xr=xr, yr=yr, background='black', position=POS
	cgOplot, vdata2.zz, vdata2.vz, linestyle=2, thick=3, color='red'

	IF KEYWORD_SET(eps) THEN cgPS_close

	;;;;; Density Image
	xr3	= [-20., 20.]
	IF KEYWORD_SET(eps) THEN cgPS_open, settings.root_path + 'test/vr_test/test12*/pmap_' + STRING(id0,format='(I4.4)') + '.eps', $
		/encapsulated

	Dsize	= [1500., 500.]
	cgDisplay, Dsize(0), Dsize(1)

	xp	= HPTCL.xp(cut,*)
	vp	= HPTCL.vp(cut,*)
	mp	= HPTCL.mp(cut)
	xp(*,0)	= xp(*,0) - CGAL.xc(0)
	xp(*,1)	= xp(*,1) - CGAL.yc(0)
	xp(*,2)	= xp(*,2) - CGAL.zc(0)

	cut_p	= WHERE(vp(*,2) - CGAL.vzc(0) GT 100.)
	cut_n	= WHERE(vp(*,2) - CGAL.vzc(0) LT -100.)
	!p.charsize = 1.0 & !p.font = -1 & !p.color=255B
	POS	= [0.00, 0.00, 0.33, 0.99]
	cgPlot, 0, 0, /nodata, xrange=xr3, yrange=xr3, xstyle=4, ystyle=4, background='black', position=pos

	draw_gal, HPTCL.xp(cut,*), HPTCL.mp(cut), CGAL, 0L, xr=xr3, yr=xr3, proj='noproj', n_pix=n_pix, $
		num_thread=settings.num_thread, maxis=[0L, 1L], ctable=0L, /logscale, $
		position=pos, kernel=1L, drange=[2.0, 5.0]
	density	= js_kde(xx=xp(cut_p,0), yy=xp(cut_p,1), xrange=xr3, yrange=xr3, n_pix=n_pix, $
		mode=-1, kernel=1L)
		density.z(WHERE(density.z LT 0.)) = 0.
		density.z	= density.z / TOTAL(density.z)
		sig2val = -1.0 & sig1val = -1.0
		FOR i=0L, 999L DO BEGIN
			val	= MAX(density.z)/1000. * (i+0.0d)
			tmp	= WHERE(density.z GE val)
			prob	= TOTAL(density.z(tmp))
			;IF prob LE 0.9545 AND sig2val LT 0. THEN sig2val = val
			IF prob LE 0.6826 AND sig1val LT 0. THEN sig1val = val
		ENDFOR
	cgContour, density.z, level=[sig1val], /onimage, color='red'

	density	= js_kde(xx=xp(cut_n,0), yy=xp(cut_n,1), xrange=xr3, yrange=xr3, n_pix=n_pix, $
		mode=-1, kernel=1L)
		density.z(WHERE(density.z LT 0.)) = 0.
		density.z	= density.z / TOTAL(density.z)
		sig2val = -1.0 & sig1val = -1.0
		FOR i=0L, 999L DO BEGIN
			val	= MAX(density.z)/1000. * (i+0.0d)
			tmp	= WHERE(density.z GE val)
			prob	= TOTAL(density.z(tmp))
			;IF prob LE 0.9545 AND sig2val LT 0. THEN sig2val = val
			IF prob LE 0.6826 AND sig1val LT 0. THEN sig1val = val
		ENDFOR
	cgContour, density.z, level=[sig1val], /onimage, color='blue'

	POS	= [0.33, 0.00, 0.66, 0.99]
	cgPlot, 0, 0, /nodata, xrange=xr3, yrange=xr3, xstyle=4, ystyle=4, background='black', /noerase, position=POS

	draw_gal, HPTCL.xp(cut,*), HPTCL.mp(cut), CGAL, 0L, xr=xr3, yr=xr3, proj='noproj', n_pix=n_pix, $
		num_thread=settings.num_thread, maxis=[0L, 2L], ctable=0L, /logscale, $
		position=pos, kernel=1L, drange=[2.0, 5.0]

	density	= js_kde(xx=xp(cut_p,0), yy=xp(cut_p,2), xrange=xr3, yrange=xr3, n_pix=n_pix, $
		mode=-1, kernel=1L)
		density.z(WHERE(density.z LT 0.)) = 0.
		density.z	= density.z / TOTAL(density.z)
		sig2val = -1.0 & sig1val = -1.0
		FOR i=0L, 999L DO BEGIN
			val	= MAX(density.z)/1000. * (i+0.0d)
			tmp	= WHERE(density.z GE val)
			prob	= TOTAL(density.z(tmp))
			;IF prob LE 0.9545 AND sig2val LT 0. THEN sig2val = val
			IF prob LE 0.6826 AND sig1val LT 0. THEN sig1val = val
		ENDFOR
	cgContour, density.z, level=[sig1val], /onimage, color='red'

	density	= js_kde(xx=xp(cut_n,0), yy=xp(cut_n,2), xrange=xr3, yrange=xr3, n_pix=n_pix, $
		mode=-1, kernel=1L)
		density.z(WHERE(density.z LT 0.)) = 0.
		density.z	= density.z / TOTAL(density.z)
		sig2val = -1.0 & sig1val = -1.0
		FOR i=0L, 999L DO BEGIN
			val	= MAX(density.z)/1000. * (i+0.0d)
			tmp	= WHERE(density.z GE val)
			prob	= TOTAL(density.z(tmp))
			;IF prob LE 0.9545 AND sig2val LT 0. THEN sig2val = val
			IF prob LE 0.6826 AND sig1val LT 0. THEN sig1val = val
		ENDFOR
	cgContour, density.z, level=[sig1val], /onimage, color='blue'


	POS	= [0.66, 0.00, 0.99, 0.99]
	cgPlot, 0, 0, /nodata, xrange=xr3, yrange=xr3, xstyle=4, ystyle=4, background='black', /noerase, position=POS

	draw_gal, HPTCL.xp(cut,*), HPTCL.mp(cut), CGAL, 0L, xr=xr3, yr=xr3, proj='noproj', n_pix=n_pix, $
		num_thread=settings.num_thread, maxis=[1L, 2L], ctable=0L, /logscale, $
		position=pos, kernel=1L, drange=[2.0, 5.0]

	density	= js_kde(xx=xp(cut_p,1), yy=xp(cut_p,2), xrange=xr3, yrange=xr3, n_pix=n_pix, $
		mode=-1, kernel=1L)
		density.z(WHERE(density.z LT 0.)) = 0.
		density.z	= density.z / TOTAL(density.z)
		sig2val = -1.0 & sig1val = -1.0
		FOR i=0L, 999L DO BEGIN
			val	= MAX(density.z)/1000. * (i+0.0d)
			tmp	= WHERE(density.z GE val)
			prob	= TOTAL(density.z(tmp))
			;IF prob LE 0.9545 AND sig2val LT 0. THEN sig2val = val
			IF prob LE 0.6826 AND sig1val LT 0. THEN sig1val = val
		ENDFOR
	cgContour, density.z, level=[sig1val], /onimage, color='red'

	density	= js_kde(xx=xp(cut_n,1), yy=xp(cut_n,2), xrange=xr3, yrange=xr3, n_pix=n_pix, $
		mode=-1, kernel=1L)
		density.z(WHERE(density.z LT 0.)) = 0.
		density.z	= density.z / TOTAL(density.z)
		sig2val = -1.0 & sig1val = -1.0
		FOR i=0L, 999L DO BEGIN
			val	= MAX(density.z)/1000. * (i+0.0d)
			tmp	= WHERE(density.z GE val)
			prob	= TOTAL(density.z(tmp))
			;IF prob LE 0.9545 AND sig2val LT 0. THEN sig2val = val
			IF prob LE 0.6826 AND sig1val LT 0. THEN sig1val = val
		ENDFOR
	cgContour, density.z, level=[sig1val], /onimage, color='blue'
	IF KEYWORD_SET(eps) THEN cgPS_close
	STOP

END
