PRO vr_test11_drawgal, settings, ID=id, skip=skip, n_start=n_start, n_final=n_final, $
	eps=eps, xr=xr, yr=yr, weight=weight, proj=proj, n_pix=n_pix, drange=drange

IF ~KEYWORD_SET(skip) THEN BEGIN

	;;-----
	;; Save Tree First
	;;----
	id0	= id
		flist	= '/storage1/NewHorizon/Vraptor/VR_Galaxy/snap_*'
		flist	= FILE_SEARCH(flist)

	tree_list	= LONARR(N_ELEMENTS(flist)) - 1L
	p_pos		= DBLARR(N_ELEMENTS(flist), 3) - 1.0d
	p_mass		= DBLARR(N_ELEMENTS(flist)) - 1.0d
	FOR i=N_ELEMENTS(flist)-1L, 0L, - 1L DO BEGIN
		dum	= STRSPLIT(flist(i), '/', /extract)
		dum	= dum(-1)
		dum	= STRMID(dum,5L, 3L)
		GAL	= f_rdgal(settings, LONG(dum), [settings.column_list], id=id)
		ind	= i
		p_pos(ind,0)	= GAL.xc(0)
		p_pos(ind,1)	= GAL.yc(0)
		p_pos(ind,2)	= GAL.zc(0)
		p_mass(ind)	= GAL.mass_tot(0)
		tree_list(ind)	= id;GAL.progs(0)
		id		= GAL.progs(0)
		PRINT, i, ' / ', id
		IF id LT 0L THEN BREAK
	ENDFOR

	id	= tree_list(-1)
	FOR i=118L, 0L, - 1L DO BEGIN
	;FOR i=N_ELEMENTS(flist)-1L, 0L, - 1L DO BEGIN
		dum     = STRSPLIT(flist(i), '/', /extract)
		dum     = dum(-1)
		dum     = STRMID(dum,5L, 3L)
		snum	= LONG(dum)
		id	= tree_list(i)
		IF id LT 0L THEN BREAK

		GAL	= f_rdgal(settings, snum, [settings.column_list, 'ABmag', 'SFR'], id=id)
		;GOTO, skip
		PTCL	= f_rdptcl(settings, id, /p_pos, /p_mass, /p_gyr, $
			num_thread=settings.num_thread, n_snap=snum, /longint, /yzics, /raw, boxrange=xr(1))

		IF KEYWORD_SET(eps) THEN $
			cgPS_open, settings.root_path + 'test/vr_test/test11*/GAL_' + $
			STRING(id0,format='(I5.5)') + '_' + STRING(i,format='(I3.3)') + '.eps', /encapsulated

		DSize	= [900., 600.]
		cgDisplay, DSize(0), DSize(1)
		!p.font = -1 & !p.charsize=1.5 & !p.color=255B
		xr	= xr
		yr	= yr
		POS	= [0., 0., 0.66, 1.]
		cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, $
			xstyle=4, ystyle=4, /nodata, background='black'

		IF weight EQ 'u' THEN zz = PTCL.F_U
		IF weight EQ 'g' THEN zz = PTCL.F_G
		IF weight EQ 'mass' THEN zz = PTCL.mp

		draw_gal, PTCL.xp, zz, GAL, 0L, xr=xr, yr=yr, proj=proj, n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=0L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		angle	= findgen(100)/99.*!pi*2.

		GAL2	= f_rdgal(settings, snum, [settings.column_list])

			cut	= WHERE(GAL2.structuretype EQ 10L AND GAL2.mass_tot GT 1e10)
			GAL2	= {xc:GAL2.xc(cut), yc:GAL2.yc(cut), zc:GAL2.zc(cut), $
				r_halfmass:GAL2.r_halfmass(cut)}

		bdn	= dblarr(2,3)
			bdn(*,0)	= xr + GAL.XC(0)
			bdn(*,1)	= yr + GAL.YC(0)
			bdn(*,2)	= xr + GAL.ZC(0)
		cut	= js_bound([[GAL2.xc], [GAL2.yc], [GAL2.zc]], bdn, n_dim=3L)

		IF N_ELEMENTS(cut) GE 2L THEN BEGIN
			FOR j=0L, N_ELEMENTS(cut)-1L DO BEGIN
				cgOplot, (GAL2.XC(cut(j)) - GAL.xc(0))+ GAL2.r_halfmass(cut(j)) * cos(angle), $
					(GAL2.YC(cut(j)) - GAL.yc(0))+ GAL2.r_halfmass(cut(j)) * sin(angle), $
					linestyle=2, thick=2, color='white'
			ENDFOR
		ENDIF

		cgOplot, GAL.r_halfmass(0) * cos(angle), $
			GAL.r_halfmass(0) * sin(angle), linestyle=0, thick=4, color='red'

		cgOplot, GAL.xc(0), GAL.yc(0), psym=16, color='red', symsize=1.0

		cgText, xr(0) + (xr(1) - xr(0))*0.1, yr(0) + (yr(1) - yr(0))*0.1, $
			'a = ' + STRING(GAL.aexp,format='(F5.3)'), /data, color='white'

		!p.charsize=0.8
		;;-----
		;; Position
		;;-----
		position	= [0.78, 0.6, 0.98, 0.9]
		cgPlot, p_pos(*,0)/1e3, p_pos(*,1)/1e3, linestyle=0, thick=2, xtitle='X [Mpc]', ytitle='Y [Mpc]', /noerase, position=position, axiscolor='white', color='white', xticks=3, yticks=3
		cgOplot, p_pos(i,0)/1e3, p_pos(i,1)/1e3, psym=16, symsize=1.0, color='red'

		;;-----
		;; Mass
		;;-----
		position	= [0.78, 0.1, 0.98, 0.4]
		cgPlot, LINDGEN(N_ELEMENTS(flist)), p_mass, linestyle=0, thick=2, /ylog, xtitle='SNAP #', ytitle='log (M / Msun)', /noerase, position=position, axiscolor='white', color='white', yrange=[1e6, 5e11]
		cgOplot, i, p_mass(i), psym=16, color='red', symsize=1.0
		IF KEYWORD_SET(eps) THEN cgPS_close
		!p.charsize=1.0
		SKIP:
		id	= gal.progs(0)
		PRINT, i-1, id, gal.mass_tot(0)
		IF id LT 0L THEN BREAK
	ENDFOR


ENDIF

END


