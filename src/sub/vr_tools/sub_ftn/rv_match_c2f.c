#include <stdio.h>

typedef struct {
   unsigned short slen;         /* length of the string         */
   short stype;                 /* Type of string               */
   char *s;                     /* Pointer to chararcter array  */
} STRING;

#define STR_LEN(__str)    ((long)(__str)->slen)

void rv_match(int argc, void *argv[])
{
  extern void rv_match_();   /* FORTRAN routine */
  long long *id;
  long *ind_b, *ind_u;
  double *xp, *vp, *zp, *ap, *mp;
  long *dom_list;

  STRING *dir_raw; 
  int *larr;
  double *darr;

  larr		= (int *) argv[0];
  darr		= (double *) argv[1];

  dir_raw	= (STRING *) argv[2];
  id		= (long long *) argv[3];
  ind_b		= (long *) argv[4];
  ind_u		= (long *) argv[5];
  xp		= (double *) argv[6];
  vp		= (double *) argv[7];
  zp		= (double *) argv[8];
  ap		= (double *) argv[9];
  mp		= (double *) argv[10];
  dom_list	= (long *) argv[11];

  //printf("%s", dir_raw->s);

  rv_match_(larr, darr, dir_raw->s, id, ind_b, ind_u, xp, vp, zp, ap, mp, dom_list);   /* Compute sum */
}
