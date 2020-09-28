PRO vr_test7_findgal, settings, n_snap=n_snap, $
	sk_yzics=sk_yzics, sk_vr=sk_vr, skip=skip

IF ~KEYWORD_SET(skip) THEN BEGIN
IF ~KEYWORD_SET(sk_yzics) THEN BEGIN
	YZ_mass	= [1.07837092e+10, 1.41960530e+10, 1.77773179e+10, 1.91890350e+10, 2.11181937e+10]
	YZ_x	= [-0.20133781, 0.31009388, -0.26969242, 0.51792336, 0.15567017]
	YZ_y	= [0.20468545, -0.06840515, 1.12373543, 0.09712291, -0.47797847]
	YZ_z	= [0.08248734, 0.10069656, 0.67362833, -0.00747395, 0.25444078]
	YZ_nbrk	= [182L, 138L, 171L, 185L, 161L]
	;center	= [177.84531, 125.94479, 102.79567]

	;YZ_x	= YZ_x + center(0)
	;YZ_y	= YZ_y + center(1)
	;YZ_z	= YZ_z + center(2)
	;YZ	= {mass:YZ_mass, x:YZ_x * 1.0d3, y:YZ_y * 1.0d3, z:YZ_z * 1.0d3, nbroken:YZ_nbrk}

	fname	= settings.dir_raw + '../galaxy/tree_bricks' + STRING(n_snap,format='(I3.3)')
	finfo	= settings.dir_raw + 'output_00' + STRING(n_snap,format='(I3.3)') + '/info_00' + $
		STRING(n_snap,format='(I3.3)') + '.txt'
	YZ	= read_halo(fileDM=fname, fileinfo=finfo, /verbose)
	STOP
	;fname	= settings.dir_raw + '../GalaxyMaker/out_187.list'
	;readcol, fname, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, $
	;       v14, v15, v16, v17, v18, format='L, L, D, D, D, D, D, D, D, D, D, D, D, D, D, D, D, D', $
	;	numline=file_lines(fname), skipline=1L, /silent
	;YZ	= {mass:v3, xx:v9, yy:v10, zz:v11, vx:v12, vy:v13, vz:v14}
	STOP
	SAVE, filename=settings.root_path + 'test/vr_test/test7*/yzics.sav', YZ
ENDIF ELSE BEGIN
	RESTORE, settings.root_path + 'test/vr_test/test7*/yzics.sav'
ENDELSE

IF ~KEYWORD_SET(sk_vr) THEN BEGIN
	VR	= f_rdgal(settings, n_snap, [settings.column_list])
	SAVE, filename=settings.root_path + 'test/vr_test/test7*/vr.sav', VR
ENDIF ELSE BEGIN
	RESTORE, settings.root_path + 'test/vr_test/test7*/vr.sav'
ENDELSE
STOP
	cut	= WHERE(VR.mass_tot GT 5e9)

	cgDisplay, 800, 800
	cgPlot, VR.xc(cut), VR.yc(cut), psym=16, xrange=[140000., 220000.], yrange=[80000., 160000.], symsize=0.7

	FOR i=0L, 4L DO BEGIN
		cgPlot, YZ.x(i), YZ.y(i), psym=16, color='red', symsize=1.5, xrange=[-50., 50.] + YZ.x(i), $
			yrange=[-50., 50.] + YZ.y(i)

		cgOplot, VR.xc(cut), VR.yc(cut), psym=16, symsize=1.0
		STOP
	ENDFOR	
STOP
ENDIF
END
