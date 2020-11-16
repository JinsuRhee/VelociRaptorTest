PRO vr_test12_maketree, settings, tree, id0=id0, skip=skip, vr=vr, hm=hm, nsnap=nsnap

IF ~KEYWORD_SET(skip) THEN BEGIN
	IF KEYWORD_SET(vr) THEN BEGIN
		flist	= '/storage1/NewHorizon/Vraptor/VR_Galaxy/snap_*'
		flist	= FILE_SEARCH(flist)

		dum	= id0
		tree_vr	= f_getevol(settings, dum, nsnap, horg='g', /abmag, /sfr)
	ENDIF ELSE BEGIN
		tree_vr = -1.0d
	ENDELSE

	IF KEYWORD_SET(hm) THEN BEGIN

	ENDIF ELSE BEGIN
		tree_hm = -1.0d
	ENDELSE

	tree	= {vr:tree_vr, hm:tree_hm}

	SAVE, filename=settings.root_path + 'test/vr_test/test12*/tree_' + STRING(id0,format='(I4.4)') + '.sav', tree

ENDIF ELSE BEGIN
	RESTORE, settings.root_path + 'test/vr_test/test12*/tree_' + STRING(id0,format='(I4.4)') + '.sav'
ENDELSE

END
