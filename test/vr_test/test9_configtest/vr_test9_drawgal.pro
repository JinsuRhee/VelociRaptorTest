PRO vr_test9_drawgal, settings, masscut=masscut, n_pix=n_pix, n_snap=n_snap, drange=drange, linking=linking, eps=eps, cf=cf

	testname	= 'finver'
	settings.dir_catalog_pre	= settings.dir_catalog_pre + STRING(linking(0),'(F4.2)') + '_' + $
		STRING(linking(1),'(F4.2)') + '_'

	settings.dir_save	= '/storage1/NewHorizon/Vraptor/VR_Galaxy/cft/test_' + STRTRIM(testname,2) + '_' + $
		STRING(linking(0),'(F4.2)') + '_' + STRING(linking(1),'(F4.2)') + '/'
	GAL	= f_rdgal(settings, n_snap, [settings.column_list, 'ABmag'])
	SAVE, filename=settings.root_path + 'test/vr_test/test9*/vr_' + $
		STRING(linking(0),'(F4.2)') + '_' + STRING(linking(1),'(F4.2)') + '.sav', GAL

	fname	= settings.root_path + 'test/vr_test/test9*/200.txt'
	readcol, fname, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, $
		v11, v12, v13, v14, v15, v16, /silent, numline=file_lines(fname)
	infoname= settings.dir_raw + 'output_' + STRING(n_snap,format='(I5.5)') + $
		'/info_' + STRING(n_snap,format='(I5.5)') + '.txt'
	rd_info, info, file=infoname
	v8	= v8*info.unit_l / 3.086d21
	v9	= v9*info.unit_l / 3.086d21
	v10	= v10*info.unit_l / 3.086d21
	v14	= v14*info.unit_l / 3.086d21
	v15	= v15*info.unit_l / 3.086d21
	YZ	= {m:v7, x:v8, y:v9, z:v10, vx:v11, vy:v12, vz:v13, r:v14, rvir:v15, mvir:v16}

	RESTORE, settings.root_path + 'test/vr_test/test9*/vr_' + STRING(linking(0),'(F4.2)') + $
		'_' + STRING(linking(1),'(F4.2)') + '.sav'

	cut	= WHERE(GAL.mass_tot GE masscut); AND GAL.structuretype GE 10)

	FOR i=0L, N_ELEMENTS(cut)-1L DO BEGIN
		id	= GAL.id(cut(i))
		PTCL	= f_rdptcl(settings, id, /p_pos, /p_mass, /p_gyr, num_thread=settings.num_thread, n_snap=n_snap, $
			/longint, /yzics)

		PTCL_raw= f_rdptcl(settings, id, /p_pos, /p_mass, /p_gyr, num_thread=settings.num_thread, n_snap=n_snap, $
			/longint, /yzics, /raw)

		IF KEYWORD_SET(eps) AND KEYWORD_SET(cf) THEN $
			cgPS_open, settings.root_path + 'test/vr_test/test9*/G_CF_' + STRTRIM(testname,2) + '_' + $
			STRING(linking(0),'(F4.2)') + '_' + $
			STRING(linking(1),'(F4.2)') + '_' + $
			STRTRIM(n_snap,2) + '_' + STRING(i,format='(I5.5)') + '.eps', /encapsulated

		IF KEYWORD_SET(eps) AND ~KEYWORD_SET(cf) THEN $
			cgPS_open, settings.root_path + 'test/vr_test/test9*/G_' + $
			STRING(linking(0),'(F4.2)') + '_' + $
			STRING(linking(1),'(F4.2)') + '_' + $
			STRTRIM(n_snap,2) + '_' + STRING(i,format='(I5.5)') + '.eps', /encapsulated
		Dsize	= [1000., 1000.]
		cgDisplay, DSize(0), DSize(1)
		!p.font = -1 & !p.charsize=1.5 & !p.color=255B
		xr	= [-GAL.r_halfmass(cut(i)), GAL.r_halfmass(cut(i))] * 5.
		yr	= xr
		zr	= xr

		
		;;-----
		;; VRaptor
		;;-----
		pos	= [0.5, 0.0, 1.0, 0.5]
		cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, /nodata, xstyle=4, ystyle=4, background='black'

		gpos	= dblarr(N_ELEMENTS(GAL.id),3)
			gpos(*,0)	= gal.xc
			gpos(*,1)	= gal.yc
			gpos(*,2)	= gal.zc
		gbound	= dblarr(2,3)
			gbound(*,0)	= xr + gal.xc(cut(i))
			gbound(*,1)	= yr + gal.yc(cut(i))
			gbound(*,2)	= zr + gal.zc(cut(i))

		exind	= js_bound(gpos, gbound, n_dim=3)
		
		draw_gal, PTCL_raw.xp, PTCL_raw.mp, GAL, cut(i), xr=xr, yr=yr, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=0L, /logscale, $
			position=pos, kernel=1L, drange=drange
		loadct, 42, file='/storage5/jinsu/idl_lib/lib/jinsu/js_idlcolor.tbl'
		;FOR j=0L, N_ELEMENTS(exind)-1L DO BEGIN
		;	coind	= BYTSCL(alog10(gal.mass_tot(exind(j))), min=6., max=10.)
		;	IF gal.mass_tot(exind(j)) GE 1e8 THEN BEGIN
		;		cgOplot, gal.xc(exind(j)) - gal.xc(cut(i)), $
		;			gal.yc(exind(j)) - gal.yc(cut(i)), $
		;			psym=16, color=BYTE(coind), charsize=1.0

		;		ang	= findgen(100)/99.*!pi*2.
		;		cgOplot, cos(ang)*gal.r_halfmass(exind(j)) + gal.xc(exind(j)) - gal.xc(cut(i)), $
		;			sin(ang)*gal.r_halfmass(exind(j)) + gal.yc(exind(j)) - gal.yc(cut(i)), $
		;			linestyle=2, color=BYTE(coind)
		;	ENDIF ELSE BEGIN
		;		cgOplot, gal.xc(exind(j)) - gal.xc(cut(i)), $
		;			gal.yc(exind(j)) - gal.yc(cut(i)), $
		;			psym=16, color=BYTE(coind), charsize=0.1
		;	ENDELSE

		;ENDFOR
		!p.charsize = 1.5 & !p.charthick=3.0
		cgText, (xr(1) - xr(0))*0.05 + xr(0), (yr(1) - yr(0))*0.95 + yr(0), 'Raw Data', /data, color='white'


		pos	= [0., 0.5, 0.5, 1.0]
		cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, /nodata, /noerase, xstyle=4, ystyle=4, background='black'

		draw_gal, PTCL.xp, PTCL.mp, GAL, cut(i), xr=xr, yr=yr, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=0L, /logscale, $
			position=pos, kernel=1L, drange=drange

			loadct, 42, file='/storage5/jinsu/idl_lib/lib/jinsu/js_idlcolor.tbl'
			coind	= BYTSCL(alog10(gal.mass_tot(cut(i))), min=6., max=10.)
			ang	= findgen(100)/99.*!pi*2.
			cgOplot, cos(ang)*gal.r_halfmass(cut(i)), $
				sin(ang)*gal.r_halfmass(cut(i)), $
				linestyle=2, color=BYTE(coind)

		!p.charsize = 1.5 & !p.charthick=3.0
		cgText, (xr(1) - xr(0))*0.05 + xr(0), (yr(1) - yr(0))*0.95 + yr(0), 'VRaptor - HostGal', /data, color='white'
		cgText, (xr(1) - xr(0))*0.05 + xr(0), (yr(1) - yr(0))*0.88 + yr(0), 'log(M) = ' + STRING(ALOG10((GAL.mass_tot(cut(i)))),format='(F6.3)'), /data, color='white'


		pos	= [0.5, 0.5, 1.0, 1.0]
		cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, /nodata, /noerase, xstyle=4, ystyle=4, background='black'

		xp_dum	= [PTCL.xp, PTCL_raw.xp]
		mp_dum	= [PTCL.mp*(-1.0), PTCL_raw.mp]	
		draw_gal, xp_dum, mp_dum, GAL, cut(i), xr=xr, yr=yr, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=0L, /logscale, $
			position=pos, kernel=1L, drange=drange

		loadct, 42, file='/storage5/jinsu/idl_lib/lib/jinsu/js_idlcolor.tbl'
		FOR j=0L, N_ELEMENTS(exind)-1L DO BEGIN
			IF exind(j) EQ cut(i) THEN CONTINUE
			coind	= BYTSCL(alog10(gal.mass_tot(exind(j))), min=6., max=10.)
			cgOplot, gal.xc(exind(j)) - gal.xc(cut(i)), $
				gal.yc(exind(j)) - gal.yc(cut(i)), $
				psym=9, color=BYTE(coind), charsize=5.0

		ENDFOR

		!p.charsize = 1.5 & !p.charthick=3.0
		cgText, (xr(1) - xr(0))*0.05 + xr(0), (yr(1) - yr(0))*0.95 + yr(0), 'VRaptor - Residual', /data, color='white'

		;;-----
		;; GMaker
		;;-----
		pos	= [0., 0.0, 0.5, 0.5]
		cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, /nodata, xstyle=4, ystyle=4, background='black', /noerase

		gpos	= dblarr(N_ELEMENTS(yz.x),3)
			gpos(*,0)	= yz.x
			gpos(*,1)	= yz.y
			gpos(*,2)	= yz.z
		gbound	= dblarr(2,3)
			gbound(*,0)	= xr + gal.xc(cut(i))
			gbound(*,1)	= yr + gal.yc(cut(i))
			gbound(*,2)	= zr + gal.zc(cut(i))

		exind	= js_bound(gpos, gbound, n_dim=3)
		
		draw_gal, PTCL_raw.xp, PTCL_raw.mp, GAL, cut(i), xr=xr, yr=yr, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=0L, /logscale, $
			position=pos, kernel=1L, drange=drange

		loadct, 42, file='/storage5/jinsu/idl_lib/lib/jinsu/js_idlcolor.tbl'
		FOR j=0L, N_ELEMENTS(exind)-1L DO BEGIN
			IF yz.mvir(exind(j)) LT MIN(GAL.mass_tot) THEN CONTINUE
			coind	= BYTSCL(alog10(yz.mvir(exind(j))), min=6., max=10.)
			IF yz.mvir(exind(j)) GE 1e8 THEN BEGIN
				cgOplot, yz.x(exind(j)) - gal.xc(cut(i)), $
					yz.y(exind(j)) - gal.yc(cut(i)), $
					psym=16, color=BYTE(coind), charsize=1.0

				ang	= findgen(100)/99.*!pi*2.
				cgOplot, cos(ang)*yz.rvir(exind(j)) + yz.x(exind(j)) - gal.xc(cut(i)), $
					sin(ang)*yz.rvir(exind(j)) + yz.y(exind(j)) - gal.yc(cut(i)), $
					linestyle=2, color=BYTE(coind)
			ENDIF ELSE BEGIN
				cgOplot, yz.x(exind(j)) - gal.xc(cut(i)), $
					yz.y(exind(j)) - gal.yc(cut(i)), $
					psym=9, color=BYTE(coind), charsize=5.0
			ENDELSE

		ENDFOR

		!p.charsize = 1.5 & !p.charthick=3.0
		cgText, (xr(1) - xr(0))*0.05 + xr(0), (yr(1) - yr(0))*0.95 + yr(0), 'GMaker', /data, color='white'
		cgText, (xr(1) - xr(0))*0.05 + xr(0), (yr(1) - yr(0))*0.88 + yr(0), 'log(M) = ' + STRING(ALOG10(MAX(yz.mvir(exind))),format='(F6.3)'), /data, color='white'
		IF KEYWORD_SET(eps) THEN cgPS_close


	ENDFOR

END
