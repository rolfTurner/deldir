subroutine mnnd(x,y,n,dminbig,dminav)
!
! Mean nearest neighbour distance.  Called by .Fortran()
! from mnnd.R.
!
implicit double precision(a-h,o-z)
dimension :: x(n), y(n)

dminav = 0.d0
do i = 1,n
    dmin = dminbig
    do j = 1,n
        if(i .ne. j) then
            d = (x(i)-x(j))**2 + (y(i)-y(j))**2
            if(d < dmin) dmin = d
        endif
    enddo
    dminav = dminav + sqrt(dmin)
enddo

dminav = dminav/n

return
end
