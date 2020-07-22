Pro test1_drawgal, settings, vr, gm


	cgDisplay, 800, 800
	!p.font	= -1 & !p.charsize=1.5
	pos	= [0.1, 0.1, 0.9, 0.9]

	;;-----
	ind	= where(gm.mvir eq max(gm.mvir))
	ind	= mean(ind)
	d	= (vr.x-gm.x(ind))^2 + (vr.y-gm.y(ind))^2 + (vr.z-gm.z(ind))^2
	d	= sqrt(d)

	help, where(d lt 100.)
	stop


End








End
