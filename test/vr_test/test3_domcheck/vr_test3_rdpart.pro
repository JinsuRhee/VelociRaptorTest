FUNCTION vr_test3_rdpart, settings, save=save

IF(~KEYWORD_SET(save)) THEN BEGIN
	rd_part, part, file='/storage5/FORNAX/KISTI_OUTPUT/c10006/output_00070/part_00070.out', $
		icpu=1, ncpu=2400

	rd_info, info, file='/storage5/FORNAX/KISTI_OUTPUT/c10006/output_00070/info_00070.txt'

	cut	= where(part.family EQ 2L)
	xp	= part.xp(cut,*) * info.unit_l / 3.08d21

	part	= {xp:xp}

	save, filename=settings.root_path + 'test/vr_test/test3*/part.sav', part

ENDIF ELSE BEGIN
	restore, settings.root_path + 'test/vr_test/test3*/part.sav'
ENDELSE

RETURN, part

END
