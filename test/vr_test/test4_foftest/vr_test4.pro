PRO vr_test4, settings

	step1	= 1L	;; read the particle data

	;;-----
	;; READ THE PARTICLE DATA
	;;-----
	xp = vr_test4_rd(settings, /save)

	;;-----
	;; OMP DOMAINS
	;;-----
	domain	= vr_test4_dom()

	;;-----
	;; READ LOG
	;;-----
	list = vr_test4_rdlog(settings, numdom=4L, /save)

	;;-----
	;; FOF TEST
	;;-----
	target_dom = [4L]
	vr_test4_fof, settings, xp, domain, target_dom

	;;-----
	;; DRAW PTCLS
	;;-----

	target_dom = [5L, 4L]
	target_axis= [0L, 1L]

	vr_test4_drptcl, settings, xp, domain, target_dom, target_axis, list


	stop
	


END
