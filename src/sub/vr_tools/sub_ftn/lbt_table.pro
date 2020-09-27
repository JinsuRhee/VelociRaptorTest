Pro lbt_table

	tmp_red = dindgen(10000)/9999.*0.98 + 0.02
	tmp_red = 1./tmp_red - 1. & tmp_red = reverse(tmp_red)
	tmp_gyr = tmp_red & tmp_gyr(0) = 0.
	for i=1L, n_elements(tmp_red)-1L do tmp_gyr(i) = qsimp('lbt_int',0., tmp_red(i), /double)
	;YZiCS2
	;tmp_gyr = tmp_gyr / 0.676600036621094E+02 * 3.08568025e19 / 3.1536000d+16

	;NH / YZiCS
	tmp_gyr = tmp_gyr / 0.704000015258789E+02 * 3.08568025e19 / 3.1536000d+16

	save, filename='LBT_table_NH.sav', tmp_red, tmp_gyr
End

Function lbt_int, X

	;YZiCS2
	;OM	= 0.311100006103516E+00
	;OL	= 0.688899993896484E+00

	;NH / YZiCS
	OM	= 0.272000014781952E+00
	OL	= 0.727999985218048E+00
	return, 1./(1.+X)/sqrt(OM*(1.+X)^3 + OL)
End
