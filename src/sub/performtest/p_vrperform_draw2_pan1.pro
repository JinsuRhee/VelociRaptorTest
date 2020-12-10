PRO P_VRPerform_draw2_pan1, GAL, density, xr=xr

	cgOplot, GAL.mass_tot, density(*,2), psym=16, symsize=0.8, color='dodger blue'

		cut	= WHERE(GAL.mass_tot GE xr(0))
		a	= LINFIT(ALOG10(GAL.mass_tot(cut)), ALOG10(density(cut,2)))
		xx	= FINDGEN(100)/99*(ALOG10(xr(1)) - ALOG10(xr(0))) + ALOG10(xr(0))

	cgOplot, 10^xx, 10^(a(0) + xx*a(1)), linestyle=2, thick=6, color='YGB5'

	cgText, 8e9, 3e7, 'Power : ' + STRING(a(1),format='(F5.3)'), /data
	PRINT, a(1)

END
