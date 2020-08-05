FUNCTION f_rdptcl, gid, $
	p_pos=p_pos, p_vel=p_vel, p_gyr=p_gyr, p_sfactor=p_sfactor, $
	p_mass=p_mass, p_flux=p_flux, p_metal=p_metal, $
	flux_list=flux_list, $
	dir_lib=dir_lib, dir_raw=dir_raw, dir_save=dir_save, $
	num_thread=num_thread, n_snap=n_snap, longint=longint

	;;-----
	;; Read Particle IDs & Domain
	;;-----
	fname	= dir_save + 'VR_Galaxy/' + 'snap_' + $
		string(n_snap,format='(I3.3)') + '/GAL_' + $
		string(gid,format='(I6.6)') + '.hdf5'
	fid = H5F_OPEN(fname) & did = H5D_OPEN(fid, '/P_Prop/P_ID')
	pid = H5D_READ(did) & H5D_CLOSE, did & H5F_CLOSE, fid

	fid = H5F_OPEN(fname) & did = H5D_OPEN(fid, '/Domain_List')
	dom_list = H5D_READ(did) & H5D_CLOSE, did & H5F_CLOSE, fid

	;;-----
	;; Read Info File
	;;-----
	infoname	= dir_raw + 'output_' + string(n_snap,format='(I5.5)') + $
		'/info_' + string(n_snap,format='(I5.5)') + '.txt'
	rd_info, siminfo, file=infoname

	;;-----
	;; Settings
	;;-----
	n_ptcl	= n_elements(pid)
	dlist	= (where(dom_list ge 0L)) + 1L
	n_band	= n_elements(flux_list)

	;;-----
	;; Allocate Memory
	;;-----
	pinfo	= dblarr(n_ptcl,9) -  1.0d8
		;; POS, VEL, MASS, AGE, METALLICITY
	;;-----
	;; Get Ptcl
	;;-----
	ftr_name	= dir_lib + 'get_ptcl.so'
		larr = lonarr(20) & darr = dblarr(20)
		larr(0) = n_ptcl
		larr(1) = n_elements(dlist)
		larr(2) = n_snap
		larr(3)	= num_thread
		larr(10)= strlen(dir_raw)
		IF KEYWORD_SET(longint) THEN larr(19)= 100L

	void	= call_external(ftr_name, 'get_ptcl', $
		larr, darr, dir_raw, pid, pinfo, dlist)

	;;-----
	;; Extract
	;;-----
	cut	= where(pinfo(*,0) gt -1.0d7)
	IF max(cut) LT 0 THEN BEGIN
		PRINT, '	%%%%% This galaxy has no matched particles'
		RETURN, -1.
	ENDIF

	output	= {rate: (n_elements(cut) * 1.d ) / n_ptcl}

	xp	=  pinfo(*,0:2) * siminfo.unit_l / 3.086d21
	IF KEYWORD_SET(p_pos) THEN $
		output = create_struct(output, 'xp', xp(cut,*))

	vp	=  pinfo(*,3:5) * siminfo.kms
	IF KEYWORD_SET(p_vel) THEN $
		output = create_struct(output, 'vp', vp(cut,*))

	mp	=  pinfo(*,6) * siminfo.unit_m / 1.98892d33
	IF KEYWORD_SET(p_mass) THEN $
		output = create_struct(output, 'mp', mp(cut,*))

	dummy   = get_gyr(pinfo(*,7), dir_raw=dir_raw, dir_lib=dir_lib, $
		num_thread=num_thread, n_snap=n_snap)
	IF KEYWORD_SET(p_gyr) OR KEYWORD_SET(p_sfactor) THEN BEGIN
		IF KEYWORD_SET(p_gyr) THEN $
			output = create_struct(output, 'GYR', dummy(cut,1))
	        IF KEYWORD_SET(p_sfactor) THEN $
			output = create_struct(output, 'SFACTOR', dummy(cut,0))
	ENDIF

	zp	= pinfo(*,8)
	IF KEYWORD_SET(p_metal) THEN $
		output = create_struct(output, 'zp', zp(cut))

	IF KEYWORD_SET(p_flux) THEN BEGIN
		FOR i=0L, n_band - 1L DO BEGIN
			dummy2	= get_flux(mp, zp, dummy(*,1), $
				lib=dir_lib, band=flux_list(i), num_thread=num_thread)

			output = create_struct(output, 'F_' + flux_list(i), dummy2(cut))
		ENDFOR
	ENDIF


	RETURN, output
END
