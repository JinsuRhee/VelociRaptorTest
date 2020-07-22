FUNCTION vr_test3_domread, settings, save=save


IF ~KEYWORD_SET(save) THEN BEGIN
	readcol, settings.root_path + 'test/vr_test/test3*/logfile.log', $
		Nmpi, Nptcl, x1, x2, format='L, L, D, D', $
		numline=file_lines(settings.root_path + 'test/vr_test/test3*/logfile.log')

        FOR i=0L, 7L DO BEGIN
                cut     = where(Nmpi EQ i)
                Npt     = Nptcl(cut(0))
                Nompdom = n_elements(cut) / 3L

                bdn     = dblarr(Nompdom,3,2)
                dx1     = x1(cut)
                dx2     = x2(cut)
                FOR j=0L, Nompdom-1L DO BEGIN
                        ind     = 3*j
                        bdn(j,0,*) = [dx1(ind), dx2(ind)]
                        bdn(j,1,*) = [dx1(ind+1), dx2(ind+1)]
                        bdn(j,2,*) = [dx1(ind+2), dx2(ind+2)]
                ENDFOR

                dum     = {bdn:bdn, Nompdom:Nompdom, Npt:Npt}

                if i eq 0L then domain = create_struct('a' + string(i,format='(I1.1)'), dum)
                if i ge 1L then domain = create_struct(domain, 'a' + string(i,format='(I1.1)'), dum)
        ENDFOR

	save, filename=settings.root_path + 'test/vr_test/test3*/domain.sav', domain
ENDIF ELSE BEGIN
	restore, settings.root_path + 'test/vr_test/test3*/domain.sav'
ENDELSE

RETURN, domain

END
