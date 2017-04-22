module geometry

implicit none

contains

subroutine geometry_compute(geom,coord,NS,L,d)
    !Subrutina que me da los primeros vecinos de una red cubica d-diensoinal
    !Tambien e quedo con las cooerdenadas de cada spin
    integer(8), dimension(:,:), intent(inout) :: geom,coord
    integer(8), intent(in) :: NS,L,d
    integer(8),dimension(d) :: indexs,tmp_indexs
    integer(8),dimension(d+1) :: powers
    integer(8) :: i,j,k

    powers = (/ (L**i,i=0,d) /) !Potencias de la longitud carcteristica

    do i=1,NS
        call coordinates(d,indexs,powers,i)!Calculo mis punteros (vector indexs)
        coord(i,:) = indexs
        tmp_indexs = indexs
        do j=1,d
            !Empiezo por los vecinos de delante
            indexs = tmp_indexs
            indexs(j) = mod(indexs(j)+1,L)
            geom(i,j) = 1
            geom(i,j+d) = 1
            do k=1,d
                !Calculo el hipervolumen forward
                geom(i,j) =geom(i,j) + indexs(k)*powers(k)
            enddo
            !Acabo por los de detreas
            indexs = tmp_indexs
            indexs(j) = mod(indexs(j)-1+L,L)
            do k=1,d
                !Calculo el hipervolumen backward
                geom(i,j+d) = geom(i,j+d)+ indexs(k)*powers(k)
            enddo
        enddo
    enddo
end subroutine

subroutine coordinates(d,indexs,powers,j)
    !Busca coordenadas del spin j, es decir los punteros
    integer(8),dimension(:) :: indexs
    integer(8),dimension(:) :: powers
    integer(8), intent(in) :: d
    integer(8) :: i,j,k

    indexs(d) = (j-1)/(powers(d))!powers(d) = L**(d-1)
    k = j
    do i=d-1,1,-1
        k = k - indexs(1+i)*powers(i+1)
        indexs(i) = (k-1)/(powers(i))
    enddo
end subroutine

end module
