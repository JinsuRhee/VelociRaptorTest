FUNCTION vr_test4_rd, settings, save=save

IF ~keyword_set(save) THEN BEGIN
	file	= '/storage5/FORNAX/KISTI_OUTPUT/l10006/output_00025/part_00025.out'

	rd_part, part, file=file, icpu=1, ncpu=480, /lver

	cut	= where(part.family eq 2L)

	xp	= part.xp(cut,*)

	file	= '/storage5/FORNAX/KISTI_OUTPUT/l10006/output_00025/info_00025.txt'

	rd_info, info, file=file

	xp	= xp * info.unit_l / 3.08d21

	save, filename=settings.root_path + 'test/vr_test/test4*/t4_xp.sav', xp
ENDIF ELSE BEGIN
	restore, settings.root_path + 'test/vr_test/test4*/t4_xp.sav'
ENDELSE

return, xp

END
