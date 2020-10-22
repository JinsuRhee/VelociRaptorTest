FUNCTION js_binmatch, base, comp

	match	= LONARR(N_ELEMENTS(base)) - 1L

	sort_ind	= SORT(comp)
	sort_comp	= comp(sort_ind)
	min_comp	= sort_comp(0)
	max_comp	= sort_comp(-1)

	nn	= N_ELEMENTS(comp)
	FOR i=0L, N_ELEMENTS(base)-1L DO BEGIN
		IF base(i) LT min_comp THEN CONTINUE
		IF base(i) GT max_comp THEN CONTINUE

		n0	= nn
		ind_i	= 0L
		ind_f	= nn-1L
		REPEAT BEGIN
			ind_m	= (ind_i + ind_f)/2

			IF base(i) GT sort_comp(ind_m) THEN BEGIN
				ind_i	= ind_m + 1
				n0	= ind_f - ind_i
			ENDIF ELSE IF base(i) LT sort_comp(ind_m) THEN BEGIN
				ind_f = ind_m - 1
				n0	= ind_f - ind_i
			ENDIF ELSE BEGIN
				match(i)	= sort_ind(ind_m)
				n0	= -1
			ENDELSE
		ENDREP UNTIL n0 LT 10

		IF n0 GE 0L THEN $
			FOR j=ind_i, ind_f DO $
				IF base(i) EQ sort_comp(j) THEN match(i) = sort_ind(j)
	ENDFOR

	RETURN, match

END
