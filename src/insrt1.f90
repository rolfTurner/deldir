subroutine insrt1(i,j,kj,nadj,madj,ntot,incAdj)

! Insert j into the adjacency list of i.
! Called by insrt.

implicit double precision(a-h,o-z)
dimension :: nadj(-3:ntot,0:madj)

! Initialise incAdj.
incAdj = 0

! Variable  kj is the index which j ***will***
! have when it is inserted into the adjacency list of i in
! the appropriate position.

! If the adjacency list of i had no points just stick j into the list.
n = nadj(i,0)
if(n==0) then
    nadj(i,0) = 1
    nadj(i,1) = j
    return
endif

! If the adjacency list had some points, move everything ahead of the
! kj-th place one place forward, and put j in position kj.
kk = n+1

if(kk>madj) then ! Watch out for over-writing!!!
    incAdj = 1
    return
endif

do
    nadj(i,kk) = nadj(i,kk-1)
    kk = kk-1
    if(kk <= kj) exit
enddo

nadj(i,kj) = j
nadj(i,0)  = n+1

end subroutine insrt1
