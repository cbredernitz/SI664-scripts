# SI664-scripts
Miscellaneous Python scripts

## 1.0 Install
Either fork this repo and then clone to your working directory or download a *.zip file of the code. Create a virtual environment and then run `pip` to install package dependencies listed in the `requirements.txt` file. 

### macOS
```commandline
$ cd path/to/SI664/scripts
$ source venv/bin/activate
(venv) $ pip3 install -r requirements.txt
```

### Windows
```commandline
> cd path/to/SI664/scripts
> venv\Scripts\activate
(venv) >
```

Next, install the `mysqlclient` package. You must utilize Christoph Gohlke's 
collection of [Unoffical Windows Binaries for Python Extension Packages](https://www.lfd.uci
.edu/~gohlke/pythonlibs/) to install the `mysqlclient` package. Download the appropriate the [mysqlclient](https://www.lfd.uci.edu/~gohlke/pythonlibs/#mysqlclient) the wheel (*.whl) file.  For Python 3.7 click on "mysqlclient‑1.3.13‑cp37‑cp37m‑win_amd64.whl" and it will download to your machine.  Then perform a *manual install* of the package via `pip`:

```commandline
(venv) > pip install C:\Users\someuser\Downloads\mysqlclient-1.3.13-cp37-cp37m-win_amd64.whl
Processing c:\users\someuser\downloads\mysqlclient-1.3.13-cp37-cp37m-win_amd64.whl
Installing collected packages: mysqlclient
Successfully installed mysqlclient-1.3.13
```

After the `mysqlclient` package is installed manually run `pip install` using `requirements.txt` to ensure that the remaining required packages are installed.  

```commandline
(venv) > pip install -r requirements.txt
```

## 2.0 Available scripts

### 2.1 run_mysql_script.py
This python script is designed to process MySQL scripts.  The `run_mysql_script.py` script requires a valid database connection provided via local *.yaml config file.  After opening a connection and creating a cursor, the script creates a list of SQL statements after splitting the SQL script on each semi-colon encountered (;).  The script then loops through the statements, attempting to execute each. If successful, the script commits the changes, closes the cursor and then closes the connection.  Otherwise, it rolls back the transaction and reports the error encountered.

#### 2.1.1 Create a .yaml configuration file
Create a .yaml configuration file. The `run_mysql_script.py` script reads this file in order to retrieve the database connection settings. Add the following database connection settings to your .yaml file.  Make sure you set the `user` and `passwd` variables to the correct values. 

```yaml
mysql:
  host: localhost
  port: [yer port number, typically 3306]
  user: [yer MySQL user]
  passwd: [yer MySQL user password]
  db: unesco_heritage_sites
  local_infile: True
```

#### 2.1.2 Script arguments
The `run_mysql_script.py` features the following arguments:

* -h, --help (show this help message and exit)
* -c, --config (path to config file)
* -p, --path (path to script)

#### 2.1.3 Running the script
Run `run_mysql_script.py` as follows, tailoring the *.yaml and *.sql file paths as necessary:

##### macOS
```commandline
(venv) $ python3 run_mysql_script.py -c ./path/to/config/file/*.yaml -p ./path/to/sql/script/*.sql
```

##### Windows
```commandline
(venv) > python run_mysql_script.py -c ./path/to/config/file/*.yaml -p ./path/to/sql/script/*.sql
```

### 2.2 inspect_un_data_sets.py
Run `inspect_un_data_sets.py` to "inspect" two UN data sets included in the project `/input` directory:

* un_area_country_codes-m49.csv
* unesco_heritage_sites.csv

The script utilizes the [Pandas](https://pandas.pydata.org/) library to peruse the data sets, 
generating a set of column-based *.csv files that contain distinct column values (duplicate 
values and NaN values are filtered out) sorted in ascending order.  The files are stored in the 
project `/output` directory.

#### 2.2.1 Running the script

##### macOS
```commandline
(venv) $ python3 inspect_un_data_sets.py
```

##### Output

```commandline
INFO: Source file read /absolute/path/to/input/un_area_country_codes-m49.csv
INFO: UNSD M49 regions written to file /absolute/path/to/output/unsd_region.csv
INFO: UNSD M49 sub-regions written to file /absolute/path/to/output/unsd_sub_region.csv
INFO: UNSD M49 intermediate regions written to file /absolute/path/to/output/unsd_intermed_region.csv
INFO: UNSD M49 countries and areas written to file /absolute/path/to/output/unsd_country_area.csv
INFO: UNSD M49 development status written to file /absolute/path/to/output/unsd_dev_status.csv
INFO: Source file read /absolute/path/to/input/unesco_heritage_sites.csv
INFO: UNESCO heritage site countries/areas written to file /absolute/path/to/output/unesco_heritage_site_country_area.csv
INFO: UNESCO heritage site categories written to file /absolute/path/to/output/unesco_heritage_site_category.csv
INFO: UNESCO heritage site regions written to file /absolute/path/to/output/unesco_heritage_site_region.csv
INFO: UNESCO heritage site transboundary values written to file /absolute/path/to/output/unesco_heritage_site_transboundary.csv
```

##### Windows 10
```commandline
(venv) > python inspect_un_data_sets.py
```

##### Output

```commandline
INFO: Source file read C:\path\to\input\un_area_country_codes-m49.csv
INFO: UNSD M49 regions written to file C:\path\to\output\unsd_region.csv
INFO: UNSD M49 sub-regions written to file C:\path\to\output\unsd_sub_region.csv
INFO: UNSD M49 intermediate regions written to file C:\path\to\output\unsd_intermed_region.csv
INFO: UNSD M49 countries and areas written to file C:\path\to\output\unsd_country_area.csv
INFO: UNSD M49 development status written to file C:\path\to\output\unsd_dev_status.csv
INFO: Source file read C:\path\to\input\unesco_heritage_sites.csv
INFO: UNESCO heritage site countries/areas written to file C:\path\to\output\unesco_heritage_site_country_area.csv
INFO: UNESCO heritage site categories written to file C:\path\to\output\unesco_heritage_site_category.csv
INFO: UNESCO heritage site regions written to file C:\path\to\output\unesco_heritage_site_region.csv
INFO: UNESCO heritage site transboundary values written to file C:\path\to\output\unesco_heritage_site_transboundary.csv
```
