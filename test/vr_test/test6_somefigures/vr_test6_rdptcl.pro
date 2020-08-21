FUNCTION vr_test6_rdptcl, settings, n_snap, save=save

IF ~KEYWORD_SET(save) THEN BEGIN
	file	= '/storage5/FORNAX/KISTI_OUTPUT/l10006/output_00' + $
		string(n_snap,format='(I3.3)') + '/part_00' + $
		string(n_snap,format='(I3.3)') + '.out'
	rd_part, part, file=file, /lver, icpu=1, ncpu=480

	cut	= where(part.family EQ 2L)
	xp	= part.xp(cut,*)
	mp	= part.mp(cut)
	file	= '/storage5/FORNAX/KISTI_OUTPUT/l10006/output_00' + $
		string(n_snap,format='(I3.3)') + '/info_00' + $
		string(n_snap,format='(I3.3)') + '.txt'

	rd_info, info, file=file

	xp	= xp * info.unit_l / 3.086d21
	mp	= mp / MIN(mp)
	save, filename = settings.root_path + 'test/vr_test/test6*/ptcl.sav', xp, mp
ENDIF ELSE BEGIN
	restore,  settings.root_path + 'test/vr_test/test6*/ptcl.sav'
ENDELSE

	RETURN, {xp:xp, mp:mp}
END
