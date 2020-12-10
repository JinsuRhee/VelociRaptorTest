PRO P_VRPerform_draw4_pan2, data, orgcolor=orgcolor, symsize=symsize

	cgOplot, [1e5, 1e8], [1., 1.], linestyle=1, thick=3, color='dark grey'
	cgOplot, data2.xox.fof3d.ngroup, data2.xox.fof3d.sclosed * 1.0d / data2.xox.fof3d.numsnode, $
		psym=16, color=orgcolor(0), symsize=symsize(0)
	cgOplot, data2.xox.fof6d.ngroup, data2.xox.fof6d.sclosed * 1.0d / data2.xox.fof6d.numsnode, $
		psym=16, color=orgcolor(1), symsize=symsize(0)

END
