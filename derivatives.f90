program derivada
  integer(8) :: i,j,istat,nLines
  real(8), dimension(:), allocatable :: T,P,dP
  real(8):: dummy


  open(unit=100, file='EP.dat', iostat=istat)
  nLines = 0
  if ( istat /= 0 ) stop "Error opening file "
  do
    read(unit=100,fmt = *, iostat=istat) dummy
    if ( istat < 0 )then
         exit
    endif
    nLines = nLines +1
  end do
  close(unit=100, iostat=istat)


  allocate(T(nLines))
  allocate(P(nLines))
  allocate(dP(nLines-2))
  open(unit=100, file='EP.dat', iostat=istat)
  if ( istat /= 0 ) stop "Error opening file "
  do i=1,nLines,1
    read(unit=100,fmt = *, iostat=istat) T(i),dummy,P(i)
  end do
  close(unit=100, iostat=istat)

  do i = 2, nLines-1, 1
    dP(i-1) = (P(i+1)-P(i-1))/(T(i+1)-T(i-1))
    print*, T(i),dP(i-1)
  end do

contains
end program
