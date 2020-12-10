PRO P_VRPerform_draw2_data, settings, GAL, density, save=save, n_snap=n_snap, dencutval=dencutval

IF ~KEYWORD_SET(save) THEN BEGIN
	GAL	= f_rdgal(settings, n_snap, settings.column_list)

	density	= DBLARr(N_ELEMENTS(GAL.ID), N_ELEMENTS(dencutval))
	bdn	= DBLARR(2,3)

	FOR i=0L, N_ELEMENTS(GAL.ID)-1L DO BEGIN
		ptcl	= f_rdptcl(settings, GAL.ID(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=n_snap, /longint, /nh)

		ptcl.xp(*,0)	= ptcl.xp(*,0) - GAL.xc(i)
		ptcl.xp(*,1)	= ptcl.xp(*,1) - GAL.yc(i)
		ptcl.xp(*,2)	= ptcl.xp(*,2) - GAL.zc(i)

		FOR j=0L, N_ELEMENTS(dencutval)-1L DO BEGIN
			bdn(*,0)	= [dencutval(j), dencutval(j)] * [-1., 1.]
			bdn(*,1)	= [dencutval(j), dencutval(j)] * [-1., 1.]
			bdn(*,2)	= [dencutval(j), dencutval(j)] * [-1., 1.]

			cut	= js_bound(ptcl.xp, bdn, n_dim=3L)

			mm	= ptcl.mp(cut)
			rr	= SQRT(ptcl.xp(cut,0)^2 + ptcl.xp(cut,1)^2 + ptcl.xp(cut,2)^2)
			
			cut2	= WHERE(rr LT dencutval(j))
			density(i,j)	= TOTAL(mm(cut)) / (4.*!pi/3.*dencutval(j)^3)
		ENDFOR
	ENDFOR

	SAVE, filename='/storage6/jinsu/var/Paper5_VRPerform/draw1_data.sav', density, GAL
ENDIF ELSE BEGIN
	RESTORE, '/storage6/jinsu/var/Paper5_VRPerform/draw1_data.sav'
ENDELSE

END
