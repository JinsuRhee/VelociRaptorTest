Pro test1_match, settings, vr, gm, n_snap

	draw0	= 2L
	draw1	= 2L
	draw2	= 2L	;; one galaxy
	draw3	= 21L	;; Most massive
	draw4	= 1L	;; odd radius
	draw5	= 21L	;; Missing galaxies in GM

if draw0 eq 1L then begin
	mat	= lonarr(n_elements(vr.mass)) - 1L

	for i=0L, n_elements(mat) - 1L do begin
		dum = $
			(gm.x - vr.x(i))^2 + $
			(gm.y - vr.y(i))^2 + $
			(gm.z - vr.z(i))^2
		dum	= sqrt(dum)

		cut	= where(dum eq min(dum))
		if (dum(cut) lt 0.1 * vr.rhalfmass) then $
			mat(i) = cut

		if i mod 1000 eq 0L then print, i, ' / ', n_elements(mat)
	endfor

	save, filename=settings.root_path + 'test/test1*/test1_match_dat.sav', mat
endif

	restore, settings.root_path + 'test/test1*/test1_match_dat.sav'


if draw1 eq 1L then begin
	xr	= [13005, 13009]
	yr	= [13994, 13998]
	ang	= findgen(100)/99. * !pi * 2.

	cgDisplay, 800, 800
	cgPlot, vr.xc, vr.yc, psym=16, symsize=0.8, $
		xrange=xr, yrange=yr

	cut	= where(mat ge 0L)

	cgOplot, vr.xc(cut), vr.yc(cut), psym=16, symsize=0.5, color='red'

	cgOplot, gm.x, gm.y, psym=16, symsize=0.4, color='blue'

	cut1	= js_bound([[vr.xc], [vr.yc]], [[xr], [yr]])
	for j=0L, n_elements(cut1)-1L do $
	cgOplot, vr.xc(cut1(j)) + vr.r_halfmass(cut1(j))*cos(ang), $
		vr.yc(cut1(j)) + vr.r_halfmass(cut1(j))*sin(ang), $
		linestyle=0

	cut2	= js_bound([[gm.x], [gm.y]], [[xr], [yr]])
	for j=0L, n_elements(cut2)-1L do $
	cgOplot, gm.x(cut2(j)) + gm.rhalfmass(cut2(j))*cos(ang), $
		gm.y(cut2(j)) + gm.rhalfmass(cut2(j))*sin(ang), $
		linestyle=0, color='blue'

	;;-----

endif
if draw2 eq 1L then begin
	xr	= [12978.5, 12981.5]
	yr	= [15385, 15388]
	zr	= [15390, 15393]
	n_pix	= 200L
	num_thread=10L
	ctable=1L
	maxis	= [0L, 1L]
	n_snap	= n_snap
	test1_galandsize, settings, vr, gm, 4874L, xr, yr, zr, n_pix, num_thread, $
		ctable, maxis, n_snap, /raw
endif

if draw3 eq 1L then begin
	id	= 17597L
	xr	= [-1., 1.]*0.8 + vr.xc(id)
	yr	= [-1., 1.]*0.8 + vr.yc(id)
	zr	= [-1., 1.]*0.8 + vr.zc(id)

	n_pix	= 200L
	num_thread=10L
	ctable=1L
	maxis	= [0L, 1L]
	n_snap	= n_snap
	test1_galandsize, settings, vr, gm, id, xr, yr, zr, n_pix, num_thread, $
		ctable, maxis, n_snap;, /raw

ENDIF

IF draw4 eq 1L then begin
	;cgDisplay, 800, 800
	;!p.color = 255B & !p.font = -1 & !p.charsize=2.0
	;cgPlot, vr.mass_tot, vr.r_halfmass, psym=16, symsize=0.5, /xlog, /ylog, $
	;	xtitle='Mass', ytitle='Half Mass Radius [Kpc]', position=[0.2, 0.2, 0.9, 0.9]
	;cut	= where(vr.mass_tot ge 1e8 and vr.r_halfmass gt 5. and mat ge 0L)
	;cgOplot, vr.mass_tot(cut), vr.r_halfmass(cut), psym=16, color='blue'
	id	= 2000L
	xr	= [-1., 1.]*8. + vr.xc(id)
	yr	= [-1., 1.]*8. + vr.yc(id)
	zr	= [-1., 1.]*8. + vr.zc(id)

	n_pix	= 500L
	num_thread=40L
	ctable=1L
	maxis	= [0L, 1L]
	n_snap	= n_snap
	test1_galandsize, settings, vr, gm, id, xr, yr, zr, n_pix, num_thread, $
		ctable, maxis, n_snap;, /raw, /sav

	;test1_fofcheck, settings, vr, id, n_snap, xr, yr, zr
ENDIF

IF draw5 EQ 1L THEN BEGIN

	cgDisplay, 800, 800
	!p.color = 255B & !p.font = -1 & !p.charsize=2.0

	id	= 53 ;60, 70, 83, 85, 94, 98, 102, 113, 115
	xr	= [-1., 1.]*4. + vr.xc(id)
	yr	= [-1., 1.]*4. + vr.yc(id)
	zr	= [-1., 1.]*4. + vr.zc(id)

	n_pix	= 100L
	num_thread=10L
	ctable=1L
	maxis	= [1L, 2L]
	n_snap	= n_snap
	test1_galandsize, settings, vr, gm, id, xr, yr, zr, n_pix, num_thread, $
		ctable, maxis, n_snap, /raw, /sav
ENDIF
	print, '^-^'
	wait, 123123
	stop

End
