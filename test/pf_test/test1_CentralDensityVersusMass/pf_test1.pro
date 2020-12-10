PRO pf_test1, settings

	n_snap	= 200L

	GAL	= f_rdgal(settings, n_snap, settings.column_list)

	dencut	= [0.1, 0.5, 1.0]	;; in Kpc
	den	= DBLARR(N_ELEMENTS(GAL.ID),N_ELEMENTS(dencut))
	bdn	= DBLARR(2,3)

	FOR i=0L, N_ELEMENTS(GAL.ID)-1L DO BEGIN
		ptcl	= f_rdptcl(settings, GAL.ID(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=n_snap, /longint, /yzics)

		ptcl.xp(*,0) = ptcl.xp(*,0) - GAL.xc(i)
		ptcl.xp(*,1) = ptcl.xp(*,1) - GAL.yc(i)
		ptcl.xp(*,2) = ptcl.xp(*,2) - GAL.zc(i)

		FOR j=0L, N_ELEMENTS(dencut)-1L DO BEGIN
			bdn(*,0) = [dencut(j), dencut(j)] * [-1., 1.]
			bdn(*,1) = [dencut(j), dencut(j)] * [-1., 1.]
			bdn(*,2) = [dencut(j), dencut(j)] * [-1., 1.]

			cut	= js_bound(ptcl.xp, bdn, n_dim=3L)

			rr	= SQRT($
				ptcl.xp(cut,0)^2 + ptcl.xp(cut,1)^2 + ptcl.xp(cut,2)^2)

			mm	= ptcl.mp(cut)
			cut	= WHERE(rr LT dencut(j))
			den(i,j)= TOTAL(mm(cut)) / dencut(j)^3
		ENDFOR

		PRINT, i, ' / ', N_ELEMENTS(GAL.ID) - 1L
	ENDFOR

	STOP

END
