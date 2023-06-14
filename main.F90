program mpi_ring
    use mpi
    implicit none

    integer ( kind = 4 ):: error
    integer ( kind = 4 ):: ierr
    integer ( kind = 4 ):: message
    integer ( kind = 4 ):: my_id
    integer ( kind = 4 ):: num_procs
    integer ( kind = 4 ):: num_rounds
    integer ( kind = 4 ):: round
    integer ( kind = 4 ):: source
    integer ( kind = 4 ):: dest
    double precision :: t1, t2
    integer:: conv_error

    character(len=128) :: my_var
    call get_environment_variable('num_rounds', my_var)
    read(my_var, *, iostat=conv_error) num_rounds


    call MPI_Init(error)
    call MPI_Comm_size(MPI_COMM_WORLD, num_procs, error)
    call MPI_Comm_rank(MPI_COMM_WORLD, my_id, error)


    if(my_id.eq.0) print*,'num_rounds = ', num_rounds


    message = -1

    if (my_id == 0) then
        message = my_id
        t1 = MPI_Wtime()
       
        do round = 1, num_rounds
            call MPI_Send(message, 1, MPI_INTEGER, my_id+1, round, MPI_COMM_WORLD, error)
            call MPI_Recv(message, 1, MPI_INTEGER, num_procs-1, round, MPI_COMM_WORLD, MPI_STATUS_IGNORE, error)
        enddo

        t2 = MPI_Wtime()
    else
        do round = 1, num_rounds
            call MPI_Recv(message, 1, MPI_INTEGER, my_id-1, round, MPI_COMM_WORLD, MPI_STATUS_IGNORE, error)
            message = my_id

            if (my_id < num_procs - 1) then
                dest = my_id + 1
            else
                dest = 0
            end if
            call MPI_Send(message, 1, MPI_INTEGER, dest, round, MPI_COMM_WORLD, error)
        end do
    end if

    call MPI_Barrier(mpi_comm_world,ierr)
    if(my_id.eq.0) print*,'Done!!!'
    if(my_id.eq.0) print *, "Time taken for ", num_rounds, " rounds: ", t2-t1, " secs"
    call MPI_Finalize(ierr)
end program mpi_ring

