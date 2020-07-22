FUNCTION vr_test3_mpidom, settings, save=save

IF ~KEYWORD_SET(save) THEN BEGIN
	mpidom	= dblarr(8,3,2)

	mpidom(0,*,*) = [[0., 0., 0.], [0.4567966174, 1., 1.]]
        mpidom(1,*,*) = [[0.4567966174, 0., 0.], [1., 0.4583103528, 1.]]
        mpidom(2,*,*) = [[0.4567966174, 0.4583103528, 0.], [1., 1., 0.4574270698]]
        mpidom(3,*,*) = [[0.5194645217, 0.4583103528, 0.4574270698], [1., 1., 1.]]
        mpidom(4,*,*) = [[0.4567966174, 0.5380318172, 0.4574270698], [0.5194645217, 1., 1.]]
        mpidom(5,*,*) = [[0.4567966174, 0.4583103528, 0.5111587008], [0.5194645217, 0.5380318172, 1.]]
        mpidom(6,*,*) = [[0.4567966174, 0.4583103528, 0.4574270698], [0.4724672819, 0.5380318172, 0.5111587008]]
        mpidom(7,*,*) = [[0.4724672819, 0.4583103528, 0.4574270698], [0.5194645217, 0.5380318172, 0.5111587008]]

	rd_info, info, file='/storage5/FORNAX/KISTI_OUTPUT/c10006/output_00070/info_00070.txt'

	mpidom	= mpidom * info.unit_l / 3.08d21

	save, filename=settings.root_path + 'test/vr_test/test3*/mpidom.sav', mpidom
ENDIF ELSE BEGIN
	restore, settings.root_path + 'test/vr_test/test3*/mpidom.sav'
ENDELSE

RETURN, mpidom

END
