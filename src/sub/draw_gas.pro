; :Keywords:
;    pos: in, required, type=float / double
;	  N_ptcl X N_dim
;
;    mass: in, required, type=float / double
;	  mass of ptcls in solar mass
;
;    flux: in, required, type=float / double
;	  flux of ptcls
;
;    center: in, type=float / double
;	  center of galaxies. If set, coordinates are nomalized for the center to be origin
;
;    rot_axis: in, type=float / double
;	  rotation axis (angular momentum vector) to be used to project galaxies
;
;    proj: in, type=float / double
;	  projection.
;	  ['xy', 'faceon', 'edgeon']
;
;    weight: in, required, type=float / double
;	  To give a weight to each ptcl
;	  ['mass', 'flux']
;
;    n_pick: in, type=long
;	  To sample the points in the case of large number of ptcls are given
;
;    n_pix: in, type=long
;	  # of pixels on a direction
;
;    xr, yr: in, required, type=float / double
;	  figure ranges
;
;    ctable: in, required, type= long
;         loadct value
;
;    drange: in, optional, type=float /double
;         color range

;Pro draw_gal, gal, ptcl, id=id, proj=proj, weight=weight, maxis=maxis, $
;	xr=xr, yr=yr, drange=drange, $
;	n_pix=n_pix, n_pick=n_pick, num_thread=num_thread, $
;	symsize=symsize, ctable=ctable, logscale=logscale

Pro draw_gas, amr, GAL, ind, position=position, dir_lib=dir_lib, $
	xr=xr, yr=yr, metal=metal, temperature=temperature, density=density, maxlev=maxlev

	;;-----
	;; Setting
	;;-----
	mindx	= MIN(amr.dx)
	;;-----
	;; Make a Map
	;;-----
	npix	= LONG(MAX([xr(1) - xr(0), yr(1) - yr(0)]) / mindx) + 1L

	map	= DBLARR(npix, npix)

	mapX = FINDGEN(npix) + 0.5 & mapY = FINDGEN(npix) + 0.5
	mapX = REBIN(mapX, npix, npix) & mapY = REBIN(TRANSPOSE(mapY), npix, npix)
	mapX = mapX * mindx + xr(0) & mapY = mapY * mindx  + yr(0)

	;;-----
	;; Projection
	;;-----
	lev	= LONG(ALOG10(amr.dx / MIN(amr.dx)) / ALOG10(2.0))

	IF ~KEYWORD_SET(maxlev) THEN maxlev = 100L

	cut	= WHERE(lev LE maxlev)

	ftr_name	= dir_lib + '../fortran/f_rdgas.so'
		larr = lonarr(20) & darr = dblarr(20)
		larr(0)	= N_ELEMENTS(cut)
		larr(1)	= npix

		IF KEYWORD_SET(density) THEN larr(19) = 1
		IF KEYWORD_SET(temperature) THEN larr(19) = 2
		IF KEYWORD_SET(metal) THEN larr(19) = 3

		darr(0)	= mindx

		dum	= DBLARR(N_ELEMENTS(cut),3)
			dum(*,0)	= amr.density(cut)
			dum(*,1)	= amr.temperature(cut)
			dum(*,2)	= amr.metal(cut)
		void	= CALL_EXTERNAL(ftr_name, 'f_rdgas', $
			larr, darr, amr.dx(cut), $
			amr.x(cut) - GAL.xc(ind), amr.y(cut) - GAL.yc(ind), amr.z(cut) - GAL.zc(ind), $
			amr.mass(cut), dum, map, DOUBLE(xr), DOUBLE(yr))
		       
	;;-----
	;; Draw
	;;-----
	map	= rebin(map, npix*10, npix*10)

	Loadct, 33
	drange	= [0., MAX(alog10(map+1.))]
	IF KEYWORD_SET(temperature) THEN drange(0) = 4.

	map2	= BYTSCL(ALOG10(map + 1.), min=drange(0), max=drange(1))
	IF KEYWORD_SET(temperature) THEN map2 = 255B - map2
	cgImage, map2, position=position, /noerase


End
