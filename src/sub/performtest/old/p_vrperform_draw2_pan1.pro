PRO P_VRPerform_draw2_pan1, GAL, density, xr=xr

	cgOplot, GAL.mass_tot, density(*,2), psym=16, symsize=1.2, color='dodger blue'

		cut	= WHERE(GAL.mass_tot GE xr(0))
		a	= LINFIT(ALOG10(GAL.mass_tot(cut)), ALOG10(density(cut,2)))
		xx	= FINDGEN(100)/99*(ALOG10(xr(1)) - ALOG10(xr(0))) + ALOG10(xr(0))

	cgOplot, 10^xx, 10^(a(0) + xx*a(1)), linestyle=2, thick=10, color='YGB7'

	!p.charsize=2.0
	cgLegend, /center_sym, /data, symcolors=['dodger blue'], location=[5e9, 5e7], psyms=[16], $
		length=0., titles=['Pow = ' + STRING(a(1),format='(F4.2)')], charthick=5.0, /box
	;cgText, 8e9, 3e10, 'Pow = ' + STRING(a(1),format='(F4.2)'), charthick=5.0, /data
	PRINT, a(1)

END
