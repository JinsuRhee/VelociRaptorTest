;;-----
;; Procedure to get data
;;-----
PRO P_VRPerform_draw_cenden_data, settings, GAL, density, save=save, n_snap=n_snap, dencutval=dencutval
IF ~KEYWORD_SET(save) THEN BEGIN
        GAL     = f_rdgal(settings, n_snap, settings.column_list)

        density = DBLARr(N_ELEMENTS(GAL.ID), N_ELEMENTS(dencutval))
        bdn     = DBLARR(2,3)

        FOR i=0L, N_ELEMENTS(GAL.ID)-1L DO BEGIN
                ptcl    = f_rdptcl(settings, GAL.ID(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
                        n_snap=n_snap, /longint, /nh)

                ptcl.xp(*,0)    = ptcl.xp(*,0) - GAL.xc(i)
                ptcl.xp(*,1)    = ptcl.xp(*,1) - GAL.yc(i)
                ptcl.xp(*,2)    = ptcl.xp(*,2) - GAL.zc(i)

                FOR j=0L, N_ELEMENTS(dencutval)-1L DO BEGIN
                        bdn(*,0)        = [dencutval(j), dencutval(j)] * [-1., 1.]
                        bdn(*,1)        = [dencutval(j), dencutval(j)] * [-1., 1.]
                        bdn(*,2)        = [dencutval(j), dencutval(j)] * [-1., 1.]

                        cut     = js_bound(ptcl.xp, bdn, n_dim=3L)

                        mm      = ptcl.mp(cut)
                        rr      = SQRT(ptcl.xp(cut,0)^2 + ptcl.xp(cut,1)^2 + ptcl.xp(cut,2)^2)

                        cut2    = WHERE(rr LT dencutval(j))
                        density(i,j)    = TOTAL(mm(cut)) / (4.*!pi/3.*dencutval(j)^3)
                ENDFOR
        ENDFOR

        SAVE, filename='/storage6/jinsu/var/Paper5_VRPerform/draw1_data.sav', density, GAL
ENDIF ELSE BEGIN
        RESTORE, '/storage6/jinsu/var/Paper5_VRPerform/draw1_data.sav'
ENDELSE
END


;;-----
;; Procedure for sub panels
;;-----
PRO P_VRPerform_draw_cenden_pan1, GAL, density, xr=xr
        cgOplot, GAL.mass_tot, density(*,2), psym=16, symsize=1.2, color='dodger blue'

                cut     = WHERE(GAL.mass_tot GE xr(0))
                a       = LINFIT(ALOG10(GAL.mass_tot(cut)), ALOG10(density(cut,2)))
                xx      = FINDGEN(100)/99*(ALOG10(xr(1)) - ALOG10(xr(0))) + ALOG10(xr(0))

        cgOplot, 10^xx, 10^(a(0) + xx*a(1)), linestyle=2, thick=10, color='YGB7'

        !p.charsize=2.0
        cgLegend, /center_sym, /data, symcolors=['dodger blue'], location=[5e9, 5e7], psyms=[16], $
                length=0., titles=['Pow = ' + STRING(a(1),format='(F4.2)')], charthick=5.0, /box
        ;cgText, 8e9, 3e10, 'Pow = ' + STRING(a(1),format='(F4.2)'), charthick=5.0, /data
        PRINT, a(1)
END


;;-----
;; Main
;;-----
PRO p_vrperform_draw_cenden, settings, data, eps=eps

	P_VRPerform_draw_cenden_data, settings, GAL, density, n_snap=200L, dencutval=[0.1, 0.5, 1.0], /save


	dsize	= [800., 800.]
	width	= 0.8
	height	= width * dsize(0)/dsize(1)
	hgap	= 0.16
	vgap 	= 0.12

	IF settings.P_VRPerform_eps THEN $
		cgPS_open, settings.root_path + 'images/' + settings.P_VRPerform_draw_cenden_iname, /encapsulated

	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=2.0 & !p.charthick=5.0

	xr	= [1e8, 1e11]
	yr	= [1e6, 1e11]
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height]
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr, position=pos, /xlog, /ylog, $
		xtitle=textoidl('Stellar Mass [M' + sunsymbol() + ']'), $
		ytitle=textoidl('\rho_{0} [M' + sunsymbol() + ' Kpc^{-3}]')

	P_VRPerform_draw_cenden_pan1, GAL, density, xr=xr
	
	IF settings.P_VRPerform_eps THEN cgPS_close

END
