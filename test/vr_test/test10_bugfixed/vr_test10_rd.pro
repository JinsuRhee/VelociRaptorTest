PRO vr_test10_rd, settings, old, new, skip=skip

IF ~KEYWORD_SET(skip) THEN BEGIN

	dir_old	= '/storage6/jinsu/NH/galaxy/oldrun2/snap_200/'
	dir_new	= '/storage6/jinsu/NH/galaxy/snap_200/'

	RESTORE, dir_old + 'rv_io.sav'
	old	= output2
	RESTORE, dir_new + 'rv_io.sav'
	new	= output2

	output2 = 0.

	SAVE, filename=settings.root_path + 'test/vr_test/test10*/glist.sav'
ENDIF ELSE BEGIN
	RESTORE, filename=settings.root_path + 'test/vr_test/test10*/glist.sav'
ENDELSE

END
