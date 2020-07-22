Pro vr_test3, settings

	;;-----
	;; READ RAW DATA
	;;-----

	part	= vr_test3_rdpart(settings, /save)

	;;-----
	;; READ BOUNDARY
	;;-----

	domain	= vr_test3_domread(settings, /save)

	;;-----
	;; MPI DOMAIN
	;;-----

	mpidom	= vr_test3_mpidom(settings, /save)
	
	;;-----
	;; DRAW
	;;-----

	vr_test3_domdraw, settings, domain, mpidom, part, nmpi=7

End
