import csv
from prog_bar import progress_bar
from json import load as json_load
import fortran_funcs as fortran


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
            + f"Using dataset: {DATA['file']}\n\t"
            + f"From URL: {DATA['url']}"
        )
        reader = csv.reader(file)
        data = load_data(reader)

        vic_sex_dat = fortran.get_most_common_in_col(data, 13, 10, 256, 5)
        print("Victim Sex Data:")
        for sex, count in vic_sex_dat:
            print(f"\t{sex}: {count} ({round(count/DATA['lines']*100,3)}%)")

        vic_age_dat = fortran.get_mean_mode_in_string_int_col(data, 12, 0, 120)
        print(
            f"Victim Age Data\n\t"
            + f"Mean: {vic_age_dat[0]}\n\t"
            + f"Mode: {vic_age_dat[1]}"
        )

        print("Crime Type Data:")
        for idx, (crime, count) in enumerate(
            fortran.get_most_common_in_col(data, 10, 1000, 256, 20)
        ):
            print(f"\t{idx+1}: {crime} ({count})")

        print("Weapon Type Data:")
        for idx, (weapon, count) in enumerate(
            fortran.get_most_common_in_col(data, 18, 1000, 256, 20)
        ):
            print(f"\t{idx+1}: {weapon}: ({count})")


if __name__ == "__main__":
    DATA = json_load(open("data_info.json"))
    main()
