PRO test3, settings

	n_snap	= 100L

	;;-----
	;; Read Galaxy
	;;-----
	gal	= test3_rd(settings, n_snap, /save)

	;;-----
	;; Gal Properties
	;;-----
	test3_gprop, settings, gal, /p_cmd;/p_ms
	STOP

END
