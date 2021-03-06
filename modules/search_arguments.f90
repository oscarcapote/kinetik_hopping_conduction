module search_arguments
implicit none
contains
integer(8) function get_int_arg(posArg,defecto)
    !Funcion que coge el argumento i esimo y la convierte en un integer
    character(30) :: arg
    integer(8) :: defecto
    integer :: posArg
    call get_command_argument(posArg,arg)
    if(arg=='')then
        get_int_arg = defecto
    else
        read(arg,*) get_int_arg
    endif
end function

real(8) function get_db_arg(posArg,defecto)
    !Funcion que coge el argumento i esimo y la convierte en un dp
    character(30) :: arg
    real(8) :: defecto
    integer :: posArg
    call get_command_argument(posArg,arg)
    if(arg=='')then
        get_db_arg = defecto
    else
        read(arg,*) get_db_arg
    endif
end function

end module
