import fortran_lib
from typing import List, Tuple, ByteString


def get_victim_age_data(data: List[List[str]]) -> Tuple[float, int]:
    return fortran_lib.lib.get_vic_age_data(data)


def get_victim_sex_data(data: List[List[str]]) -> Tuple[int, int, int]:
    return fortran_lib.lib.get_vic_sex_count(data)


def get_most_common_in_col(
    data: List[List[str]],
    column: int,
    max_number_of_unique_elements: int,
    max_element_length: int,
    top_n: int,
) -> List[str | None]:
    out = fortran_lib.lib.get_most_common(
        data, column, max_number_of_unique_elements, max_element_length, top_n
    )

    return list(dict.fromkeys(cleanse_byte_string(s) for s in out))


def get_most_common_in_col_counted(
    data: List[List[str]],
    column: int,
    max_number_of_unique_elements: int,
    max_element_length: int,
    top_n: int,
) -> List[Tuple[str | None, int]]:
    out = fortran_lib.lib.get_most_common_counted(
        data, column, max_number_of_unique_elements, max_element_length, top_n
    )

    return list(
        filter(
            lambda x: x[1] > 0,
            zip((cleanse_byte_string(s) for s in out[0]), out[1], strict=True),
        )
    )


def cleanse_byte_string(string: ByteString) -> str | None:
    s = string.decode("UTF-8").strip().strip("\x00")
    return s if s else None
