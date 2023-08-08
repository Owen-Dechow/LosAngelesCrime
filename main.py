import csv
from prog_bar import progress_bar
import fortran_lib
from json import load as json_load


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
    DATA = json_load(open("data_info.json"))
    main()
