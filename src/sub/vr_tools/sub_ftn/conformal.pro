Pro conformal

	sfact	= dindgen(10000)/9999.*0.98 + 0.02 
	conft	= dblarr(10000)
	for i=0L, 9999L do conft(i) = qsimp('YY', sfact(i), 1., /double)
	conft	= conft * (-1.)
	save, filename='conformal_table.sav', sfact, conft
End

Function YY, A
	OM	= 0.311100006103516E+00
	OL	= 0.688899993896484E+00
	Return, 1./(A^3 * sqrt(OM / A^3 + OL))
End
