module lib
contains
    subroutine get_mean_mode_in_string_int_col(load_data, col, min_val, max_val, mean, mode)
        implicit none

        ! Arguments
        character(*), dimension(:, :), intent(in) :: load_data
        integer, intent(in) :: col, min_val, max_val

        ! Return values
        double precision, intent(out) :: mean, mode

        ! Variables
        character(:), dimension(:), allocatable :: char_age_list
        integer :: count = 0, idx = 0, int_val
        integer, dimension(min_val:max_val) :: map
        integer :: tmp(1)

        ! Extract column
        char_age_list = load_data(:, col)

        ! Set counter to 0
        map = 0

        ! Get mean/mode
        mean = 0
        do idx = 1, size(char_age_list)
            read (char_age_list(idx), "(i20)") int_val
            count = count + 1
            mean = mean + int_val
            map(int_val) = map(int_val) + 1
        end do

        ! Set return values
        mean = mean/count
        tmp = maxloc(map)
        mode = tmp(1) - 1 + min_val

    end subroutine get_mean_mode_in_string_int_col

    subroutine quicksort(a, lo, hi)
        implicit none
        integer, intent(inout) :: a(:)
        integer, intent(in) :: lo, hi
        integer :: stack(hi - lo + 1)
        integer :: top, l, h, p

        top = -1
        top = top + 1
        stack(top) = lo
        top = top + 1
        stack(top) = hi

        do while (top >= 0)
            h = stack(top)
            top = top - 1
            l = stack(top)
            top = top - 1

            p = partition(a, l, h)

            if (p - 1 > l) then
                top = top + 1
                stack(top) = l
                top = top + 1
                stack(top) = p - 1
            end if

            if (p + 1 < h) then
                top = top + 1
                stack(top) = p + 1
                top = top + 1
                stack(top) = h
            end if
        end do
    end subroutine quicksort

    function partition(a, lo, hi) result(p)
        implicit none
        integer, intent(inout) :: a(:)
        integer, intent(in) :: lo, hi
        integer :: p, i, j, temp

        p = a(hi)
        i = lo - 1

        do j = lo, hi - 1
            if (a(j) <= p) then
                i = i + 1
                temp = a(i)
                a(i) = a(j)
                a(j) = temp
            end if
        end do

        temp = a(i + 1)
        a(i + 1) = a(hi)
        a(hi) = temp

        p = i + 1
    end function partition

    subroutine get_most_common_in_col(load_data, col, max_unique, max_out_length, n_out, most_common, counted)
        implicit none

        ! Arguments
        integer, intent(in) :: max_out_length, n_out, col, max_unique
        character(*), dimension(:, :), intent(in) :: load_data

        ! Return values
        character(max_out_length), dimension(n_out), intent(out) :: most_common
        integer, dimension(n_out), intent(out) :: counted

        ! Variables
        character(max_out_length), dimension(max_unique) :: key_pair
        integer, dimension(max_unique) :: value_pair
        character(:), dimension(:), allocatable :: check_col
        integer :: idx, idx2, location(1), fill_idx = 1, tmp(1)
        character(:), allocatable :: str

        ! Preset key/value pair
        key_pair = ""
        value_pair = 0

        ! Extract column
        check_col = load_data(:, col)

        ! Count elements
        do idx = 1, size(check_col)
            ! Get element to count
            str = check_col(idx)

            ! Find counter location
            location = 0
            do idx2 = 1, size(key_pair)
                if (key_pair(idx2) == str) then
                    location = idx2
                end if
            end do

            ! Increment counter
            if (str /= "") then
                if (location(1) > 0) then
                    value_pair(location(1)) = value_pair(location(1)) + 1
                else
                    key_pair(fill_idx) = str
                    value_pair(fill_idx) = 1
                    fill_idx = fill_idx + 1
                end if
            end if
        end do

        ! Harvest highest counters
        do idx = 1, size(most_common)
            tmp = maxloc(value_pair)
            most_common(idx) = key_pair(tmp(1))
            counted(idx) = value_pair(tmp(1))
            value_pair(tmp(1)) = -1
        end do

    end subroutine get_most_common_in_col

    subroutine get_most_common_in_string_int_col(load_data, col, min_val, max_val, n_out, most_common, counted)
        implicit none

        ! Arguments
        integer, intent(in) :: col, n_out, max_val, min_val
        character(*), dimension(:, :), intent(in) :: load_data

        ! Return values
        integer, dimension(n_out), intent(out) :: most_common, counted

        ! Arguments
        integer, dimension(min_val:max_val) :: map
        integer :: idx, tmp(1), int_val, point
        character(:), dimension(:), allocatable :: check_array

        ! Extract column
        check_array = load_data(:, col)

        ! Set counters to 0
        map = 0

        ! Count array
        do idx = 1, size(check_array)
            read (check_array(idx), "(i20)") int_val
            map(int_val) = map(int_val) + 1
        end do

        ! Harvest highest counter
        do idx = 1, size(most_common)
            tmp = maxloc(map)
            tmp = tmp(1) + min_val - 1
            most_common(idx) = tmp(1)
            counted(idx) = map(tmp(1))
            map(tmp(1)) = -1
        end do

    end subroutine get_most_common_in_string_int_col

    subroutine prog_bar(prog)
        implicit none

        ! Arguments
        real, intent(in) :: prog

        ! Consts
        character :: c_return(1)
        character(:), allocatable :: c_reset, c_green

        ! Variables
        integer :: j, point

        ! Set Consts
        c_green = achar(27)//"[32m"
        c_reset = achar(27)//"[0m"
        c_return = achar(13)

        point = floor(prog*20)

        write (*, "(2a)", advance="no") "|", c_green
        do j = (20 - point), 19
            write (*, "(a)", advance="no") "*"
        end do

        write (*, "(a)", advance="no") c_reset
        do j = point, 19
            write (*, '(a)', advance='no') "-"
        end do

        write (*, "(a, f0.3, 2a)", advance="no") "|", prog*100, "%", c_return
        if (prog >= 1) then
            print *
        end if

    end subroutine prog_bar
end module lib
