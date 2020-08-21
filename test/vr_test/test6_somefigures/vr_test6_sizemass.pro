PRO vr_test6_sizemass, settings, GAL, eps=eps

                IF eps EQ 1L THEN $
                        cgPS_open, settings.root_path + 'test/vr_test/test6*/sizemass.eps', /encapsulated
                dsize   = [800., 800.]
                cgDisplay, dsize(0), dsize(1)
                !p.font = -1 & !p.charsize=1.5 & !p.color=255B

                xr      = [6.5, 12.]
                yr      = [-2., 2.]
                pos     = [0.1, 0.1, 0.9, 0.9]
                cgPlot, 0., 0., /nodata, xrange=xr, yrange=yr, position=pos, xstyle=4, ystyle=4

                ;;;;;
                cut     = WHERE(GAL.structuretype GE 0L)
                mgal    = GAL.Mass_tot(cut)
                strtype = GAL.structuretype(cut)
                rsize   = GAL.r_halfmass(cut)

                js_denmap, ALOG10(mgal), ALOG10(rsize), DBLARR(N_ELEMENTS(mgal)) + 10.0d, $
                        xrange=xr, yrange=yr, n_pix=500L, num_thread=settings.num_thread, $
                        kernel=1L, mode=1L, ctable=33B, position=pos, dsize=800., $
                        /logscale, dr=[0.0, 2.0], symsize=0.5;, bandwidth=[0.02, 0.02]

                cgAxis, xaxis=0, xstyle=1, xrange=xr, $
                        xticks=6L, xtickv=['7', '8', '9', '10', '11', '12'], $
                        xtitle='log (Mass / Msun)', /save
                cgAxis, xaxis=1, xstyle=1, xrange=xr, xticks=6L, $
                        xtickv=['7', '8', '9', '10', '11', '12'], xtickn=REPLICATE(' ', 6L), /save
                cgAxis, yaxis=0, ystyle=1, xrange=yr, $
                        yticks=4L, ytickv=['-2', '-1', '0', '1', '2'], $
                        ytitle='log (HalfMass / Kpc)', /save
                cgAxis, yaxis=1, ystyle=1, yrange=yr, yticks=4L, $
                        ytickv=['-2', '-1', '0', '1', '2'], ytickn=REPLICATE(' ', 5L), /save
                IF KEYWORD_SET(eps) THEN $
                        cgPS_close



                IF eps EQ 1L THEN $
                        cgPS_open, settings.root_path + 'test/vr_test/test6*/sizemass_gal.eps', /encapsulated
                dsize   = [800., 800.]
                cgDisplay, dsize(0), dsize(1)
                !p.font = -1 & !p.charsize=1.5 & !p.color=255B

                xr      = [6.5, 12.]
                yr      = [-2., 2.]
                pos     = [0.1, 0.1, 0.9, 0.9]
                cgPlot, 0., 0., /nodata, xrange=xr, yrange=yr, position=pos, xstyle=4, ystyle=4

                ;;;;;
                cut     = WHERE(GAL.structuretype GE 10L)
                mgal    = GAL.Mass_tot(cut)
                strtype = GAL.structuretype(cut)
                rsize   = GAL.r_halfmass(cut)

                js_denmap, ALOG10(mgal), ALOG10(rsize), DBLARR(N_ELEMENTS(mgal)) + 10.0d, $
                        xrange=xr, yrange=yr, n_pix=500L, num_thread=settings.num_thread, $
                        kernel=1L, mode=1L, ctable=33B, position=pos, dsize=800., $
                        /logscale, dr=[0.0, 2.0], symsize=0.5;, bandwidth=[0.02, 0.02]

                cgAxis, xaxis=0, xstyle=1, xrange=xr, $
                        xticks=6L, xtickv=['7', '8', '9', '10', '11', '12'], $
                        xtitle='log (Mass / Msun)', /save
                cgAxis, xaxis=1, xstyle=1, xrange=xr, xticks=6L, $
                        xtickv=['7', '8', '9', '10', '11', '12'], xtickn=REPLICATE(' ', 6L), /save
                cgAxis, yaxis=0, ystyle=1, xrange=yr, $
                        yticks=4L, ytickv=['-2', '-1', '0', '1', '2'], $
                        ytitle='log (HalfMass / Kpc)', /save
                cgAxis, yaxis=1, ystyle=1, yrange=yr, yticks=4L, $
                        ytickv=['-2', '-1', '0', '1', '2'], ytickn=REPLICATE(' ', 5L), /save
                IF KEYWORD_SET(eps) THEN $
                        cgPS_close












END
