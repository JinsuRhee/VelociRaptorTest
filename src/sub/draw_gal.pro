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

Pro draw_gal, pos, dz, gal, ind, $
	proj=proj, maxis=maxis, $
	xr=xr, yr=yr, drange=drange, $
	n_pix=n_pix, n_pick=n_pick, num_thread=num_thread, $
	ctable=ctable, logscale=logscale, dsize=dsize, position=position, $
	bandwidth=bandwidth, kernel=kernel, raw=raw

	;;-----
	;; Extract the corresponding galaxy
	;;-----
	center	= [gal.xc(ind), gal.yc(ind), gal.zc(ind)]
	rot_axis= [gal.lx(ind), gal.ly(ind), gal.lz(ind)]

	n_star	= n_elements(pos(*,0))

	;;-----
	;; Re-arrange Spatial coordinates
	;;-----

	;; W.R.T. Centers
	for i=0L, 2L do pos(*,i) = pos(*,i) - mean(center(i))

	;; Rotate
	if ~keyword_set(proj) then proj = 'noproj'
	if proj eq 'noproj' then begin
		pos_dum	= pos
		nn	= 0L
		if ~keyword_set(maxis) then maxis=[0L, 1L]
		pos(*,0) = pos_dum(*,maxis(0))
		pos(*,1) = pos_dum(*,maxis(1))
	endif else if proj eq 'edgeon' or proj eq 'faceon' then begin
		if ~keyword_set(rot_axis) then print, '##### Print Input the rotation axis to project the galaxy'
		if ~keyword_set(rot_axis) then stop

		rot_axis	= rot_axis / norm(rot_axis)

		ang_z	= atan(rot_axis(1) / rot_axis(0))
		rot_z	= [[cos(ang_z), -sin(ang_z), 0.], [sin(ang_z), cos(ang_z), 0.], [0., 0., 1.]]
		rot_axis	= rot_z # rot_axis

		ang_y	= atan(rot_axis(0) / rot_axis(2))
		rot_y	= [[cos(ang_y), 0., sin(ang_y)], [0., 1., 0.], [-sin(ang_y), 0., cos(ang_y)]]
		rot_mat	= rot_y # rot_z

		pos_rot	= pos

		pos_rot(*,0)	= pos(*,0) * rot_mat(0,0) + pos(*,1) * rot_mat(0,1) + pos(*,2) * rot_mat(0,2)
		pos_rot(*,1)	= pos(*,0) * rot_mat(1,0) + pos(*,1) * rot_mat(1,1) + pos(*,2) * rot_mat(1,2)
		pos_rot(*,2)	= pos(*,0) * rot_mat(2,0) + pos(*,1) * rot_mat(2,1) + pos(*,2) * rot_mat(2,2)

		pos	= pos_rot
		pos_rot = 0.
	endif

	;;-----
	;; For Sampling
	;;-----
	if keyword_set(n_pick) then begin
		ind	= long(randomu(45,n_pick)*n_star)
		pos = pos(ind,*) & dz = dz(ind,*)
		n_star	= n_pick
	endif

	;;-----
	;; Data Setting
	;;-----
	if proj eq 'noproj' then begin
		dx = pos(*,0) & dy = pos(*,1)
	endif else if proj eq 'faceon' then begin
		dx = pos(*,0) & dy = pos(*,1)
	endif else if proj eq 'edgeon' then begin
		dx = pos(*,0) & dy = pos(*,2)
	endif

	;;-----
	;; Figure Settings
	;;-----
	if ~keyword_set(n_pix) then n_pix = 1000L
	if ~keyword_set(xr) then xr = [-max([abs(min(dx)),max(dx)]), max([abs(min(dx)),max(dx)])]
	if ~keyword_set(yr) then yr = [-max([abs(min(dy)),max(dy)]), max([abs(min(dy)),max(dy)])]

	binX	= (xr(1) - xr(0)) / n_pix
	binY	= (yr(1) - yr(0)) / n_pix

	cut	= where(dx gt xr(0) and dx lt xr(1) and dy gt yr(0) and dy lt yr(1))
	if max(cut) lt 0L then begin
		print, '##### Incorrect Data range: check the xr and yr arguments'
		stop
	endif

	dx = dx(cut) & dy = dy(cut) & dz = dz(cut)

	;;-----
	;; Draw
	;;-----
	void	= 'js_denmap, float(dx), float(dy), float(dz), xrange=xr, yrange=yr, n_pix=n_pix, num_thread=num_thread' + $
		', kernel=kernel, dsize=dsize, position=position, ctable=ctable, mode=-1L'
	IF(KEYWORD_SET(bandwidth)) THEN void = void + ', bandwidth=bandwidth'
	IF(KEYWORD_SET(drange)) THEN void = void + ', dr=drange'
	IF(KEYWORD_SET(logscale)) THEN void = void + ', /logscale'

	void	= execute(void)

End
