subroutine stoke(x1,y1,x2,y2,rw,area,s1,eps)

! Apply Stokes' theorem to find the area of a polygon;
! we are looking at the boundary segment from (x1,y1)
! to (x2,y2), travelling anti-clockwise.  We find the
! area between this segment and the horizontal base-line
! y = ymin, and attach a sign s1.  (Positive if the
! segment is right-to-left, negative if left to right.)
! The area of the polygon is found by summing the result
! over all boundary segments.

! Just in case you thought this wasn't complicated enough,
! what we really want is the area of the intersection of
! the polygon with the rectangular window that we're using.

! Called by dirout.

implicit double precision(a-h,o-z)
dimension :: rw(4)
dimension :: ndi(1)
logical :: value

! Set dummy integer for call to intpr(...).
ndi(1) = 0

zero   = 0.d0

! If the segment is vertical, the area is zero.
call testeq(x1,x2,eps,value)
if(value) then
    area = 0.d0
    s1   = 0.d0
    return
endif

! Find which is the right-hand end, and which is the left.
if(x1<x2) then
    xl = x1
    yl = y1
    xr = x2
    yr = y2
    s1 = -1.d0
else
    xl = x2
    yl = y2
    xr = x1
    yr = y1
    s1 = 1.d0
endif

! Dig out the corners of the rectangular window.
xmin = rw(1)
xmax = rw(2)
ymin = rw(3)
ymax = rw(4)

! Now start intersecting with the rectangular window.
! Truncate the segment in the horizontal direction at
! the edges of the rectangle.
slope = (yl-yr)/(xl-xr)
x  = max(xl,xmin)
y  = yl+slope*(x-xl)
xl = x
yl = y

x  = min(xr,xmax)
y  = yr+slope*(x-xr)
xr = x
yr = y

if(xr<=xmin .or. xl>=xmax) then
    area = 0.d0
    return
endif

! We're now looking at a trapezoidal region which may or may
! not protrude above or below the horizontal strip bounded by
! y = ymax and y = ymin.
ybot = min(yl,yr)
ytop = max(yl,yr)

! Case 1; ymax <= ybot:
! The `roof' of the trapezoid is entirely above the
! horizontal strip.
if(ymax<=ybot) then
    area = (xr-xl)*(ymax-ymin)
    return
endif

! Case 2; ymin <= ybot <= ymax <= ytop:
! The `roof' of the trapezoid intersects the top of the
! horizontal strip (y = ymax) but not the bottom (y = ymin).
if(ymin<=ybot .and. ymax<=ytop) then
    call testeq(slope,zero,eps,value)
    if(value) then
        w1 = 0.d0
        w2 = xr-xl
    else
        xit = xl+(ymax-yl)/slope
        w1 = xit-xl
        w2 = xr-xit
        if(slope<0.d0) then
            tmp = w1
            w1  = w2
            w2  = tmp
        endif
    endif
    area = 0.5*w1*((ybot-ymin)+(ymax-ymin))+w2*(ymax-ymin)
    return
endif

! Case 3; ybot <= ymin <= ymax <= ytop:
! The `roof' intersects both the top (y = ymax) and
! the bottom (y = ymin) of the horizontal strip.
if(ybot<=ymin .and. ymax<=ytop) then
    xit = xl+(ymax-yl)/slope
    xib = xl+(ymin-yl)/slope
    if(slope>0.d0) then
            w1 = xit-xib
            w2 = xr-xit
    else
        w1 = xib-xit
        w2 = xit-xl
    endif
    area = 0.5d0*w1*(ymax-ymin)+w2*(ymax-ymin)
    return
endif

! Case 4; ymin <= ybot <= ytop <= ymax:
! The `roof' is ***between*** the bottom (y = ymin) and
! the top (y = ymax) of the horizontal strip.
if(ymin<=ybot .and. ytop<=ymax) then
    area = 0.5d0*(xr-xl)*((ytop-ymin)+(ybot-ymin))
    return
endif

! Case 5; ybot <= ymin <= ytop <= ymax:
! The `roof' intersects the bottom (y = ymin) but not
! the top (y = ymax) of the horizontal strip.
if(ybot<=ymin .and. ymin<=ytop) then
    call testeq(slope,zero,eps,value)
    if(value) then
        area = 0.
        return
    endif
    xib = xl+(ymin-yl)/slope
    if(slope>0.d0) then
        w = xr-xib
    else
        w = xib-xl
    endif
    area = 0.5*w*(ytop-ymin)
    return
endif

! Case 6; ytop <= ymin:
! The `roof' is entirely below the bottom (y = ymin), so
! there is no area contribution at all.
if(ytop<=ymin) then
        area = 0.
        return
endif

! Default; all stuffed up:
call intpr("Fell through all six cases.",-1,ndi,0)
call intpr("Something is totally stuffed up!",-1,ndi,0)
call intpr("Chaos and havoc in stoke.",-1,ndi,0)
call rexit("Bailing out of stoke.")
end subroutine stoke
