program main_KMC
use geometry
use search_arguments
use mtfort90
implicit none
integer(8):: d,L,Nitt,warmSteps,measureSteps
integer(8) :: NS,i,j,nn,itt,Dx,Dy
integer(8),dimension(:,:),allocatable :: geom,coord
integer(8),dimension(:),allocatable :: S!Vector de spins
real(8),dimension(:,:),allocatable :: pes!Gamma_{iT}
real(8),dimension(:),allocatable :: phi!Gamma_{iT}
real(8) :: gamma_iT
real(8) :: r_c!radio de cut_off
real(8)::beta,E,M,T,E2,W

T = get_db_arg(1,2.0d0)
d = get_int_arg(2,int(2,8))
L = get_int_arg(3,int(3,8))
Nitt = get_int_arg(4,int(1d6,8))
warmSteps = get_int_arg(5,int(1d3,8))
measureSteps = get_int_arg(6,int(1,8))
W = 1.0d0!Valor que acotara el potencial aletorio
r_c = 10

!-------------------------------------------------------------------------------
!-----------------------------Inicializacion------------------------------------
!-------------------------------------------------------------------------------

NS = L**d!Numero de spins
nn = 2*d!Nearest neighbours
beta = 1/T!beta

allocate(geom(NS,nn))
allocate(coord(NS,d))
allocate(S(NS))
allocate(phi(NS))
allocate(pes(NS,NS))


call geometry_compute(geom,coord,NS,L,d)!Inicializamos geometria

S = (/(nint(grnd()), i=1,NS)/)*2-1!Inicializamos spins (-1 o 1)
phi = (/(grnd(), i=1,NS)/)*2*W-W!Inicializamos potencial aleatorio
gamma_iT = 0
do i = 1, NS
  do j = 1, NS
    if(i==j)then
      pes(i,j) =0.0d0
      cycle
    endif
    Dx = coord(i,1)-coord(j,1)
    Dy = coord(i,2)-coord(j,2)
    Dx = Dx-nint(dble(Dx)/dble(L))*L
    Dy = Dy-nint(dble(Dy)/dble(L))*L
    pes(i,j) = exp(-2*sqrt(Dx**2.0d0+Dy**2.0d0))
    print*,i,j,  pes(i,j)
  end do
  pes(i,:) = pes(i,:)/sum(pes(i,:))
end do
do i = 1,NS
  print*,i,pes(i,:)
    print*,i,phi(i)
enddo
contains

!function hamiltonian(S,phi,x)
!
!endfunction
end program
