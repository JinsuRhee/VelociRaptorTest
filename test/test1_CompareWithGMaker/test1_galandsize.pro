Pro test1_galandsize, settings, vr, gm, ind, xr, yr, zr, $
	n_pix, num_thread, ctable, maxis, n_snap, $
	raw=raw, logscale=logscale, sav=sav

	vr_pos  = {x:vr.xc, y:vr.yc, z:vr.zc}
	gm_pos  = {x:gm.x, y:gm.y, z:gm.z}
	range   = {x:xr, y:yr, z:zr}
	;;-----PTCL
	if ~keyword_set(sav) then begin
	if keyword_set(raw) then begin
		tmp     = where(vr.domain_list(ind,*) ge 0L)
		print, 'Reading Raw Data... # of Doms - ', n_elements(tmp)
		n1      = 0L
		i1 = 0L & i2 = 0L
		xp	= dblarr(1000000,3) - 1d8
		mp	= dblarr(1000000) - 1d8
		for i=0L, n_elements(tmp)-1L do begin
			rd_part, part, file=settings.dir_raw + 'output_' + $
				string(n_snap,format='(I5.5)') + '/part_' + $
				string(n_snap,format='(I5.5)') + '.out', $
				icpu=tmp(i), ncpu=1, /silent

			cut     = where(part.family eq 2L)
			if max(cut) lt 0L then continue
			i2	= n_elements(cut) - 1L + i1

			if i2 le n_elements(mp)-1L then begin
				xp(i1:i2,*) = part.xp(cut,*)
				mp(i1:i2) = part.mp(cut)
			endif else begin
				xp = [xp, dblarr(1000000,3) - 1d8]
				mp = [mp, dblarr(1000000) - 1d8]
				xp(i1:i2,*) = part.xp(cut,*)
				mp(i1:i2) = part.mp(cut)
			endelse
			n1 ++
			i1	= i2+1
        	endfor
		rd_info, info, file=settings.dir_raw + 'output_' + $
			string(n_snap,format='(I5.5)') + '/info_' + $
			string(n_snap,format='(I5.5)') + '.txt'
		cut	= where(mp gt -1d7)
		xp = xp(cut,*) & mp = mp(cut)
		xp      = (xp * info.unit_l/3.086d24)*1e3
		mp      = mp * info.unit_m / 1.98892e33

		cut0    = js_bound([[xp(*,0)], [xp(*,1)], [xp(*,2)]], [[range.(0)], [range.(1)], [range.(2)]])
		xp      = xp(cut0,*)
		mp      = mp(cut0)
		ptcl    = {pos:xp, mass:mp}
	ENDIF ELSE BEGIN
		f_rdptcl, ptcl, settings, n_snap, vr.id(ind), ['Pos', 'Flux', 'Mass']
	ENDELSE
	save, filename=settings.root_path + 'test/test1*/test1_ptcl_'+$
		strtrim(ind,2)+ '.sav', ptcl
	endif else begin
		restore, settings.root_path + 'test/test1*/test1_ptcl_'+$
                strtrim(ind,2)+ '.sav'
	endelse

	;;-----ANGLE
	ang     = findgen(100)/99. * !pi * 2.
	;;-----DRAW
	cgDisplay, 800, 800
	!p.color = 255B & !p.font = -1 & !p.charsize=1.0
	cgPlot,0,0,/nodata,xrange=range.(maxis(0))-mean(vr_pos.(maxis(0))(ind)), $
		yrange=range.(maxis(1))-mean(vr_pos.(maxis(1))(ind)), $
		position=[0.1, 0.1, 0.9, 0.9], $
		xstyle=4, ystyle=4, background='black', axiscolor='white'

	;;-----PTCL MAP
	IF keyword_set(logscale) THEN BEGIN
		draw_gal, vr, ptcl, id=ind, proj='noproj', maxis=maxis, $
		weight='mass', n_pix=n_pix, $
		xr=range.(maxis(0))-mean(vr_pos.(maxis(0))(ind)), $
		yr=range.(maxis(1))-mean(vr_pos.(maxis(1))(ind)), $
		symsize=0.5, ctable=ctable, num_thread=num_thread, /logscale
	ENDIF ELSE BEGIN
		draw_gal, vr, ptcl, id=ind, proj='noproj', maxis=maxis, $
		weight='mass', n_pix=n_pix, $
		xr=range.(maxis(0))-mean(vr_pos.(maxis(0))(ind)), $
		yr=range.(maxis(1))-mean(vr_pos.(maxis(1))(ind)), $
		symsize=0.5, ctable=ctable, num_thread=num_thread
	ENDELSE

	;;-----VR GALAXIES
	cut0    = js_bound([[vr_pos.(0)], [vr_pos.(1)], [vr_pos.(2)]], [[range.(0)], [range.(1)], [range.(2)]])
        for j=0L, n_elements(cut0)-1L do $
        	cgOplot, vr_pos.(maxis(0))(cut0(j)) + $
			vr.r_halfmass(cut0(j))*cos(ang)-mean(vr_pos.(maxis(0))(ind)), $
                	vr_pos.(maxis(1))(cut0(j)) + $
			vr.r_halfmass(cut0(j))*sin(ang)- mean(vr_pos.(maxis(1))(ind)), $
                	linestyle=0, color='orange', thick=3

        for j=0L, n_elements(cut0)-1L do $
        	cgOplot, vr_pos.(maxis(0))(cut0(j)) - mean(vr_pos.(maxis(0))(ind)), $
                	vr_pos.(maxis(1))(cut0(j)) - mean(vr_pos.(maxis(1))(ind)), $
                	psym=16, color='orange', thick=3, symsize=1.5
	!p.charsize=1.5
	for j=0L, n_elements(cut0)-1L do $
		cgText, vr_pos.(maxis(0))(cut0(j)) + $
			vr.r_halfmass(cut0(j))*1.1*cos(!pi/4.) - $
			mean(vr_pos.(maxis(0))(ind)), $
			vr_pos.(maxis(1))(cut0(j)) + $
			vr.r_halfmass(cut0(j))*1.1*sin(!pi/4.) - $
			mean(vr_pos.(maxis(1))(ind)), $
			string(alog10(vr.mass_tot(cut0(j))),format='(F6.3)'), $
			color='orange', /data

	;;----- GM GALAXIES
        cut2    = js_bound([[gm.x], [gm.y], [gm.z]], [[range.(0)], [range.(1)], [range.(2)]])
        for j=0L, n_elements(cut2)-1L do $
        cgOplot, gm_pos.(maxis(0))(cut2(j)) + gm.rhalfmass(cut2(j))*cos(ang)-mean(vr_pos.(maxis(0))(ind)), $
                gm_pos.(maxis(1))(cut2(j)) + gm.rhalfmass(cut2(j))*sin(ang)-mean(vr_pos.(maxis(1))(ind)), $
                linestyle=0, color='red', thick=3

        for j=0L, n_elements(cut2)-1L do $
        cgOplot, gm_pos.(maxis(0))(cut2(j)) - mean(vr_pos.(maxis(0))(ind)), $
                gm_pos.(maxis(1))(cut2(j)) - mean(vr_pos.(maxis(1))(ind)), $
                psym=16, color='red', symsize=1.5

        for j=0L, n_elements(cut2)-1L do $
		cgText, gm_pos.(maxis(0))(cut2(j)) + $
			gm.rhalfmass(cut2(j))*1.1*cos(!pi/4.) - $
			mean(vr_pos.(maxis(0))(ind)), $
			gm_pos.(maxis(1))(cut2(j)) + $
			gm.rhalfmass(cut2(j))*1.1*sin(!pi/4.) - $
			mean(vr_pos.(maxis(1))(ind)), $
			string(alog10(gm.mass(cut2(j))),format='(F6.3)'), $
			color='red', /data


End
