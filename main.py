import csv
import fortran_lib
from colorama import Fore
from math import floor
from data_info import DATA


def progress_bar(progress):
    PASSED = "*"  # "█"
    PROG = "-"
    BAR_SIZE = 20
    DECIMALS = 2
    if progress >= 1:
        print(
            f"\t|{Fore.GREEN}{PASSED * BAR_SIZE}{Fore.RESET}| 100%  {' ' * (DECIMALS + 1)}"
        )
        return

    passed_slots = floor(progress * BAR_SIZE)
    not_passed_slots = BAR_SIZE - passed_slots

    # Passed slots
    prog_bar = "\t|" + Fore.BLUE + PASSED * passed_slots

    # Non passed slots
    prog_bar += Fore.YELLOW + PROG * not_passed_slots

    # End area
    prog_bar += f"{Fore.RESET}| {round(progress*100, DECIMALS)}%"
    print(prog_bar, end="\r")


def load_data(reader):
    print("Data load")
    data = []

    # Skip first row
    reader.__next__()

    # Load data
    for row_idx, row in enumerate(reader):
        progress_bar(row_idx / (DATA["lines"] - 2))
        data.append(row)

    print("\tData load complete")
    return data


def main():
    with open(DATA["file"]) as file:
        print(
            "Data analysis application\n\t"
            + "Testing: Fortran Python teamwork\n\t"
            + f"Using dataset: {DATA['dataname']}\n\t"
            + f"From File: {DATA['file']}"
            + f"From URL: {DATA['src']}"
        )
        reader = csv.reader(file)
        data = load_data(reader)

        vic_sex_dat = fortran_lib.lib.get_vic_sex_count(data)
        total_vics = sum(vic_sex_dat)
        print(
            f"Victim Sex Data:\n\t"
            + f"Male: {vic_sex_dat[0]/total_vics*100}% ({vic_sex_dat[0]})\n\t"
            + f"Female: {vic_sex_dat[1]/total_vics*100}% ({vic_sex_dat[1]})\n\t"
            + f"X: {vic_sex_dat[2]/total_vics*100}% ({vic_sex_dat[2]})"
        )

        vic_age_dat = fortran_lib.lib.get_vic_age_data(data)
        print(
            f"Victim Age Data\n\t"
            + f"Mean: {vic_age_dat[0]}\n\t"
            + f"Mode: {vic_age_dat[1]}\n\t"
        )


if __name__ == "__main__":
    main()
