subroutine qtest(h,i,j,k,shdswp,x,y,ntot,eps)

! Test whether the LOP is satisified; i.e. whether vertex j
! is outside the circumcircle of vertices h, i, and k of the
! quadrilateral.  Vertex h is the vertex being added; i and k are
! the vertices of the quadrilateral which are currently joined;
! j is the vertex which is ``opposite'' the vertex being added.
! If the LOP is not satisfied, then shdswp ("should-swap") is true,
! i.e. h and j should be joined, rather than i and k.  I.e. if j
! is outside the circumcircle of h, i, and k then all is well as-is;
! *don't* swap ik for hj.  If j is inside the circumcircle of h,
! i, and k then change is needed so swap ik for hj.
! Called by swap.

implicit double precision(a-h,o-z)
dimension :: x(-3:ntot), y(-3:ntot)
dimension :: ndi(1)
integer :: h
logical :: shdswp

! Set dummy integer for call to intpr(...).
ndi(1) = 0

! Look for ideal points.
if(i<=0) then
    ii = 1
else
    ii = 0
endif

if(j<=0) then
    jj = 1
else
    jj = 0
endif

if(k<=0) then
    kk = 1
else
    kk = 0
endif
ijk = ii*4+jj*2+kk

! All three corners other than h (the point currently being
! added) are ideal --- so h, i, and k are co-linear; so 
! i and k shouldn't be joined, and h should be joined to j.
! So swap.  (But this can't happen, anyway!!!)
! case 7:
if(ijk==7) then
    shdswp = .true.
    return
endif

! If i and j are ideal, find out which of h and k is closer to the
! intersection point of the two diagonals, and choose the diagonal
! emanating from that vertex.  (I.e. if h is closer, swap.)
! Unless swapping yields a non-convex quadrilateral!!!
! case 6:
if(ijk==6) then
    xh = x(h)
    yh = y(h)
    xk = x(k)
    yk = y(k)
    ss = 1 - 2*mod(-j,2)
    test = (xh*yk+xk*yh-xh*yh-xk*yk)*ss
    if(test>0.d0) then
        shdswp = .true.
    else
        shdswp = .false.
    endif
! Check for convexity:
    if(shdswp) call acchk(j,k,h,shdswp,x,y,ntot,eps)
    return
endif

! Vertices i and k are ideal --- can't happen, but if it did, we'd
! increase the minimum angle ``from 0 to more than 2*0'' by swapping ...
!
! 24/7/2011 --- I now think that the forgoing comment is misleading,
! although it doesn't matter since it can't happen anyway.  The
! ``2*0'' is wrong.  The ``new minimum angle would be min(alpha,beta)
! where alpha and beta are the angles made by the line joining h
! to j with (any) line with slope = -1.  This will be greater than
! 0 unless the line from h to j has slope = - 1.  In this case h,
! i, j, and k are all co-linear, so i and k should not be joined
! (and h and j should be) so swapping is called for.  If h, i,
! j and j are not co-linear then the quadrilateral is definitely
! convex whence swapping is OK.  So let's say swap.
! case 5:
if(ijk==5) then
    shdswp = .true.
    return
endif

! If i is ideal we'd increase the minimum angle ``from 0 to more than
! 2*0'' by swapping, so just check for convexity:
! case 4:
if(ijk==4) then
    call acchk(j,k,h,shdswp,x,y,ntot,eps)
    return
endif

! If j and k are ideal, this is like unto case 6.
! case 3:
if(ijk==3) then
    xi = x(i)
    yi = y(i)
    xh = x(h)
    yh = y(h)
    ss = 1 - 2*mod(-j,2)
    test = (xh*yi+xi*yh-xh*yh-xi*yi)*ss
    if(test>0.d0) then
        shdswp = .true.
    else
        shdswp = .false.
    endif
! Check for convexity:
    if(shdswp) call acchk(h,i,j,shdswp,x,y,ntot,eps)
    return
endif

! If j is ideal we'd decrease the minimum angle ``from more than 2*0
! to 0'', by swapping; so don't swap.
! case 2:
if(ijk==2) then
    shdswp = .false.
    return
endif

! If k is ideal, this is like unto case 4.
! case 1:
if(ijk==1) then
    call acchk(h,i,j,shdswp,x,y,ntot,eps) ! This checks
                                          ! for convexity.
                                          ! (Was i,j,h,...)
    return
endif

! If none of the `other' three corners are ideal, do the Lee-Schacter
! test for the LOP.
! case 0:
if(ijk==0) then
    call qtest1(h,i,j,k,x,y,ntot,eps,shdswp)
    return
endif

! default:  ! This CAN'T happen!
call intpr("Indicator ijk is out of range.",-1,ndi,0)
call intpr("This CAN'T happen!",-1,ndi,0)
call rexit("Bailing out of qtest.")
end subroutine qtest
