PRO vr_test12_findvr, settings, tree, vr_compid, n0=n0, n1=n1, id0=id0


	IF id0 EQ 2L THEN BEGIN
		vr_compid	= tree.vr.id*0L - 1L
		a	= f_getevol(settings, 551L, tree.vr.snaplist(146L))
		vr_compid(0L:146L) = a.id
		vr_compid(147L)	= 2L
		vr_compid(148L)	= 2L
		vr_compid(149L)	= 2L
	ENDIF

	IF id0 EQ 4L THEN BEGIN
		vr_compid	= tree.vr.id*0L - 1L
		a	= f_getevol(settings, 644L, tree.vr.snaplist(108))
		vr_compid(0L:108L) = a.id
	ENDIF

	;STOP
	GOTO, SKIP
        FOR i=n1, n0, -1L DO BEGIN

		;cgPS_open, settings.root_path + 'test/vr_test/test12*/findgal_' + STRING(i, format='(I3.3)') + '.eps', /encapsulated
                Dsize   = [1000., 1000.]
                cgDisplay, Dsize(0), Dsize(1)
                !p.font = -1 & !p.charsize=1.5 & !p.color=255B
		
		xr	= [-500., 500.]
		yr	= [-500., 500.]
		n_pix	= 200L

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

                ;GAL     = f_rdgal(settings, tree.vr.snaplist(i), settings.column_list)
                ;STOP

                COMPGAL     = f_rdgal(settings, tree.vr.snaplist(i), settings.column_list, id=vr_compid(i))
		cgOplot, COMPGAL.xc(0) - GAL.xc(0), COMPGAL.yc(0) - GAL.yc(0), psym=16, symsize=2.0, color='red'

		STOP
		PRINT, i
		;cgPS_close
        ENDFOR

	SKIP:

	;id0	= f_getfinaldes(settings, 4L, 106L, n1, tree.vr.snaplist)

	;vr_compid	= tree.vr.id*0L - 1L
	;vr_compid(106L:117L) = 4L
	;vr_compid(118L:127L) = 5L
	;vr_compid(128L)	= 555L
	;vr_compid(129L)	= 558L
	;vr_compid(130L) = 557L


END
