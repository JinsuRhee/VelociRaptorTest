Pro anal

	restore, 'dum_093.sav'

	cut_vr	= where(vr.mvir gt 1e6)
	cut_gm	= where(gm.mvir gt 1e6)

	;;-- Size-Mass Relation
	r_vr	= vr.rvir(cut_vr)
	m_vr	= vr.mvir(cut_vr)

	r_gm	= gm.rvir(cut_gm)
	m_gm	= gm.mvir(cut_gm)

	cgPlot, vr.rvir, vr.mvir, psym=16, /xlog, /ylog, xrange=[1e-2, 1e2], yrange=[1e5, 1e11], symsize=0.8
	cgOplot, gm.rvir, gm.mvir, psym=14, symsize=0.2, color='red'
	stop
	
End
