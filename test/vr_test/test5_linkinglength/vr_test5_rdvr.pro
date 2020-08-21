PRO vr_test5_rdvr, settings, vr, g1, g1_raw, n_snap=n_snap, save=save

IF(~KEYWORD_SET(save)) THEN BEGIN
        vr      = f_rdgal(settings, n_snap, [Settings.column_list, 'ABmag', 'SFR'])
	id	= where(vr.mass_tot eq max(vr.mass_tot))
        g1      = f_rdptcl(settings, vr.id(id), $
                /p_pos, /p_vel, /p_gyr, /p_sfactor, /p_mass, /p_flux, /p_metal, $
                flux_list=settings.flux_list, $
                num_thread=settings.num_thread, $
                n_snap=n_snap, /longint)

        g1_raw  = f_rdptcl(settings, vr.id(id), $
                /p_pos, /p_vel, /p_gyr, /p_sfactor, /p_mass, /p_flux, /p_metal, $
                flux_list=settings.flux_list, $
                num_thread=settings.num_thread, $
                n_snap=n_snap, /longint, /raw)



        save, filename=settings.root_path + 'test/vr_test/test5*/vr.sav', vr, g1, g1_raw
ENDIF ELSE BEGIN
        restore, settings.root_path + 'test/vr_test/test5*/vr.sav'
ENDELSE

END
