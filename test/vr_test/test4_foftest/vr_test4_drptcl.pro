PRO vr_test4_drptcl, settings, xp, domain, target_dom, target_axis, list

	range1	= {X:domain(target_dom(0),target_axis(0),*), $
		Y:domain(target_dom(0),target_axis(1),*)}
	range2	= {X:domain(target_dom(1),target_axis(0),*), $
		Y:domain(target_dom(1),target_axis(1),*)}

	dx	= range1.X(1) - range1.X(0)
	dy	= range1.Y(1) - range1.Y(0)
	dr_range1	= {X:[range1.X(0) - dx*0.1, range1.X(1) + dx*0.1], $
		Y:[range1.Y(0) - dy*0.1, range1.Y(1) + dy*0.1]}

	dx	= range2.X(1) - range2.X(0)
	dy	= range2.Y(1) - range2.Y(0)
	dr_range2	= {X:[range2.X(0) - dx*0.1, range2.X(1) + dx*0.1], $
		Y:[range2.Y(0) - dy*0.1, range2.Y(1) + dy*0.1]}

	cgDisplay, 1200, 600

	;;-----
	cgPlot, 0, 0, /nodata, /noerase, xrange=dr_range1.X, yrange=dr_range1.Y, $
		position=[0.05, 0.1, 0.45, 0.9]
	cut	= js_bound(xp,transpose(reform(domain(target_dom(0),*,*),3,2)))
	cgOplot, xp(cut,target_axis(0)), xp(cut,target_axis(1)), psym=16, symsize=0.3
	dum	= list.(target_dom(0))
	cut	= where(dum.t eq max(dum.t))
	cgOplot, dum.(1+target_axis(0))(cut), dum.(1+target_axis(1))(cut), psym=16, $
		symsize=1.0, color='red'
	
	;;-----
	cgPlot, 0, 0, /nodata, /noerase, xrange=dr_range2.X, yrange=dr_range2.Y, $
		position=[0.55, 0.1, 0.95, 0.9]
	cut	= js_bound(xp,transpose(reform(domain(target_dom(1),*,*),3,2)))
	cgOplot, xp(cut,target_axis(0)), xp(cut,target_axis(1)), psym=16, symsize=0.3
	dum	= list.(target_dom(1))
	cut	= where(dum.t eq max(dum.t))
	cgOplot, dum.(1+target_axis(0))(cut), dum.(1+target_axis(1))(cut), psym=16, $
		symsize=1.0, color='red'

END
