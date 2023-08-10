import fortran_lib
from typing import List, Tuple, ByteString
from numpy import empty


def get_mean_mode_in_string_int_col(
    data: List[List[str]], column: int, min_val: int, max_val: int
) -> Tuple[float, int]:
    return fortran_lib.lib.get_mean_mode_in_string_int_col(
        data, column, min_val - 1, max_val + 1
    )


def get_most_common_in_col(
    data: List[List[str]],
    column: int,
    max_number_of_unique_elements: int,
    max_element_length: int,
    top_n: int,
) -> List[Tuple[str | None, int]]:
    out = fortran_lib.lib.get_most_common_in_col(
        data, column, max_number_of_unique_elements, max_element_length, top_n
    )

    return list(
        filter(
            lambda x: x[1] > 0,
            zip((cleanse_byte_string(s) for s in out[0]), out[1], strict=True),
        )
    )


def get_most_common_in_string_int_col(
    data: List[List[str]], column: int, min_val: int, max_val: int, n_out: int
) -> List[Tuple[int, int]]:
    out = fortran_lib.lib.get_most_common_in_string_int_col(
        data, column, min_val, max_val, n_out
    )

    print(
        list(
            filter(
                lambda x: x[1] > 0,
                zip(*out),
            )
        )
    )


def cleanse_byte_string(string: ByteString) -> str | None:
    s = string.decode("UTF-8").strip().strip("\x00")
    return s if s else None


def prog_bar(prog: float) -> None:
    fortran_lib.lib.prog_bar(prog)
