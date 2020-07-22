	;; valid_kernel
	;;	valid_ct
	;; kernels
for i = 0, nkern-1 do begin

     
;    FIND VALID KERNELS
     valid_kernel_ind = where(valid_kernel, valid_ct)
     valid_kernels = kernels[valid_kernel_ind]

     if valid_ct gt 1 then begin

;       -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;       CALCULATE WHERE THE CURRENT KERNEL MERGES WITH REMAINING VALID
;       KERNELS
;       -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

        merges = merger_matrix_nodiag[order[i], valid_kernel_ind]
        merge_level = max(merges,/nan)
        if finite(merge_level) eq 0 then begin
  unique_lev = min(levels)        ;LJ
           mask = cube ge unique_lev       ;LJ
        endif else begin
           unique_lev = min(levels[where(levels gt merge_level)],/nan)
;          mask = cube gt merge_level
           ;mask = cube gt unique_lev
           mask = cube ge unique_lev        ;LJ
        endelse
        asgn = label_region(mask, /ULONG)
        stat_mask, asgn eq asgn[kernels[order[i]]] $
                   , volume=npixels, area=area, vwidth=vwidth

;       -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;       CHECK THE REJECTION CRITERIA FOR THE CURRENT KERNEL
;       -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

;       CONTRAST REJECTION
        if (kernel_value[order[i]]-merge_level) lt cutoff then begin
           delta_rejects = delta_rejects+1
           valid_kernel[order[i]] = 0
        endif

;       VOLUME REJECTION
        if npixels lt minpix then begin
           valid_kernel[order[i]] = 0
           volume_rejects = volume_rejects+1
        endif

;       VELOCITY WIDTH REJECTION
        if vwidth lt minvchan then begin
           valid_kernel[order[i]] = 0
           vchan_rejects = vchan_rejects+1
        endif

;       AREA REJECTION
        if area lt minarea then begin
           valid_kernel[order[i]] = 0
           area_rejects = area_rejects+1
        endif



     endif

  endfor  ; end loop over kernels
