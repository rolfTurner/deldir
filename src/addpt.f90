subroutine addpt(j,nadj,madj,x,y,ntot,eps,ntri,incAdj)
! Add point j to the triangulation.
! Called by master, dirseg.

implicit double precision(a-h,o-z)
dimension :: nadj(-3:ntot,0:madj), x(-3:ntot), y(-3:ntot)
logical :: didswp

! Put the new point in, joined to the vertices of its
! enclosing triangle.
call initad(j,nadj,madj,x,y,ntot,eps,ntri,incAdj)

! Look at each `gap', i.e. pair of adjacent segments
! emanating from the new point; they form two sides of a
! quadrilateral; see whether the extant diagonal of this
! quadrilateral should be swapped with its alternative
! (according to the LOP: local optimality principle).
now = nadj(j,1)
nxt = nadj(j,2)
ngap = 0

do
    call swap(j,now,nxt,didswp,nadj,madj,x,y,ntot,eps,incAdj)
    n = nadj(j,0)
    if(.not.didswp) then  ! If no swap of diagonals
        now  = nxt    ! move to the next gap.
        ngap = ngap+1
    endif
    call succ(nxt,j,now,nadj,madj,ntot)
    if(ngap==n) exit
enddo
end subroutine addpt
