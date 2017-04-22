program main_KMC
use geometry
use search_arguments
use mtfort90
implicit none
integer(8):: d,L,Nitt,warmSteps,measureSteps
integer(8) :: NS,i,j,nn,itt,nDist
integer(8),dimension(:,:),allocatable :: geom,coord
integer(8),dimension(:),allocatable :: S!Vector de spins
real(8),dimension(:),allocatable :: pes!Gamma_{iT}
real(8) :: gamma_iT
real(8) :: r_c!radio de cut_off
real(8)::beta,E,M,T,E2

T = get_db_arg(1,2.0d0)
d = get_int_arg(2,int(2,8))
L = get_int_arg(3,int(20,8))
Nitt = get_int_arg(4,int(1d6,8))
warmSteps = get_int_arg(5,int(1d3,8))
measureSteps = get_int_arg(6,int(1,8))

!-------------------------------------------------------------------------------
!-----------------------------Inicializacion------------------------------------
!-------------------------------------------------------------------------------

NS = L**d!Numero de spins
nn = 2*d!Nearest neighbours
beta = 1/T!beta
nDist = ceiling(r_c**2)!Posibles distancias al cuadrado dentro de mi cut_off

allocate(geom(NS,nn))
allocate(coord(NS,d))
allocate(S(NS))
allocate(pes(nDist))


call geometry_compute(geom,coord,NS,L,d)!Inicializamos geometria

S = (/(nint(grnd()), i=1,NS)/)*2-1!Inicializamos spins (-1 o 1)
pes = (/(exp(-2.0d0*sqrt(dble(i))) ,i=1,nDist)/)
pes = pes
gamma_iT = 0
do i = 1, nDist, 1
  do j = i, nDist, 1
    if ( i**2+j**2<=r_c ) then
      gamma_iT = gamma_iT + pes(i**2+j**2)
    end if
  end do
end do
pes = pes/gamma_iT

do i = 1, NS,1
  print*,S(i)
enddo

contains

end program
