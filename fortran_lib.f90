! 1.  DR_NO
! 2.  Date_Rptd
! 3.  DATE_OCC
! 4.  TIME_OCC
! 5.  AREA
! 6.  AREA_NAME
! 7.  Rpt_Dist_No
! 8.  Part_1_2
! 9.  Crm_Cd
! 10. Crm_Cd_Desc
! 11. Mocodes
! 12. Vict_Age
! 13. Vict_Sex
! 14. Vict_Descent
! 15. Premis_Cd
! 16. Premis_Desc
! 17. Weapon_Used_Cd
! 18. Weapon_Desc
! 19. Status
! 20. Status_Desc
! 21. Crm_Cd_1
! 22. Crm_Cd_2
! 23. Crm_Cd_3
! 24. Crm_Cd_4
! 25. LOCATION
! 26. Cross_Street
! 27. LAT
! 28. LON
module lib
contains

    subroutine get_vic_sex_count(load_data, m, f, x)
        character(*), dimension(:, :), intent(in) :: load_data
        integer, intent(out) :: f, m, x
        character(:), dimension(:), allocatable :: sex_list
        integer :: idx
        character :: char

        f = 0
        m = 0
        x = 0

        sex_list = load_data(:, 13)

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
        character(*), dimension(:, :), intent(in) :: load_data
        double precision, intent(out) :: mean, mode
        character(:), dimension(:), allocatable :: char_age_list
        integer :: count = 0, idx = 0
        integer, dimension(:), allocatable :: age_list
        integer, dimension(0:200) :: mode_count = 0
        integer :: tmp(1)

        ! Pull data
        char_age_list = load_data(:, 12)
        allocate (age_list(size(char_age_list)))

        ! Get mean/mode
        mean = 0
        do idx = 1, size(char_age_list)
            read (char_age_list(idx), "(i20)") age_list(idx)
            count = count + 1
            mean = mean + age_list(idx)
            mode_count(age_list(idx)) = mode_count(age_list(idx)) + 1
        end do
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

end module lib
