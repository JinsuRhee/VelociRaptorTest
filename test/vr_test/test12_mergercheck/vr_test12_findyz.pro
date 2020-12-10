PRO vr_test12_findyz, settings, tree, yz_compid, n0=n0, n1=n1, id0=id0, nsnap=nsnap

	;; Read Galaxies
	fname	= '/storage6/jinsu/' + STRING(tree.vr.snaplist(n1),format='(I3.3)') + '.txt'
	;dtype=[('id', '<i4'), ('aexp', '<f8'), ('m', '<f8'), ('x', '<f8'), ('y', '<f8'), ('z', '<f8'), ('vx', '<f8'), ('vy', '<f8'), ('vz', '<f8'), ('mvir', '<f8')])
	readcol, fname, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, $
		format='D, D, D, D, D, D, D, D, D, D', numline=file_lines(fname)

	v1	= LONG(v1)
	v2	= LONG(v2)

	infoname= settings.dir_raw + 'output_' + STRING(tree.vr.snaplist(n1),format='(I5.5)') + $
		'/info_' + STRING(tree.vr.snaplist(n1),format='(I5.5)') + '.txt'
	rd_info, info, file=infoname
	v4	= v4*info.unit_l / 3.086d21
	v5	= v5*info.unit_l / 3.086d21
	v6	= v6*info.unit_l / 3.086d21
	YZGAL = {numparts:v1, ID:v2, Mass_tot:v3, xc:v4, yc:v5, zc:v6, vx:v7, vy:v8, vz:v9}
	;; Matching Galaxies

	host_id	= 6L & host_ind = 5L
	sate_id	= 1856L & sate_ind = 972L

	yz_hostid	= tree.vr.id*0L - 1L
	yz_sateid	= tree.vr.id*0L - 1L
	yz_hostid(n1)	= host_id
	yz_sateid(n1)	= sate_id

	readcol, settings.root_path + 'test/vr_test/test12*/IDs.dat', v1, v2, v3, format='L, L, L', $
		numline=file_lines(settings.root_path + 'test/vr_test/test12*/IDs.dat')

	snapind	= n1-2
	FOR i=0L, N_ELEMENTS(v1)-1L DO BEGIN
		IF v1(i) EQ tree.vr.snaplist(snapind) THEN BEGIN
			yz_hostid(snapind)	= v2(i)
			yz_sateid(snapind)	= v3(i)
			snapind --
		ENDIF ELSE BEGIN
		ENDELSE
	ENDFOR

	GOTO, skip
	;;;;; Read Tree
	fname	= '/storage1/NewHorizon/galaxy/tree.dat_619'
	yz_tree	= READ_TREE(fname)





	STOP	

	;;;;;
        FOR i=n1, n1 DO BEGIN

		;cgPS_open, settings.root_path + 'test/vr_test/test12*/findgal_' + STRING(i, format='(I3.3)') + '.eps', /encapsulated
                Dsize   = [1000., 1000.]
                cgDisplay, Dsize(0), Dsize(1)
                !p.font = -1 & !p.charsize=1.5 & !p.color=255B
		
		xr	= [-500., 500.]
		yr	= [-500., 500.]
		n_pix	= 1000L

                ;; Raw DATA
                POS     = [0., 0., 1.0, 1.0]
                cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, xstyle=4, ystyle=4, /nodata, background='black'

                GAL     = f_rdgal(settings, tree.vr.snaplist(i), settings.column_list, id=tree.vr.id(i))
                PTCL    = f_rdptcl(settings, tree.vr.id(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
                        n_snap=tree.vr.snaplist(i), /longint, /yzics, /raw, boxrange=xr(1))


                draw_gal, PTCL.xp, PTCL.mp, GAL, 0L, xr=xr, yr=yr, proj='noproj', n_pix=n_pix, $
                        num_thread=settings.num_thread, maxis=[0L, 1L], ctable=0L, /logscale, $
                        position=pos, kernel=1L, drange=[2.0, 10.0]


                cgText, xr(0) + (xr(1) - xr(0))*0.1, yr(0) + (yr(1) - yr(0))*0.1, $
                        'a = ' + STRING(GAL.aexp,format='(F5.3)'), /data, color='white'

		;;;;;
		dir     = '/storage1/NewHorizon/GalaxyMaker/GAL_' + STRING(tree.vr.snaplist(i),format='(I5.5)')
		rd_gal, dum, dir=dir, idgal=yz_hostid(i)

		YZ_HG   = {xc:dum.xg, yc:dum.yg, zc:dum.zg, $
                        lx:[dum.lxg], ly:[dum.lyg], lz:[dum.lzg]}
                YZ_HP   = {xp:[[dum.xp(*,0)], [dum.xp(*,1)], [dum.xp(*,2)]], $
                        mp:dum.mp*1e11}

		YZ_HG.xc	= (YZ_HG.xc + 0.5*(info.unit_l/3.086d24))*1e3
		YZ_HG.yc	= (YZ_HG.yc + 0.5*(info.unit_l/3.086d24))*1e3
		YZ_HG.zc	= (YZ_HG.zc + 0.5*(info.unit_l/3.086d24))*1e3
		YZ_HP.xp	= (YZ_HP.xp + 0.5*(info.unit_l/3.086d24))*1e3


		cgOplot, YZ_HG.xc - GAL.xc(0), YZ_HG.yc - GAL.yc(0), psym=16, symsize=1.0, color='red'

		rd_gal, dum, dir=dir, idgal=yz_sateid(i)

		YZ_SG   = {xc:dum.xg, yc:dum.yg, zc:dum.zg, $
                        lx:[dum.lxg], ly:[dum.lyg], lz:[dum.lzg]}
                YZ_SP   = {xp:[[dum.xp(*,0)], [dum.xp(*,1)], [dum.xp(*,2)]], $
                        mp:dum.mp*1e11}

		YZ_SG.xc	= (YZ_SG.xc + 0.5*(info.unit_l/3.086d24))*1e3
		YZ_SG.yc	= (YZ_SG.yc + 0.5*(info.unit_l/3.086d24))*1e3
		YZ_SG.zc	= (YZ_SG.zc + 0.5*(info.unit_l/3.086d24))*1e3
		YZ_SP.xp	= (YZ_SP.xp + 0.5*(info.unit_l/3.086d24))*1e3


		cgOplot, YZ_SG.xc - GAL.xc(0), YZ_SG.yc - GAL.yc(0), psym=16, symsize=1.0, color='blue'

		STOP
		PRINT, i
		;cgPS_close
        ENDFOR

	SKIP:

	yz_compid	= {host:yz_hostid, sate:yz_sateid, prop:YZGAL}
	;id0	= f_getfinaldes(settings, 4L, 106L, n1, tree.vr.snaplist)

	;vr_compid	= tree.vr.id*0L - 1L
	;vr_compid(106L:117L) = 4L
	;vr_compid(118L:127L) = 5L
	;vr_compid(128L)	= 555L
	;vr_compid(129L)	= 558L
	;vr_compid(130L) = 557L


END
