subroutine dirout(dirsum,nadj,madj,x,y,ntot,nn,rw,eps)

! Output the description of the Dirichlet tile centred at point
! i for i = 1, ..., nn.  Do this in the original order of the
! points, not in the order into which they have been bin-sorted.
! Called by master.

implicit double precision(a-h,o-z)
dimension :: nadj(-3:ntot,0:madj), x(-3:ntot), y(-3:ntot)
dimension :: dirsum(nn,3), rw(4)
dimension :: ndi(1)
logical :: collin, intfnd, bptab, bptcd, rwu

! Set dummy integer for call to intpr(...).
ndi(1) = 0

! Note that at this point some Delaunay neighbours may be
! `spurious'; they are the corners of a `large' rectangle in which
! the rectangular window of interest has been suspended.  This
! large window was brought in simply to facilitate output concerning
! the Dirichlet tesselation.  They were added to the triangulation
! in the routine `dirseg' which ***must*** therefore be called before
! this routine (`dirout') is called.  (Likewise `dirseg' must be called
! ***after*** `delseg' and `delout' have been called.)

! Dig out the corners of the rectangular window.
xmin = rw(1)
xmax = rw(2)
ymin = rw(3)
ymax = rw(4)

do i = 1,nn
    area = 0.d0 ! Initialize the area of the ith tile to zero.
    nbpt = 0    ! Initialize the number of boundary points of
                ! the ith tile to zero.
    npt  = 0    ! Initialize the number of tile boundaries to zero.
    np   = nadj(i,0)

! Output the point number, its coordinates, and the number of
! its Delaunay neighbours == the number of boundary segments in
! its Dirichlet tile.
! For each Delaunay neighbour, find the circumcentres of the
! triangles on each side of the segment joining point i to that
! neighbour.
    !call dblepr("rw:",-1,rw,4)
    do j1 = 1,np
        j = nadj(i,j1)
        call pred(k,i,j,nadj,madj,ntot)
        call succ(l,i,j,nadj,madj,ntot)
        call circen(i,k,j,a,b,x,y,ntot,eps,collin)
        if(collin) then
            call intpr("Vertices of triangle are collinear.",-1,ndi,0)
            call rexit("Bailing out of dirout.")
        endif
        call circen(i,j,l,c,d,x,y,ntot,eps,collin)
        if(collin) then
            call intpr("Vertices of triangle are collinear.",-1,ndi,0)
            call rexit("Bailing out of dirout.")
        endif

! Increment the area of the current Dirichlet
! tile (intersected with the rectangular window) by applying
! Stokes' Theorem to the segment of tile boundary joining
! (a,b) to (c,d).  (Note that the direction is anti-clockwise.)
        call stoke(a,b,c,d,rw,tmp,sn,eps)
        area = area+sn*tmp

! If a circumcentre is outside the rectangular window, replace
! it with the intersection of the rectangle boundary with the
! line joining the two circumcentres.  Then output
! the number of the current Delaunay neighbour and
! the two circumcentres (or the points with which
! they have been replaced).
! Note: rwu = "right way up".
        xi = x(i)
        xj = x(j)
        yi = y(i)
        yj = y(j)
        if(yi .ne. yj) then
            slope = (xi - xj)/(yj - yi)
            rwu = .true.
        else
            slope = 0.d0
            rwu = .false.
        endif
        call dldins(a,b,slope,rwu,ai,bi,rw,intfnd,bptab,nedge)
        if(intfnd) then
            call dldins(c,d,slope,rwu,ci,di,rw,intfnd,bptcd,nedge)
            if(.not.intfnd) then
                call intpr("Line from midpoint to circumcenter",-1,ndi,0)
                call intpr("does not intersect rectangle boundary!",-1,ndi,0)
                call intpr("But it HAS to!!!",-1,ndi,0)
                call rexit("Bailing out of dirout.")
            endif
            if(bptab .and. bptcd) then
                xm = 0.5*(ai+ci)
                ym = 0.5*(bi+di)
                if(xmin<xm .and. xm<xmax .and. ymin<ym .and. ym<ymax) then
                    nbpt = nbpt+2
                    npt  = npt+1
                endif
            else
                npt = npt + 1
                if(bptab .or. bptcd) nbpt = nbpt+1
            endif
        endif
    enddo
    dirsum(i,1) = npt
    dirsum(i,2) = nbpt
    dirsum(i,3) = area
enddo

end subroutine dirout
