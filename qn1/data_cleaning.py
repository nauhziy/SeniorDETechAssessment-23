import os
import hashlib
import pandas as pd
import shutil
import time
from dateutil.parser import parse


def main():
    files = []
    source_folder = 'data_ingest'
    destination_folder = 'data_processed'

    if len(os.listdir(source_folder)) == 0:
        return

    for file_name in os.listdir(source_folder):
        if os.path.isfile(os.path.join(source_folder, file_name)):
            files.append(f'{destination_folder}/{file_name}')
            source_path = os.path.join(source_folder, file_name)
            destination_path = os.path.join(destination_folder, file_name)
            shutil.move(source_path, destination_path)

    # Union all files in data folder for ingest
    df = pd.DataFrame()
    for file_name in files:
        df = pd.concat([df, pd.read_csv(file_name)], ignore_index=True)
    df['success'] = True

    # Split name into first_name and last_name
    undesired_titles = [title.lower() for title in ['Mr.', 'Mrs.', 'Dr.', 'Ms.', 'Miss', 'Jr.', 'Sr.', 'MD', 'PhD', 'DVM', 'DDS', 'II', 'III', 'IV', 'V', 'VI']]
    df['temp_name'] = df['name'].apply(lambda x: ' '.join([item for item in x.split() if item.lower() not in undesired_titles]))
    df[['first_name', 'last_name']] = df['temp_name'].str.split(' ', n=1, expand=True)
    df = df.drop(columns=['temp_name'])

    # Application mobile number is 8 digits
    # Applicant has a valid email (email ends with @emailprovider.com or @emailprovider.net)
    df.loc[df['mobile_no'].astype(str).str.len() != 8, 'success'] = False
    df.loc[~df['email'].str.endswith(('.com', '.net')), 'success'] = False

    # Format birthday field into YYYYMMDD
    df['date_of_birth'] = df['date_of_birth'].apply(lambda x: parse(x, dayfirst=True).strftime('%Y-%m-%d'))

    # Applicant is over 18 years old as of 1 Jan 2022
    # Create a new field named above_18 based on the applicant's birthday
    df['above_18'] = pd.to_datetime(df['date_of_birth']) < pd.Timestamp('2004-01-01')
    df.loc[~df['above_18'], 'success'] = False

    # Remove any rows which do not have a name field (treat this as unsuccessful applications)
    df['success'].fillna(False, inplace=True)

    # Membership IDs for successful applications should be the user's last name
    # followed by a SHA256 hash of the applicant's birthday, 
    # truncated to first 5 digits of hash (i.e <last_name>_<hash(YYYYMMDD)>)
    df['membership_id'] = df.apply(lambda row: f"{row['last_name'].lower()}{hashlib.sha256(row['date_of_birth'].encode()).hexdigest()[:5]}" if row['success'] else '',axis=1)
    df = df.drop(columns=['success'])

    # Successful applicants
    df[df['membership_id']!=''].reset_index(drop=True).to_csv(f'successful_applicants/output{int(time.time())}.csv')
    # Unsuccessful applicants
    df[df['membership_id']==''].reset_index(drop=True).to_csv(f'unsuccessful_applicants/output{int(time.time())}.csv')
    
    return f'Run completed at {int(time.time())}'

if __name__ == "__main__":
    main()

