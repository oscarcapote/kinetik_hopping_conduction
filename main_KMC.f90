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
real(8),dimension(:),allocatable :: phi
real(8) :: gamma_iT,p_c
real(8) :: r_c!radio de cut_off
real(8)::beta,E,M,T,E2,W,EField,P,DeltaE,h_j,time,Dt,P2

T = get_db_arg(1,2.0d0)
W = get_db_arg(2,1.0d0)!Valor que acotara el potencial aletorio
r_c = get_db_arg(3,10.0d0)
d = 2
L = get_int_arg(4,int(100,8))
Nitt = get_int_arg(5,int(1000,8))
measureSteps = get_int_arg(6,int(1,8))
EField = T/10
p_c = exp(-2.0d0*r_c)
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
coord = coord+1

S = (/(nint(grnd()), i=1,NS)/)*2-1!Inicializamos spins (-1 o 1)
phi = (/(grnd(), i=1,NS)/)*2*W-W!Inicializamos potencial aleatorio
time = 0.0d0

!Calculamos probabilidades de transicion
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
  end do
  gamma_iT = sum(pes(i,:))
  pes(i,:) = pes(i,:)/gamma_iT
end do

!Calculamos energia y polarizacion
call hamiltonian_polarization(S,phi,EField,coord,geom,NS,E,P)
print*,t,E,P

!Empezamos iteraciones
do itt=1,Nitt
  !Miro cuando habrá un salto
  Dt  = -log(grnd())/gamma_iT
  t = t+Dt
  call MC_step()
  E = E +DeltaE
  P = P - 2*(Dx)

  if ( mod(itt,measureSteps).eq.0 ) then!Cada measureSteps mido
    print*,t,E,P
  end if
enddo


contains

subroutine hamiltonian_polarization(S,phi,EField,coord,geom,NS,E,P)
      integer(8),dimension(:,:):: geom,coord
      integer(8),dimension(:):: S!Vector de spins
      real(8),dimension(:):: phi
      real(8) :: E,EField,ESpin,P
      integer(8) :: NS
      integer(8) :: i,j

      E = 0.0d0
      P = 0.0d0
      ESpin = 0.0d0

      do i=1,NS,1
        do j = 1, 4, 1
          ESpin = ESpin+dble(S(i)*S(geom(i,j)))
        end do
        P = P + coord(i,1)*S(i)
        E = E+phi(i)*S(i)
      enddo
      E = E+ESpin*0.5d0-EField*P
endsubroutine

function tower(pes) result(mu)
  real(8),dimension(:) :: pes
  integer(8) :: mu
  real(8) :: suma,rnd
  mu = 1!Reaccio qua pasara
  rnd = grnd()
  suma =pes(mu)
  !print*,'Probabilitats',Pr
  do while(rnd>suma)
      mu = mu+1
      suma = suma+pes(mu)
  enddo
end function

subroutine MC_step()
  !Seleccionamos celda ocupada al azar
  do
    i = floor(grnd()*NS)+1
    if ( S(i)==1 ) then
      exit
    end if
  enddo

  !Seleccionmos al azar, una celda con distribucion exponencial
  j = tower(pes(i,:))
  !Si esta lleno, pasamos a la siguiente iteracion
  if ( S(j)==1.or.pes(i,j).le.p_c ) then
    DeltaE = 0.0d0
    Dx = 0.0d0
    return
  end if
  Dx = coord(i,1)-coord(j,1)
  Dx = Dx-nint(dble(Dx)/dble(L))*L

  !Calculamos variacion de energí con cuidado que si i y j son
  !primeros vecinos en la parte interaccion de primeros vecinos
  !su interaccion no afectara al cambio de energia
  DeltaE = 0.0d0
  h_j = 0.0d0
  do nn = 1, 4, 1
    if(geom(i,nn)==j)then
      cycle
    endif
    h_j = h_j + S(geom(i,nn))
  end do
  DeltaE = -h_j

  h_j = 0.0d0
  do nn = 1, 4, 1
    if(geom(j,nn)==i)then
      cycle
    endif
    h_j = h_j + S(geom(j,nn))
  end do
  DeltaE = DeltaE +h_j
  DeltaE = 2.0d0*(DeltaE +phi(j)-phi(i)+EField*(Dx))!-2*(coord(i,1)-coord(j,1))*EField+E2

  !Metropolis
  if(DeltaE<0.0d0)then
      S(i) = -S(i)
      S(j) = -S(j)
  else if(grnd().le.exp(-beta*DeltaE))then
      S(i) = -S(i)
      S(j) = -S(j)
  else
    DeltaE = 0.0d0
    DX = 0.0d0
  endif


endsubroutine

end program
