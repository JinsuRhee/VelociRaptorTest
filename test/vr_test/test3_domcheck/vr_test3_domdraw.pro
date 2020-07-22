Pro vr_test3_domdraw, settings, domain, mpidom, part, nmpi=nmpi

	domain	= domain.(nmpi)
	mpidom	= reform(mpidom(nmpi,*,*),3,2)
	range	= mpidom
	for i=0L, 2L do begin
		rag	= mpidom(i,1) - mpidom(i,0)
		range(i,0) = mpidom(i,0) - rag*0.1
		range(i,1) = mpidom(i,1) + rag*0.1
	endfor

	color	= ['red', 'orange', 'yellow', 'green', 'skyblue', 'blue', 'navy', 'purple']
	cgDisplay, 1200, 600
	;;----- XY
	cgPlot, 0, 0, /nodata, position=[0.1, 0.1, 0.5, 0.9], xrange=range(0,*), yrange=range(1,*)

	FOR i=0L, domain.nompdom-1L DO BEGIN
		line	= js_makeline(domain.bdn(i,0,*), domain.bdn(i,1,*))
		cgOplot, line(*,0), line(*,1), linestyle=0, thick=2, color=color(i)
	ENDFOR


	line	= js_makeline(mpidom(0,*), mpidom(1,*))
	cgOplot, line(*,0), line(*,1), linestyle=2, thick=3

	;;----- YZ
	cgPlot, 0, 0, /nodata, /noerase, position=[0.59, 0.1, 0.99, 0.9], xrange=range(1,*), yrange=range(2,*)

	FOR i=0L, domain.nompdom-1L DO BEGIN
		line	= js_makeline(domain.bdn(i,1,*), domain.bdn(i,2,*))
		cgOplot, line(*,0), line(*,1), linestyle=0, thick=2, color=color(i)
	ENDFOR

	line	= js_makeline(mpidom(1,*), mpidom(2,*))
	cgOplot, line(*,0), line(*,1), linestyle=2, thick=3

	;;-----
	n_ptcl	= lonarr(domain.nompdom)
	for i=0L, domain.nompdom-1L do begin
		cut	= where(part.xp(*,0) gt domain.bdn(i,0,0) and part.xp(*,0) lt domain.bdn(i,0,1) $
			and part.xp(*,1) gt domain.bdn(i,1,0) and part.xp(*,1) lt domain.bdn(i,1,1) $
			and part.xp(*,2) gt domain.bdn(i,2,0) and part.xp(*,2) lt domain.bdn(i,2,1))

		print, i, n_elements(cut), ' / ', domain.npt
	endfor
	stop
END

