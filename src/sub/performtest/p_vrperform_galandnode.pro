;;-----
;; Draw original galaxy
;;-----
PRO P_VRPerform_galandnode_draworg, part2, bnd2, pos, npix, d3=d3, d6=d6, zoom=zoom
	bnd	= bnd2
	part	= part2

	IF KEYWORD_SET(d3) THEN BEGIN
		bnd(*,0) = [-100., 100.] + MEDIAN(part(*,0))
		bnd(*,1) = [-100., 100.] + MEDIAN(part(*,1))
		bnd(*,2) = [-100., 100.] + MEDIAN(part(*,2))
		IF KEYWORD_SET(zoom) THEN BEGIN
			bnd(*,0) = [-0.5, 0.5] + MEDIAN(part(*,0))
			bnd(*,1) = [-0.5, 0.5] + MEDIAN(part(*,1))
			bnd(*,2) = [-0.1, 0.1] + MEDIAN(part(*,2))
		ENDIF

		cut	= WHERE(part(*,2) GT bnd(0,2) AND part(*,2) LT bnd(1,2))
		part	= part(cut,*)
	ENDIF ELSE IF KEYWORD_SET(d6) THEN BEGIN

	ENDIF

	cgPlot, 0, 0, /nodata, xrange=bnd(*,0), yrange=bnd(*,1), position=pos, xstyle=4, ystyle=4

	js_denmap, part(*,0), part(*,1), part(*,2), xr=bnd(*,0), yr=bnd(*,1), n_pix=npix, num_thread=10L, $
		kernel=1L, ctable=0L, mode=-1L, position=pos, /logscale
END

;;-----
;; Draw Node
;;-----
PRO P_VRPerform_galandnode_drawnode, part, node, bnd, leaf=leaf, split=split

	IF KEYWORD_SET(leaf) THEN col='white'
	IF KEYWORD_SET(split) THEN col='red'
	zcen	= MEDIAN(part(*,2));MEAN(bnd(*,2))
	numnode	= N_ELEMENTS(node(*,0))
	FOR i=0L, numnode-1L DO BEGIN
		IF node(i,5) LT zcen AND node(i,6) GT zcen THEN $
		cgOplot, [node(i,1), node(i,2), node(i,2), node(i,1), node(i,1)], $
			[node(i,3), node(i,3), node(i,4), node(i,4), node(i,3)], linestyle=0, $
			color=col
	ENDFOR

	cir_x	= MEDIAN(part(*,0))
	cir_y	= MEDIAN(part(*,1))
	cir_r	= 1.997880303
	cir_ang	= FINDGEN(100)/99. * !pi * 2.
	cgOplot, cir_r * COS(cir_ang) + cir_x, cir_r * SIN(cir_ang) + cir_y, linestyle=0, color='yellow', thick=3
	STOP
	
END

;;-----
;; Read Nodes
;;-----
PRO P_VRPerform_galandnode_rdnode, ln, sn, bnd, d3=d3, d6=d6

	IF KEYWORD_SET(d3) THEN n_dim = 3L
	IF KEYWORD_SET(d6) THEN n_dim = 6L
	;;-----
	;; 3D NODE FIRST
	;;-----
	IF KEYWORD_SET(d3) THEN $
		fname	= '/storage6/jinsu/var/Paper5*/mgal_3dnode.dat'
	IF KEYWORD_SET(d6) THEN $
		fname	= '/storage6/jinsu/var/Paper5*/mgal_6dnode.dat'

	fline	= FILE_LINES(fname)

	IF KEYWORD_SET(d3) THEN BEGIN
		sn	= DBLARR(fline,8)

		READCOL, fname, v1, v2, v3, v4, v5, v6, v7, v8, $
			format='D, D, D, D, D, D, D, D', numline=fline, /silent
		FOR i=0L, 7L DO BEGIN
			tmp	= 'sn(*,' + STRTRIM(i,2) + ')=v' + STRTRIM(i+1,2)
			void	= EXECUTE(tmp)
		ENDFOR
	ENDIF ELSE IF KEYWORD_SET(d6) THEN BEGIN
		sn	= DBLARR(fline,14)

		READCOL, fname, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, $
			format='D, D, D, D, D, D, D, D, D, D, D, D, D, D', numline=fline, /silent
		FOR i=0L, 13L DO BEGIN
			tmp	= 'sn(*,' + STRTRIM(i,2) + ')=v' + STRTRIM(i+1,2)
			void	= EXECUTE(tmp)
		ENDFOR
	ENDIF

	;;-----
	;; EXTRACT
	;;-----
	dumarr	= DBLARR(fline,3)
		dumarr(*,0)	= (v2 + v3)/2.
		dumarr(*,1)	= (v4 + v5)/2.
		dumarr(*,2)	= (v6 + v7)/2.
	cut	= JS_BOUND(dumarr, bnd, n_dim=n_dim)

	sn	= sn(cut,*)
	cut_l	= WHERE(sn(*,-1) LE 32)
	cut_s	= WHERE(sn(*,-1) GT 32)
		ln	= sn(cut_l,*)
		sn	= sn(cut_s,*)

END

;;-----
;; Read Particles
;;-----
PRO P_VRPerform_galandnode_rdpart, part, d3=d3, d6=d6
	IF KEYWORD_SET(d3) THEN n_dim = 3L
	IF KEYWORD_SET(d6) THEN n_dim = 6L

	;;-----
	;; File Read
	;;-----
	IF KEYWORD_SET(d3) THEN $
		fname	= '/storage6/jinsu/var/Paper5*/mgal_3dnum.dat'
	IF KEYWORD_SET(d6) THEN $
		fname	= '/storage6/jinsu/var/Paper5*/mgal_6dnum.dat'

	fline	= FILE_LINES(fname)

	part	= DBLARR(fline,3)

	READCOL, fname, v1, v2, v3, $
		format='D, D, D', numline=fline, /silent

	part(*,0)	= v1
	part(*,1)	= v2
	part(*,2)	= v3
END

;;-----
;; Main
;;-----
PRO P_VRPerform_galandnode, settings

	;P_VRPerform_galandnode_rdpart, part, /d3
	;bnd	= DBLARR(2,3)
	;	bnd(*,0)	= [MIN(part(*,0)), MAX(part(*,0))]
	;	bnd(*,1)	= [MIN(part(*,1)), MAX(part(*,1))]
	;	bnd(*,2)	= [MIN(part(*,2)), MAX(part(*,2))]
	;P_VRPerform_galandnode_rdnode, ln, sn, bnd, /d3
	;SAVE, filename='/storage6/jinsu/var/Paper5*/galandnode_3d.sav', part, ln, sn, bnd
	RESTORE, '/storage6/jinsu/var/Paper5*/galandnode_3d.sav'

	;;-----
	;; Draw Original Region
	;;-----
	cgDisplay, 800, 800
	pos	= [0., 0., 1., 1.]
	npix	= 1000L
	P_VRPerform_galandnode_draworg, part, bnd, pos, npix, /d3

	STOP
	P_VRPerform_galandnode_draworg, part, bnd, pos, npix, /d3, /zoom

	P_VRPerform_galandnode_drawnode, part, ln, bnd, /leaf
	P_VRPerform_galandnode_drawnode, part, sn, bnd, /split

	;;-----
	;; Arrange
	;;-----


	STOP
END
