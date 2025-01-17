## Section1: Data Pipelines
An e-commerce company requires that users sign up for a membership on the website in order to purchase a product from the platform. As a data engineer under this company, you are tasked with designing and implementing a pipeline to process the membership applications submitted by users on an hourly interval.

Applications are batched into a varying number of datasets and dropped into a folder on an hourly basis. You are required to set up a pipeline to ingest, clean, perform validity checks, and create membership IDs for successful applications. An application is successful if:

- Application mobile number is 8 digits
- Applicant is over 18 years old as of 1 Jan 2022
- Applicant has a valid email (email ends with @emailprovider.com or @emailprovider.net)

You are required to format datasets in the following manner:

- Split name into first_name and last_name
- Format birthday field into YYYYMMDD
- Remove any rows which do not have a name field (treat this as unsuccessful applications)
- Create a new field named above_18 based on the applicant's birthday
- Membership IDs for successful applications should be the user's last name, followed by a SHA256 hash of the applicant's birthday, truncated to first 5 digits of hash (i.e <last_name>_<hash(YYYYMMDD)>)

You are required to consolidate these datasets and output the successful applications into a folder, which will be picked up by downstream engineers. Unsuccessful applications should be condolidated and dropped into a separate folder.

You can use common scheduling solutions such as cron or airflow to implement the scheduling component. Please provide a markdown file as documentation.

Note: Please submit the processed dataset and scripts used

## User Instructions
This sets up the cronjob on docker, which runs the data cleaning script every hour. Once it's run, it will transfer the files from the `data_ingest` folder to the `data_processed` folder such that it won't be processed again. Also note that applicants will be filtered into the respective folders based on whether they are successful or not.

Note that this has been set up as a cron job for overall simplicity in terms of implementation. For more complex data orchestration tasks, airflow would be preferred. But given the scope of the current ask, this will be much easier to set up and maintain.

This assumes that docker has already been installed.

1. Navigate into the folder and run `docker build -t data_cleaning_cron .` to build the docker image

2. Run `docker run -d --name data_cleaning_container data_cleaning_cron` to run the docker container from the image.

