PRO vr_test12_draw, settings, tree, vr_compid, n0=n0, n1=n1, vr=vr, xr=xr, yr=yr, n_pix=n_pix, eps=eps, id0=id0

IF KEYWORD_SET(vr) THEN BEGIN

	traj = dblarr(n1-n0+1,2)
	mass = dblarr(n1-n0+1,2)
	xr2	= [-100., 100.]
	yr2	= xr2
	FOR i=n0, n1 DO BEGIN

		IF KEYWORD_SET(eps) THEN cgPS_open, settings.root_path + 'test/vr_test/test12*/vr_' + $
			STRING(id0,format='(I4.4)') + '_' + $
			STRING(i - n0,format='(I3.3)') + '.eps', /encapsulated

		Dsize	= [2400., 800.]
		cgDisplay, Dsize(0), Dsize(1)
		!p.font = -1 & !p.charsize=1.5 & !p.color=255B

		;; Read Galaxies
		HGAL	= f_rdgal(settings, tree.vr.snaplist(i), settings.column_list, id=tree.vr.id(i))
		CGAL	= f_rdgal(settings, tree.vr.snaplist(i), settings.column_list, id=vr_compid(i))

		traj(i-n0,0)	= CGAL.xc(0) - HGAL.xc(0)
		traj(i-n0,1)	= CGAL.yc(0) - HGAL.yc(0)

		mass(i-n0,*)	= [HGAL.mass_tot(0), CGAL.mass_tot(0)]

		;; Raw DATA
		POS	= [0., 0., 0.33, 1.0]
		cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, xstyle=4, ystyle=4, /nodata, background='black'

		PTCL	= f_rdptcl(settings, tree.vr.id(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(i), /longint, /yzics, /raw, boxrange=xr(1))


		draw_gal, PTCL.xp, PTCL.mp, HGAL, 0L, xr=xr, yr=yr, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=0L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		cgOplot, 0., 0., psym=16, symsize=1.2, color='blue'
		cgOplot, CGAL.xc(0) - HGAL.xc(0), CGAL.yc(0) - HGAL.yc(0), psym=16, symsize=1.2, color='red'
		cgOplot, traj(0:i-n0,0), traj(0:i-n0,1), linestyle=2, color='red'

		cgText, xr(0) + (xr(1) - xr(0))*0.1, yr(0) + (yr(1) - yr(0))*0.1, $
			'a = ' + STRING(HGAL.aexp,format='(F5.3)'), /data, color='white'

		!p.charsize	= 0.5
		;; Host Galaxy
		POS	= [0.33, 0., 0.66, 1.0]
		cgPlot, 0, 0, xrange=xr2, yrange=yr2, position=pos, xstyle=4, ystyle=4, /nodata, /noerase, background='black'

		PTCL	= f_rdptcl(settings, tree.vr.id(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(i), /longint, /yzics, boxrange=xr2(1))

		draw_gal, PTCL.xp, PTCL.mp, HGAL, 0L, xr=xr2, yr=yr2, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=1L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		cgPlot, 0, 0, /noerase, xrange=[n0, n1], yrange=[1e8, 5e11], /ylog, position=[0.56, 0.81, 0.65, 0.99], background='black', $
			axiscolor='white', color='white'
		cgOplot, LINDGEN(i) + n0, mass(0L:i-n0,0), linestyle=0, thick=2, color='white'
		cgOplot, i, mass(i-n0,0), psym=16, color='red', symsize=0.7

		;; Comp Galaxy
		POS	= [0.66, 0., 0.99, 1.0]
		cgPlot, 0, 0, xrange=xr2, yrange=yr2, position=pos, xstyle=4, ystyle=4, /nodata, /noerase, background='black'

		PTCL	= f_rdptcl(settings, vr_compid(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(i), /longint, /yzics, boxrange=xr2(1))

		draw_gal, PTCL.xp, PTCL.mp, CGAL, 0L, xr=xr2, yr=yr2, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=3L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		cgPlot, 0, 0, /noerase, xrange=[n0, n1], yrange=[1e8, 5e11], /ylog, position=[0.9, 0.81, 0.99, 0.99], background='black', $
			axiscolor='white', color='white'
		cgOplot, LINDGEN(i) + n0, mass(0L:i-n0,1), linestyle=0, thick=2, color='white'
		cgOplot, i, mass(i-n0,1), psym=16, color='red', symsize=0.7

		IF KEYWORD_SET(eps) THEN cgPS_close

	ENDFOR

ENDIF

IF KEYWORD_SET(yz) THEN BEGIN
	traj = dblarr(n1-n0+1,2)
	mass = dblarr(n1-n0+1,2)
	xr2	= [-100., 100.]
	yr2	= xr2
	FOR i=n0, n1 DO BEGIN

		IF KEYWORD_SET(eps) THEN cgPS_open, settings.root_path + 'test/vr_test/test12*/yz_' + $
			STRING(id0,format='(I4.4)') + '_' + $
			STRING(i - n0,format='(I3.3)') + '.eps', /encapsulated

		Dsize	= [2400., 800.]
		cgDisplay, Dsize(0), Dsize(1)
		!p.font = -1 & !p.charsize=1.5 & !p.color=255B

		STOP
		;; Read Galaxies
		HGAL	= f_rdgal(settings, tree.vr.snaplist(i), settings.column_list, id=tree.vr.id(i))
		CGAL	= f_rdgal(settings, tree.vr.snaplist(i), settings.column_list, id=vr_compid(i))

		traj(i-n0,0)	= CGAL.xc(0) - HGAL.xc(0)
		traj(i-n0,1)	= CGAL.yc(0) - HGAL.yc(0)

		mass(i-n0,*)	= [HGAL.mass_tot(0), CGAL.mass_tot(0)]

		;; Raw DATA
		POS	= [0., 0., 0.33, 1.0]
		cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, xstyle=4, ystyle=4, /nodata, background='black'

		PTCL	= f_rdptcl(settings, tree.vr.id(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(i), /longint, /yzics, /raw, boxrange=xr(1))


		draw_gal, PTCL.xp, PTCL.mp, HGAL, 0L, xr=xr, yr=yr, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=0L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		cgOplot, 0., 0., psym=16, symsize=1.2, color='blue'
		cgOplot, CGAL.xc(0) - HGAL.xc(0), CGAL.yc(0) - HGAL.yc(0), psym=16, symsize=1.2, color='red'
		cgOplot, traj(0:i-n0,0), traj(0:i-n0,1), linestyle=2, color='red'

		cgText, xr(0) + (xr(1) - xr(0))*0.1, yr(0) + (yr(1) - yr(0))*0.1, $
			'a = ' + STRING(HGAL.aexp,format='(F5.3)'), /data, color='white'

		!p.charsize	= 0.5
		;; Host Galaxy
		POS	= [0.33, 0., 0.66, 1.0]
		cgPlot, 0, 0, xrange=xr2, yrange=yr2, position=pos, xstyle=4, ystyle=4, /nodata, /noerase, background='black'

		PTCL	= f_rdptcl(settings, tree.vr.id(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(i), /longint, /yzics, boxrange=xr2(1))

		draw_gal, PTCL.xp, PTCL.mp, HGAL, 0L, xr=xr2, yr=yr2, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=1L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		cgPlot, 0, 0, /noerase, xrange=[n0, n1], yrange=[1e8, 5e11], /ylog, position=[0.56, 0.81, 0.65, 0.99], background='black', $
			axiscolor='white', color='white'
		cgOplot, [n0, i], mass(0L:i-n0,0), linestyle=0, thick=2, color='white'
		cgOplot, i, mass(i-n0,0), psym=16, color='red', symsize=0.7

		;; Comp Galaxy
		POS	= [0.66, 0., 0.99, 1.0]
		cgPlot, 0, 0, xrange=xr2, yrange=yr2, position=pos, xstyle=4, ystyle=4, /nodata, /noerase, background='black'

		PTCL	= f_rdptcl(settings, vr_compid(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(i), /longint, /yzics, boxrange=xr2(1))

		draw_gal, PTCL.xp, PTCL.mp, CGAL, 0L, xr=xr2, yr=yr2, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=3L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		cgPlot, 0, 0, /noerase, xrange=[n0, n1], yrange=[1e8, 5e11], /ylog, position=[0.9, 0.81, 0.99, 0.99], background='black', $
			axiscolor='white', color='white'
		cgOplot, [n0, i], mass(0L:i-n0,1), linestyle=0, thick=2, color='white'
		cgOplot, i, mass(i-n0,1), psym=16, color='red', symsize=0.7

		IF KEYWORD_SET(eps) THEN cgPS_close

	ENDFOR

ENDIF
END
