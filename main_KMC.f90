program main_KMC
use geometry
use search_arguments
use mtfort90
implicit none
integer(8):: d,L,Nitt,warmSteps,measureSteps
integer(8) :: NS,i,nn,itt
integer(8),dimension(:,:),allocatable :: geom
integer(8),dimension(:),allocatable :: S!Vector de spins
!real(8),dimension(:,:),allocatable :: pes
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
allocate(geom(NS,nn))
allocate(S(NS))
!allocate(pes(-1:1,-2*d:2*d))

call geometry_compute(geom,NS,L,d)!Inicializamos geometria

S = (/(nint(grnd()), i=1,NS)/)!Inicializamos spins (0 o 1)



contains

end program
