PRO P_VRPerform_rd, settings, nsnap, data, skip=skip

IF ~KEYWORD_SET(SKIP) THEN BEGIN
	dum	= ['o', 'x']
	FOR i0=0L, 1L DO BEGIN
	FOR i1=0L, 1L DO BEGIN
	FOR i2=0L, 1L DO BEGIN
	FOR i3=0L, 1L DO BEGIN
	FOR i4=0L, 1L DO BEGIN
		fname	= settings.P_VRPerform_dir + 'snap_' + STRING(nsnap, format='(I3.3)') + '_' + $
			STRTRIM(dum(i0),2) + $
			STRTRIM(dum(i1),2) + $
			STRTRIM(dum(i2),2) + $
			STRTRIM(dum(i3),2) + $
			STRTRIM(dum(i4),2)

		print, fname

ENDIF ELSE BEGIN

ENDELSE


STOP
END
