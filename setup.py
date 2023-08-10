import requests
import json
from prog_bar import spinner

if __name__ == "__main__":
    with open("url.txt") as url_file:
        url = url_file.readline()

    r = requests.get(url, allow_redirects=False, stream=True)
    dataset_filename = r.headers["Content-Disposition"].split("filename=")[1]

    with open(dataset_filename, "wb") as dataset_file:
        for idx, chunk in enumerate(r.iter_content(chunk_size=1024)):
            # writing one chunk at a time to pdf file
            if chunk:
                dataset_file.write(chunk)

            if idx > 15:
                r.close()
                break

            spinner(idx, 0.01)

    print("")
    print("Collecting Information")

    with open(dataset_filename, "r") as dataset_file:
        line_count = 0
        first_line = None
        for current_line in dataset_file:
            line_count += 1
            if first_line is None:
                first_line = current_line

        datainfo_dict = {}
        datainfo_dict["url"] = url
        datainfo_dict["lines"] = line_count
        datainfo_dict["file"] = dataset_file.name
        datainfo_dict["response_headers"] = dict(r.headers)

        with open("data_info.json", "w") as datainfo_file:
            json.dump(datainfo_dict, datainfo_file)

        with open("col_info.txt", "w") as colinfo_file:
            for idx, col in enumerate(first_line.split(",")):
                colinfo_file.write(f"{idx+1}. {col}\n")

    print("Setup complete")
