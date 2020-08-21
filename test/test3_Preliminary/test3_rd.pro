FUNCTION test3_rd, settings, n_snap, save=save

IF ~KEYWORD_SET(save) THEN BEGIN
	vr	= f_rdgal(settings, n_snap, [settings.column_list, 'ABmag', 'SFR'])

	save, filename=settings.root_path + 'test/test3*/gal.sav', vr
ENDIF ELSE BEGIN
	restore, settings.root_path + 'test/test3*/gal.sav'
ENDELSE

RETURN, vr

END
