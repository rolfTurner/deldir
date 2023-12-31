subroutine dldins(a,b,slope,rwu,ai,bi,rw,intfnd,bpt,nedge)

! Get a point ***inside*** the rectangular window on the ray from
! one circumcentre to the next one.  I.e. if the `next one' is
! inside, then that's it; else find the intersection of this ray with
! the boundary of the rectangle.
! Called by dirseg, dirout.

implicit double precision(a-h,o-z)
dimension :: rw(4)
logical :: intfnd, bpt, rwu

! Note that (a,b) is the circumcentre of a Delaunay triangle,
! and that slope is the slope of the ray joining (a,b) to the
! corresponding circumcentre on the opposite side of an edge of that
! triangle.  When `dldins' is called by `dirout' it is possible
! for the ray not to intersect the window at all.  (The Delaunay
! edge between the two circumcentres might be connected to a `fake
! outer corner', added to facilitate constructing a tiling that
! completely covers the actual window.)  The variable `intfnd' acts
! as an indicator as to whether such an intersection has been found.

! The variable `bpt' acts as an indicator as to whether the returned
! point (ai,bi) is a true circumcentre, inside the window (bpt == .false.),
! or is the intersection of a ray with the boundary of the window
! (bpt = .true.).


intfnd = .true.
bpt = .true.

! Dig out the corners of the rectangular window.
xmin = rw(1)
xmax = rw(2)
ymin = rw(3)
ymax = rw(4)

! Check if (a,b) is inside the rectangle.
if(xmin<=a .and. a<=xmax .and. ymin<=b .and. b<=ymax) then
    ai = a
    bi = b
    bpt = .false.
    nedge = 0
    return
endif

! Look for appropriate intersections with the four lines forming
! the sides of the rectangular window.

! If not "the right way up" then the line joining the two
! circumcentres is vertical.

if(.not.rwu) then
    if(b < ymin) then
        ai = a
        bi = ymin
        nedge = 1
        if(xmin<=ai .and. ai<=xmax) return
    endif
    if(b > ymax) then
        ai = a
        bi = ymax
        nedge = 3
        if(xmin<=ai .and. ai<=xmax) return
    endif
    intfnd = .false.
    return
endif

! Line 1: x = xmin.
if(a<xmin) then
    ai = xmin
    bi = b + slope*(ai-a)
    nedge = 2
    if(ymin<=bi .and. bi<=ymax) return
endif

! Line 2: y = ymin.
if(b<ymin) then
    bi = ymin
    ai = a + (bi-b)/slope
    nedge = 1
    if(xmin<=ai .and. ai<=xmax) return
endif

! Line 3: x = xmax.
if(a>xmax) then
    ai = xmax
    bi = b + slope*(ai-a)
    nedge = 4
    if(ymin<=bi .and. bi<=ymax) return
endif

! Line 4: y = ymax.
if(b>ymax) then
    bi = ymax
    ai = a + (bi-b)/slope
    nedge = 3
    if(xmin<=ai .and. ai<=xmax) return
endif

intfnd = .false.
end subroutine dldins
