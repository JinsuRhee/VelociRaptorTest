PRO rv_ptmatch, output, output2, dir_snap=dir_snap, dir_raw=dir_raw, dir_lib=dir_lib, $
	horg=horg, num_thread=num_thread, n_snap=n_snap, longint=longint, skip=skip

	;;-----
	;; Skip Process
	;;-----
	IF skip EQ 1L THEN BEGIN
		output2	= {p_pos:-1, p_vel:-1, p_age:-1, p_met:-1, p_mass:-1, dom_list:-1, $
			rate:-1, a_exp:-1}
		RETURN
	ENDIF
	;;-----
	;; Read Simulation Info
	;;-----

	infoname	= dir_raw + 'output_' + string(n_snap,format='(I5.5)') + $
		'/info_' + string(n_snap,format='(I5.5)') + '.txt'
	rd_info, siminfo, file=infoname

	n_mpi	= n_elements(siminfo.hindex(*,0))
	;;-----
	;; Allocate Memory
	;;-----

        n_bdn   = output.b_ind(-1,-1)+1L
        n_ubd   = output.u_ind(-1,-1) - output.b_ind(-1,-1)
	n_part	= n_bdn + n_ubd

	pos_pt	= dblarr(n_part,3) - 1d8
	vel_pt	= pos_pt
	met_pt	= dblarr(n_part) - 1d8
	age_pt	= met_pt
	mp_pt	= met_pt

	rate	= fltarr(n_elements(output.id))

	id_pt	= output.p_id
	ind_b = output.b_ind & ind_u = output.u_ind

	;;-----
	;; Find domains
	;;-----

        dom_list = [-1L] & gal_list = [-1L]

        xc      = dblarr(n_elements(output.id))
        yc      = dblarr(n_elements(output.id))
        zc      = dblarr(n_elements(output.id))
        rr      = dblarr(n_elements(output.id))
        for i=0L, n_elements(xc)-1L do xc(i) = output.xc(i)  * 3.08d21 / siminfo.unit_l
        for i=0L, n_elements(yc)-1L do yc(i) = output.yc(i)  * 3.08d21 / siminfo.unit_l
        for i=0L, n_elements(zc)-1L do zc(i) = output.zc(i)  * 3.08d21 / siminfo.unit_l
        for i=0L, n_elements(rr)-1L do rr(i) = output.r_size(i)* 3.08d21 / siminfo.unit_l

	ftr_name	= dir_lib + 'sub_ftn/find_domain.so'
		dom_list	= lonarr(n_elements(xc),n_mpi) - 1L
		larr	= lonarr(20) & darr = dblarr(20)
		larr(0) = n_elements(xc)
		larr(1) = n_mpi
		larr(2)	= num_thread

		darr(0) = 50.		;; Radius factor
	void	= call_external(ftr_name, 'find_domain', $
		xc, yc, zc, rr, siminfo.hindex, siminfo.levmax, dom_list, larr, darr)

	;;-----
	;; Read Raw Ptcls
	;;-----

	fname  = dir_raw + 'output_' + string(n_snap,format='(I5.5)') + $
		'/part_' + string(n_snap,format='(I5.5)') + '.out'

	;;;;----- Compute the finest DM mass
	dmp_mass	= 1./(4096.^3) * (siminfo.omega_m - siminfo.omega_b) / siminfo.omega_m


	;;;;----- Matching
	ftr_name	= dir_lib + 'sub_ftn/rv_match.so'
	lset = lonarr(20) & dset = dblarr(20)
	lset(0) = n_elements(id_pt)	;; # of particles in VR Data
	lset(1) = n_elements(xc)	;; # of Gals
	lset(2) = num_thread
	lset(3) = 10L			;; # of Doamins in a set
	lset(4) = n_mpi
	lset(5) = n_snap
	lset(10) = strlen(dir_raw)
	if keyword_set(longint) then lset(19) = 100 ;; For logn int ID

	dset(0) = dmp_mass
	if horg eq 'g' then dset(1) = 1.
	if horg eq 'h' then dset(1) = -1.

	void = call_external(ftr_name, 'rv_match', $
		lset, dset, dir_raw, $
		id_pt, ind_b, ind_u, pos_pt, vel_pt, $
		met_pt, age_pt, mp_pt, rate, $
		dom_list)


	pos_pt = pos_pt * siminfo.unit_l / 3.086d21
        vel_pt = vel_pt * siminfo.kms
        mp_pt  = mp_pt * siminfo.unit_m / 1.98892e33


	output2	= create_struct('p_pos', pos_pt, $
		'p_vel', vel_pt, 'p_age', age_pt, $
		'p_met', met_pt, 'p_mass', mp_pt, $
		'dom_list', dom_list, 'rate', rate, $
		'a_exp', siminfo.aexp)

	return
End
