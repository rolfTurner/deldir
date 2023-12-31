subroutine circen(i,j,k,x0,y0,x,y,ntot,eps,collin)
! Find the circumcentre (x0,y0) of the triangle with
! vertices (x(i),y(i)), (x(j),y(j)), (x(k),y(k)).
! Called by qtest1, dirseg, dirout.

implicit double precision(a-h,o-z)
dimension :: x(-3:ntot), y(-3:ntot), xt(3), yt(3)
dimension :: indv(3) ! To facillitate a lucid error message.
dimension :: xtmp(1)
dimension :: ndi(1)
logical :: collin

! Set dummy integer for call to intpr(...).
ndi(1) = 0

! Get the coordinates.
xt(1) = x(i)
yt(1) = y(i)
xt(2) = x(j)
yt(2) = y(j)
xt(3) = x(k)
yt(3) = y(k)

! Check for collinearity
ijk = 0
call cross(xt,yt,ijk,cprd)
if(abs(cprd) < eps) then
    collin = .true.
else
    collin = .false.
endif

! Form the vector u from i to j, and the vector v from i to k,
! and normalize them.
a  = x(j) - x(i)
b  = y(j) - y(i)
c  = x(k) - x(i)
d  = y(k) - y(i)
c1 = sqrt(a*a+b*b)
c2 = sqrt(c*c+d*d)
a  = a/c1
b  = b/c1
c  = c/c2
d  = d/c2

! If the points are collinear, make sure that they're in the right
! order --- i between j and k.
if(collin) then
    alpha = a*c+b*d
! If they're not in the right order, bring things to
! a shuddering halt.
    if(alpha>0) then
        indv(1) = i
        indv(2) = j
        indv(3) = k
        call intpr("Point numbers:",-1,indv,3)
        xtmp(1) = alpha
        call dblepr("Test value:",-1,xtmp,1)
        call intpr("Points are collinear but in the wrong order.",-1,ndi,0)
        call rexit("Bailing out of circen.")
    endif
! Collinear, but in the right order; think of this as meaning
! that the circumcircle in question has infinite radius.
return
endif

! Not collinear; go ahead, make my circumcentre.  (First, form
! the cross product of the ***unit*** vectors, instead of the
! ``normalized'' cross product produced by ``cross''.)
crss = a*d - b*c
x0   = x(i) + 0.5*(c1*d - c2*b)/crss
y0   = y(i) + 0.5*(c2*a - c1*c)/crss

end subroutine circen
