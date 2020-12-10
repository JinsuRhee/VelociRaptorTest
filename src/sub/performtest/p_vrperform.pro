PRO P_VRPerform, settings

IF settings.P_VRPerform_rd EQ 1L THEN BEGIN
	P_VRPerform_rd, settings, settings.P_VRPerform_nsnap(0), data
ENDIF ELSE BEGIN
	P_VRPerform_rd, settings, settings.P_VRPerform_nsnap(0), data, /skip
ENDELSE

IF settings.P_VRPerform_draw1 EQ 1L THEN $
	P_VRPerform_draw1, settings, data

IF settings.P_VRPerform_draw2 EQ 1L THEN $
	P_VRPerform_draw2, settings, data

IF settings.P_VRPerform_draw3 EQ 1L THEN $
	P_VRPerform_draw3, settings, data

IF settings.P_VRPerform_draw4 EQ 1L THEN $
	P_VRPerform_draw4, settings, data

IF settings.P_VRPerform_draw5 EQ 1L THEN $
	P_VRPerform_draw5, settings, data

IF settings.P_VRPerform_draw6 EQ 1L THEN $
	P_VRPerform_draw6, settings, data

STOP
END
