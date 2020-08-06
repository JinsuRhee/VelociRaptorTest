; :Keywords:
;
;    center: in, required, type=float / double
;         N_dim
;         Center of a galaxy in Kpc unit
;
;    xr, yr: in, required, type=float / double
;         ranges
;
;    height: in, required, type=float / double
;         column height
;
;    n_snap: in, required, type=long
;	  Snapshot number (1 to be the first)
;
;    cname: in, required, type=string
;	  Cluster Name
;    dom_list: in, required, type=long
;	  Domain list
;

Pro draw_gas, $
	center=center, xr=xr, yr=yr, height=height, $
	n_snap=n_snap, cname=cname, dom_list=dom_list

	;;-----
	;; Settings
	;;-----

	raw_data	= '/storage5/FORNAX/KISTI_OUTPUT/' + strtrim(cname,2) + '/output_' + $
		string(n_snap,format='(I5.5)') + '/'
	vr_data		= '/storage5/FORNAX/VELOCI_RAPTOR/' + strtrim(cname,2) + '/galaxy/snap_' + $
	       string(n_snap,format='(I3.3)') + '/'	
	;;-----
	;; Sim info
	;;-----

	rd_info, siminfo, file=raw_data + 'info_' + string(n_snap,format='(I5.5)') + '.txt'

	;;-----
	;; Read Hydro and AMR
	;;-----
	center2	= center * 3.08568025d21 / siminfo.unit_l
	radius2	= radius * 3.08568025d21 / siminfo.unit_l
	for i=0L, n_elements(dom_list)-1L do begin
		rd_hydro, h, file=raw_data + 'hydro_' + string(n_snap,format='(I5.5)') + '.out', icpu=dom_list(i), /silent
		rd_amr, a, file=raw_data + 'amr_' + string(n_snap,format='(I5.5)') + '.out', icpu=dom_list(i), /silent

		amr2cell, a, h, g, lmin=9, xr=[center2(0)-radius2*5., center2(0)+radius2*5.], $
			yr=[center2(1)-radius2*5., center2(1)+radius2*5.], $
			zr=[center2(2)-radius2*5., center2(2)+radius2*5.]

		if i eq 0L then begin
			n = g.n & dx = g.dx & x = g.x & y = g.y & z = g.z & var = g.var
		endif else begin
			n = [n, g.n] & dx = [dx, g.dx] & x = [x, g.x] & y = [y, g.y] & z = [z, g.z] & var = [var, g.var]
		endelse
		print, i
	endfor
	help, n, dx, x, y, z, var
	stop


End
