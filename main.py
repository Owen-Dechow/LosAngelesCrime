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
        # if row_idx > 1000:
        #     print("")
        #     break

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

        vic_sex_dat = fortran.get_victim_sex_data(data)
        total_vics = sum(vic_sex_dat)
        print(
            f"Victim Sex Data:\n\t"
            + f"Male: {vic_sex_dat[0]/total_vics*100}% ({vic_sex_dat[0]})\n\t"
            + f"Female: {vic_sex_dat[1]/total_vics*100}% ({vic_sex_dat[1]})\n\t"
            + f"X: {vic_sex_dat[2]/total_vics*100}% ({vic_sex_dat[2]})"
        )

        vic_age_dat = fortran.get_victim_age_data(data)
        print(
            f"Victim Age Data\n\t"
            + f"Mean: {vic_age_dat[0]}\n\t"
            + f"Mode: {vic_age_dat[1]}"
        )

        print("Crime Type Data:")
        for idx, crime in enumerate(
            fortran.get_most_common_in_col(data, 10, 1000, 256, 20)
        ):
            print(f"\t{idx+1}: {crime}")

        print("Weapon Type Data:")
        for weapon, freq in fortran.get_most_common_in_col_counted(
            data, 18, 1000, 256, 20
        ):
            print(f"\t{weapon}: ({freq})")


if __name__ == "__main__":
    DATA = json_load(open("data_info.json"))
    main()
