PRO vr_test5_rdvr, settings, vr, g1, n_snap=n_snap, save=save

IF(~KEYWORD_SET(save)) THEN BEGIN
        vr      = f_rdgal(settings, 21L, [Settings.column_list, 'ABmag', 'SFR'])
        g1      = f_rdptcl(vr.id(2321), $
                /p_pos, /p_vel, /p_gyr, /p_sfactor, /p_mass, /p_flux, /p_metal, $
                flux_list=settings.flux_list, $
                dir_lib=settings.dir_lib, $
                dir_raw=settings.dir_raw, $
                dir_save=settings.dir_save, $
                num_thread=settings.num_thread, $
                n_snap=21L, /longint)
        save, filename=settings.root_path + 'test/vr_test/test5*/vr.sav', vr, g1
ENDIF ELSE BEGIN
        restore, settings.root_path + 'test/vr_test/test5*/vr.sav'
ENDELSE

END
