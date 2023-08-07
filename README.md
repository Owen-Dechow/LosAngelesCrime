# LosAngelesCrime
Test Python's ability to work with Fortran for data analysis using, Los Angeles crime data.

## Prerequisites
* Python 3
* Fortran 90

## Installation
1. Clone the repo
    ```bash
    $ git clone https://github.com/Owen-Dechow/LosAngelesCrime.git
    $ cd LosAngelesCrime
    ```

1. Create/activate virtual environment
    ```bash
    $ python3 -m venv venv
    ```

1. Install dependencies
    ```bash
    $ pip install -r requirements.txt
    ```

1. Ensure `f2py` installed properly
    ```bash
    $ f2py -v
    ```
    This should output a verstion number

1. [Download dataset](https://data.lacity.org/api/views/2nrs-mtv8/rows.csv?accessType=DOWNLOAD)

1. Update the lines value in `data_info.py` to match the number of lines in downloaded dataset

## Running
1. If changes where made to `fortran_lib.f90` or first time running
    ```bash
    $ f2py -c -m fortran_lib fortran_lib.f90
    ```

1. Run `main.py` file
    ```bash
    $ python3 main.py
    ```