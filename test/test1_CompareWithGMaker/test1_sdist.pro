Pro test1_sdist, settings, vr, gm

	;;-----
	;;
	;;-----

	xr	= [11000. ,16000.]
	yr	= [11000. ,16000.]

	;;-----
	cgDisplay, 1200, 1200
	cgPlot, 0, 0, /nodata, xrange=xr, yrange=yr

	;;-----
	cgOplot, gm.x, gm.y, psym=16, symsize=0.5

	cgOplot, vr.x, vr.y, psym=16, symsize=0.4, color='red'

	cut	= where(vr.rhalfmass gt 10^(alog10(vr.mass) * 0.30681364 - 2.0456277))

	;cgplot, vr.mass(cut), vr.rhalfmass(cut), psym=16, color='red', /xlog, /ylog
	cgOplot, vr.x(cut), vr.y(cut), symsize=0.3, color='blue', psym=16

	js_stat, vr.mass(cut)

	stop

End
