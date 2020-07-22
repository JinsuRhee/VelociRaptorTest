Pro test1, settings

	n_snap	= 90L
	;;-----
	;; Load Data
	;;-----
	goto, skip_load_vr
	f_rdgal, vr, settings, n_snap, $
		[Settings.column_list, 'ABmag', 'SFR_T_100', 'Substructuretype'], $
       		mrange=[1e6, 1e11]
	;vr	= {ID:vr.ID, mass:vr.mass_tot, mvir:vr.mvir, $
	;	rsize:vr.r_size, rvir:vr.rvir, rhalfmass:vr.r_halfmass, $
	;	sfr:vr.sfr_t_100, x:vr.xc, y:vr.yc, z:vr.zc, flux_list:vr.flux_list}
	save, filename=settings.root_path + 'test/test1*/data_vr.sav', vr
	skip_load_vr:

	goto, skip_load_gm
	fname	= '/storage6/hansan/shared/yzics2_090.ascii'
	readcol, fname, $
		format='L, L, L, L, L,  L, L, L, D, D,  D, D, D, D, D,  D, D, D, D, D,  D, D, D, D, D,  D, D, D, D, D,  D, D, D, D, D,  D, D, D, D, D,  D, D, D, D, D,  D, D, D, D, D,  D, D', $
		v1, v2, v3, v4, v5, $
		v6, v7, v8, v9, v10, $
		v11, v12, v13, v14, v15, $
		v16, v17, v18, v19, v20, $
		v21, v22, v23, v24, v25, $
		v26, v27, v28, v29, v30, $
		v31, v32, v33, v34, v35, $
		v36, v37, v38, v39, v40, $
		v41, v42, v43, v44, v45, $
		v46, v47, v48, v49, v50, $
		v51, v52, $
		numline=file_lines(fname), skipline=1, /silent

	gm	= {x:v11, y:v12, z:v13, mass:v10, mvir:v32, rsize:v20, rvir:v31, $
		sfr1:v42, sfr2:v43, sfr4:v44, rhalfmass:v46, r90:v45}

	infoname	= settings.dir_raw + 'output_' + string(n_snap,format='(I5.5)') + '/info_' + string(n_snap,format='(I5.5)') + '.txt'
	rd_info, info, file=infoname

	gm.rsize	= gm.rsize	* (info.unit_l/3.086d24) * 1e3 
	gm.rvir		= gm.rvir 	* (info.unit_l/3.086d24) * 1e3 
	gm.rhalfmass	= gm.rhalfmass	* (info.unit_l/3.086d24) * 1e3 
	gm.r90		= gm.r90 	* (info.unit_l/3.086d24) * 1e3 

	gm.x	= (gm.x *(info.unit_l/3.086d24))*1e3 
	gm.y	= (gm.y *(info.unit_l/3.086d24))*1e3 
	gm.z	= (gm.z *(info.unit_l/3.086d24))*1e3

	save, filename=settings.root_path + 'test/test1*/data_gm.sav', gm
	skip_load_gm:

	restore, settings.root_path + 'test/test1*/data_gm.sav'
	restore, settings.root_path + 'test/test1*/data_vr.sav'

	;;-----
	;; Match
	;;-----

	test1_match, settings, vr, gm, n_snap
	;;-----
	;; Size-Mass
	;;-----
	;test1_sizemass, settings, vr, gm

	;;-----
	;; Spatial Distribution
	;;-----

	;test1_sdist, settings, vr, gm

	;;-----
	;; Main Sequence
	;;-----
	;test1_ms, settings, vr, gm

	;;-----
	;; Size-Mass
	;;-----
	;test1_sizemass, settings, vr, gm

	;;-----
	;; Massive Galaxy
	;;-----
	;test1_drawgal, settings, vr, gm
	stop

End
