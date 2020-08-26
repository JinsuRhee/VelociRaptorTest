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
	xr=xr, yr=yr, metal=metal, temperature=temperature, density=density

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
	ftr_name	= dir_lib + '../fortran/f_rdgas.so'
		larr = lonarr(20) & darr = dblarr(20)
		larr(0)	= N_ELEMENTS(amr.dx)
		larr(1)	= npix

		IF KEYWORD_SET(density) THEN larr(19) = 1
		IF KEYWORD_SET(temperature) THEN larr(19) = 2
		IF KEYWORD_SET(metal) THEN larr(19) = 3

		darr(0)	= mindx

		dum	= DBLARR(N_ELEMENTS(amr.dx),3)
			dum(*,0)	= amr.density
			dum(*,1)	= amr.temperature
			dum(*,2)	= amr.metal
		void	= CALL_EXTERNAL(ftr_name, 'f_rdgas', $
			larr, darr, amr.dx, $
			amr.x - GAL.xc(ind), amr.y - GAL.yc(ind), amr.z - GAL.zc(ind), amr.mass, $
			dum, map, DOUBLe(xr), DOUBLE(yr))
		       

;		map = map * 0.	       
;	TIC
;	mass0	= 0.d
;	FOR i=0L, N_ELEMENTS(amr.dx) - 1L DO BEGIN
;		x0	= amr.x(i) - GAL.xc(ind)
;		y0	= amr.y(i) - GAL.yc(ind)
;		z0	= amr.z(i) - GAL.zc(ind)
;		dx	= amr.dx(i)
;
;		d0	= SQRT(x0^2 + y0^2 + z0^2)
;		IF d0 GT xr(1) THEN CONTINUE
;
;		cutX	= WHERE(mapX GT x0 - dx AND mapX LT x0 + dx AND $
;			mapY GT y0 - dx AND mapY LT y0 + dx)
;		IF MAX(cutX) LT 0L THEN CONTINUE
;
;		IF KEYWORD_SET(temperature) THEN dum = amr.temperature(i)
;		IF KEYWORD_SET(density) THEN dum = amr.density(i)
;		IF KEYWORD_SET(metal) THEN dum = amr.metal(i)
;		;dum	= dum / (dx * dx)
;		;map(cutX) = map(cutX) + dum * mindx * mindx
;		;map(cutX) = map(cutX) + dum * amr.mass(i) * (mindx/dx)^2
;		map(cutX) = map(cutX) + dum * (mindx/dx)^2
;		mass0	= mass0 + amr.mass(i)
;		IF i GE 9590 THEN print, i, dum, map(94,93)
;		IF i GE 9591 - 1L THEN STOP
;	ENDFOR
	;map	= map / mass0
;	TOC, /verbose

	;;-----
	;; Draw
	;;-----
	map	= rebin(map, npix*10, npix*10)
	Loadct, 33
	drange	= [0., MAX(alog10(map+1.))]
	map2	= BYTSCL(ALOG10(map + 1.), min=drange(0), max=drange(1))
	IF KEYWORD_SET(temperature) THEN map2 = 255B - map2
	cgImage, map2, position=position, /noerase


End
