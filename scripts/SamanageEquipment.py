### Script gets Assets in Solarwinds Samanage and lists them out by owner with Serial Number  ###
### This is then imported into google sheets using a csv import script on the first sheet     ###
### Lastly A query separates out the hardware by category removing any assets out of rotation ###

import json
import gspread
import csv
import requests
import pandas as pd
from pandas import DataFrame

headers = {
    'x-samanage-authorization': "Bearer API_KEY_TOKEN_GOES_HERE".format(""),  # put your token in the quotes here
    'accept': "application/json"
}


def main():
    # download the data for hardware, mobile, and other assets
    hardware_df = get_hardware_data()
    mobiles_df = get_mobiles_data()
    other_assets_df = get_other_assets_data()

    # combine the data into one dataframe
    df = hardware_df.append(mobiles_df, ignore_index = True)
    df = df.append(other_assets_df, ignore_index = True)

    df1 = df.sort_values(by='Owner Name')

    # export_csv = df1.to_csv('/mnt/g/Shared drives/IT Public/equipment.csv',index=None, header=True)
    export_csv = df1.to_csv('equipment.csv',index=None, header=True)



def get_hardware_data():
    url = "https://api.samanage.com/hardwares.json"

    response = requests.request("GET", url, headers=headers)
    data = response.json()
    # this will get use the headers (page number and x-total-pages)
    headers2 = response.headers
    assert 'X-Total-Pages' in headers2
    # loop through pages and store respons in data variable
    for x in range(2, int(headers2['X-Total-Pages'])+1):
        response = requests.request("GET", url + "?page={}".format(x), headers = headers)
        data = data + response.json()

    df = pd.DataFrame()
    # loop through data to orgonize into column/fields for csv
    for hardware in data:
        if hardware['owner'] is None:
            name = None
        else:
            name = hardware['owner']['name']

        serial_number = hardware['serial_number']

        if hardware['category'] is None:
            make = None
        else:
            make = hardware['category']['name']

        model = hardware['model']

        repl_date = None
        purch_date = None
        for field in hardware['custom_fields_values']:
            if field['name'] == 'Replacement Date':
                repl_date = field['value']
            if field['name'] == 'Purchase Date':
            	purch_date = field['value']

        df = df.append(
            pd.DataFrame(
                {
                    "Category": ["Hardware"],
                    "Owner Name": [name],
                    "Hardware Serial Number": [serial_number],
                    "Make": [make],
                    "Model": [model],
                    "Replacement Date": [repl_date],
                    "Purchase Date": [purch_date]
                }
            ),
            ignore_index = True
        )

    return df

def get_mobiles_data():
    url = "https://api.samanage.com/mobiles.json"

    response = requests.request("GET", url, headers=headers)
    data = response.json()
    # this will get use the headers (page number and x-total-pages)
    headers2 = response.headers
    assert 'X-Total-Pages' in headers2
    # loop through pages and store respons in data variable
    for x in range(2, int(headers2['X-Total-Pages'])+1):
        response = requests.request("GET", url + "?page={}".format(x), headers = headers)
        data = data + response.json()

    df = pd.DataFrame()

    for mobiles in data:
        if mobiles['user'] is None:
            name = None
        else:
            name = mobiles['user']['name']

        serial_number = mobiles['serial_number']

        if mobiles['category'] is None:
            make = None
        else:
            make = mobiles['category']['name']

        model = mobiles['model']

        repl_date = None
        purch_date = None
        for field in mobiles['custom_fields_values']:
            if field['name'] == 'Replacement Date':
                repl_date = field['value']
            if field['name'] == 'Purchase Date':
            	purch_date = field['value']

        df = df.append(
            pd.DataFrame(
                {
                    "Category": ["Mobile Devices"],
                    "Owner Name": [name],
                    "Hardware Serial Number": [serial_number],
                    "Make": [make],
                    "Model": [model],
                    "Replacement Date": [repl_date],
                    "Purchase Date": [purch_date]
                }
            ),
            ignore_index = True
        )

    return df

def get_other_assets_data():
    url = "https://api.samanage.com/other_assets.json"

    response = requests.request("GET", url, headers=headers)
    data = response.json()
    # this will get use the headers (page number and x-total-pages)
    headers2 = response.headers
    assert 'X-Total-Pages' in headers2
    # loop through pages and store respons in data variable
    for x in range(2, int(headers2['X-Total-Pages'])+1):
        response = requests.request("GET", url + "?page={}".format(x), headers = headers)
        data = data + response.json()

    df = pd.DataFrame()

    for other_assets in data:
        if other_assets['owner'] is None:
            name = None
        else:
            name = other_assets['owner']['name']

        serial_number = other_assets['serial_number']

        if other_assets['category'] is None:
            make = None
        else:
            make = other_assets['category']['name']

        model = other_assets['model']

        repl_date = None
        purch_date = None
        for field in other_assets['custom_fields_values']:
            if field['name'] == 'Replacement Date':
                repl_date = field['value']
            if field['name'] == 'Purchase Date':
            	purch_date = field['value']

        df = df.append(
            pd.DataFrame(
                {
                    "Category": ["Other Assets"],
                    "Owner Name": [name],
                    "Hardware Serial Number": [serial_number],
                    "Make": [make],
                    "Model": [model],
                    "Replacement Date": [repl_date],
                    "Purchase Date": [purch_date]
                }
            ),
            ignore_index = True
        )

    return df


if __name__ == '__main__':
    main()

