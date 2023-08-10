module lib
contains

    subroutine get_vic_sex_count(load_data, m, f, x)
        implicit none

        ! Arguments
        character(*), dimension(:, :), intent(in) :: load_data

        ! Return values
        integer, intent(out) :: f, m, x

        ! Variables
        character(:), dimension(:), allocatable :: sex_list
        integer :: idx
        character :: char

        ! Set counters to 0
        f = 0
        m = 0
        x = 0

        ! Extract column
        sex_list = load_data(:, 13)

        ! Count elements
        do idx = 1, size(sex_list)
            char = sex_list(idx)
            select case (char)
            case ("F")
                f = f + 1
            case ("M")
                m = m + 1
            case ("X")
                x = x + 1
            end select
        end do
    end subroutine get_vic_sex_count

    subroutine get_vic_age_data(load_data, mean, mode)
        implicit none

        ! Arguments
        character(*), dimension(:, :), intent(in) :: load_data

        ! Return values
        double precision, intent(out) :: mean, mode

        ! Variables
        character(:), dimension(:), allocatable :: char_age_list
        integer :: count = 0, idx = 0, age
        integer, dimension(0:200) :: mode_count = 0
        integer :: tmp(1)

        ! Extract column
        char_age_list = load_data(:, 12)

        ! Get mean/mode
        mean = 0
        do idx = 1, size(char_age_list)
            read (char_age_list(idx), "(i20)") age
            count = count + 1
            mean = mean + age
            mode_count(age) = mode_count(age) + 1
        end do

        ! Set return values
        mean = mean/count
        tmp = maxloc(mode_count)
        mode = tmp(1) - 1

    end subroutine get_vic_age_data

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

    subroutine get_most_common(load_data, col, max_unique, max_out_length, n_out, most_common)
        implicit none

        ! Arguments
        integer, intent(in) :: max_out_length, n_out, col, max_unique
        character(*), dimension(:, :), intent(in) :: load_data

        ! Return values
        character(max_out_length), dimension(n_out), intent(out) :: most_common

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
            value_pair(tmp(1)) = -1
            most_common(idx) = trim(key_pair(tmp(1)))
        end do

    end subroutine get_most_common

    subroutine get_most_common_counted(load_data, col, max_unique, max_out_length, n_out, most_common, counted)
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

    end subroutine get_most_common_counted
end module lib
