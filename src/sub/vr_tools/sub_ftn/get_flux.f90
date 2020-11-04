!234567
      Subroutine get_flux(age, metal, mass, SSP_age, SSP_metal, SSP_wave, SSP_flux, &
           TR_wave, TR_curve, flux, int_set, dbl_set)

      use omp_lib
      implicit none
      integer(kind=4) :: int_set(20)
      integer(kind=4) :: i, j, k, l, m
      integer(kind=4) :: ind_a, ind_a2, ind_z, ind_z2, ind_a0
      real(kind=4) :: age(int_set(1)), metal(int_set(1))
      real(kind=8) :: mass(int_set(1)), flux(int_set(1))
      real(kind=4) :: SSP_age(int_set(2)), SSP_metal(int_set(3)), SSP_wave(int_set(4))
      real(kind=4) :: SSP_flux(int_set(3),int_set(4),int_set(2))
      real(kind=4) :: TR_wave(int_set(5)), TR_curve(int_set(5))
      real(kind=8) :: dbl_set(20)

      real(kind=4), allocatable :: R_SSP_TR(:), R_SSP_Lam(:), R_SSP_Fl(:)
      real(kind=4), allocatable :: DR_SSP_Lam(:)
      integer(kind=4) :: R_N_SSP

      integer(kind=4) :: N_part, N_SSP_age, N_SSP_met, N_SSP_wav, N_Tr
      integer(kind=4) :: Ext_ind2, num_thread

      real(kind=4) :: bi_int(6), frac(4)
      real(kind=8) :: flux_integration

      num_thread        = int_set(11)
      call omp_set_num_threads(num_thread)

      !!-----
      !! Header
      !!-----
      N_part = int_set(1) ; N_SSP_age = int_set(2) ; N_SSP_met = int_set(3)
      N_SSP_wav = int_set(4) ; N_Tr = int_set(5)
      !!-----
      !! Extract the wavelength range of interest
      !!-----

      call Ext_ind(SSP_wave, TR_wave, N_SSP_wav, N_Tr, ind_a, ind_z)
      R_N_SSP = ind_z - ind_a + 1 ; ind_a0 = ind_a

      !!-----
      !! Memory allocation for reduced SSP arrays
      !!-----
      allocate(R_SSP_TR(R_N_SSP)) ; allocate(R_SSP_Lam(R_N_SSP)) ; allocate(R_SSP_Fl(R_N_SSP))
      allocate(DR_SSP_Lam(R_N_SSP-1))

      do i=1, R_N_SSP
        R_SSP_Lam(i) = SSP_wave(ind_a - 1 + i)
      enddo

      do i=1, R_N_SSP-1
        DR_SSP_Lam(i) = R_SSP_Lam(i+1) - R_SSP_Lam(i)
      enddo

      !!-----
      !! Make a TR curve value at a wavelength value of SSP
      !!-----

      call Tr_interpolation(R_SSP_TR, R_SSP_LAM, R_N_SSP, TR_wave, TR_curve, N_Tr)

      !!-----
      !! Main Loop for ptcls
      !!-----

      !$OMP PARALLEL DO default(shared) private(ind_a, ind_a2, ind_z, ind_z2, bi_int, frac, R_SSP_Fl) schedule(static)
      do i=1, N_part
        !!!!-----
        !!!! Extract indices of metallicity and ages
        !!!!-----

        ind_z = Ext_ind2(SSP_metal, metal(i), N_SSP_met)
        ind_a = Ext_ind2(SSP_age, age(i), N_SSP_age)

          ind_a2 = ind_a
          if(ind_a .eq. 0) ind_a2 = 1
          if(ind_a .eq. N_SSP_age) ind_a2 = ind_a2 - 1

          ind_z2 = ind_z
          if(ind_z .eq. 0) ind_z2 = 1
          if(ind_z .eq. N_SSP_met) ind_z2 = ind_z - 1

        bi_int(4) = SSP_age(ind_a2) ; bi_int(5) = SSP_age(ind_a2 + 1) ; bi_int(6) = age(i)
        bi_int(1) = SSP_metal(ind_z2) ; bi_int(2) = SSP_metal(ind_z2 + 1) ; bi_int(3) = metal(i)

        if(bi_int(1) .eq. bi_int(3)) bi_int(3) = bi_int(3) + 1e-6

        !!!!-----
        !!!! Interpolation coefficients
        !!!!-----

        call BR_interpolation(bi_int, ind_z, N_SSP_met, frac)

        !!!!-----
        !!!! Find the corresponding flux table
        !!!!-----

        do j=1, R_N_SSP
          R_SSP_Fl(j) = 0.
          R_SSP_Fl(j) = (SSP_flux(ind_z2, ind_a0-1+j, ind_a2)*frac(2) + &
              SSP_flux(ind_z2+1, ind_a0-1+j, ind_a2)*frac(1))*frac(4) + &
              (SSP_flux(ind_z2, ind_a0-1+j, ind_a2+1)*frac(2) + &
              SSP_flux(ind_z2+1, ind_a0-1+j, ind_a2+1)*frac(1))*frac(3)
        enddo

        !!!!-----
        !!!! Integration
        !!!!-----

        do j=1, R_N_SSP
          R_SSP_Fl(j) = R_SSP_Fl(j) * R_SSP_Tr(j) * R_SSP_Lam(j) * mass(i)
        enddo

        flux(i) = flux_integration(R_SSP_Fl, DR_SSP_lam, R_N_SSP)
        !
        ! f_lambda / L_sun
        !

      enddo
      !$OMP END PARALLEL DO

      Return
      End Subroutine

!!!!!!!
!234567
      real(kind=8) function flux_integration(Y, DX, N)
      IMPLICIT NONE
      integer(kind=4) :: N, i
      real(kind=4) :: Y(N), Y2(N-1), DX(N-1)

      flux_integration = 0.
      do i=1, N-1
        Y2(i) = (Y(i+1) + Y(i))/2.
        flux_integration = flux_integration + Y2(i) * DX(i)
      enddo

      Return
      End
!!!!!!!
!234567
      Subroutine BR_interpolation(bi_int, ind_z, N_met, frac)
      IMPLICIT NONE
      real(kind=4) :: z0, z1, z2, t0, t1, t2, bi_int(6), frac(4)
      real(kind=4) :: t_frac(2), z_frac(2), dum
      integer(kind=4) :: ind_z, N_met

      z1 = bi_int(1) ; z2 = bi_int(2) ; z0 = bi_int(3)
      t1 = bi_int(4) ; t2 = bi_int(5) ; t0 = bi_int(6)

      dum = (t2 - t0) / (t0 - t1)
      t_frac(1) = 1./(1. + dum) ; t_frac(2) = dum/(1. + dum)

      if(ind_z .eq. 0 .or. ind_z .eq. N_met) then
        dum = (z2 - z0) / (z1 - z0)
        z_frac(1) = 1./(1. - dum) ; z_frac(2) = -dum/(1. - dum)
      else
        dum = (z2 - z0) / (z0 - z1)
        z_frac(1) = 1./(1. + dum) ; z_frac(2) = dum/(1. + dum)
      endif

      frac(1) = z_frac(1) ; frac(2) = z_frac(2)
      frac(3) = t_frac(1) ; frac(4) = t_frac(2)
      return
      End Subroutine

!!!!!!!
!234567
      integer(kind=4) function Ext_ind2(S_metal, metal, N_SSP)
      IMPLICIT NONE
      integer(kind=4) N_SSP 
      real(kind=4) S_metal(N_SSP), metal

      Ext_ind2 = 0
      if(S_metal(1) .gt. metal) then
        Ext_ind2 = 0
      elseif(S_metal(N_SSP) .lt. metal) then
        Ext_ind2 = N_SSP
      else
  40    Ext_ind2 = Ext_ind2 + 1
        if(S_metal(Ext_ind2) .lt. metal) goto 40
        Ext_ind2 = Ext_ind2 - 1
      endif

      return
      end

!!!!!!!
!234567
      Subroutine TR_interpolation(SSP_Tr, SSP_Lam, N_SSP, Tr_Lam, Tr_Tr, N_Tr)
      IMPLICIT NONE
      integer(kind=4) :: N_Tr, N_SSP, i, j, k, ind
      real(kind=4) :: SSP_Tr(N_SSP), SSP_Lam(N_SSP)
      real(kind=4) :: TR_Lam(N_Tr), Tr_Tr(N_Tr)
      real(kind=4) :: x1, x2, y1, y2, x0, y0, linear_int
      ind = 0
      do i=1, N_SSP
   30   ind = ind + 1
        if(TR_Lam(ind) .lt. SSP_Lam(i)) goto 30
        ind = ind - 1

        x1 = TR_Lam(ind) ; x2 = TR_Lam(ind+1) ; x0 = SSP_Lam(i)
        y1 = TR_Tr(ind) ; y2 = Tr_Tr(ind+1)

        y0 = linear_int(x1, x2, y1, y2, x0)
        SSP_Tr(i) = y0
        ind = ind - 1
      enddo

      Return
      End Subroutine

!!!!!!!
!234567
      real(kind=4) function linear_int(x1, x2, y1, y2, x0)
      real(kind=4) x1, x2, y1, y2, x0

      linear_int = y2 + (y1 - y2) * (x0 - x2) / (x1 - x2)

      return
      end

!!!!!!!
!234567
      Subroutine Ext_ind(SSP_wave, TR_wave, N_wave, N_tr, ind_a, ind_z)
      IMPLICIT NONE
      integer(kind=4) :: N_wave, N_tr, ind_a, ind_z
      real(kind=4) :: SSP_wave(N_wave), TR_wave(N_tr)

      ind_a = 0
   10 ind_a = ind_a + 1
      if(SSP_wave(ind_a) .lt. TR_wave(1)) goto 10

      ind_z = ind_a
   20 ind_z = ind_z + 1
      if(SSP_wave(ind_z) .lt. TR_wave(N_TR)) goto 20
      ind_z = ind_z - 1

      Return
      End Subroutine
