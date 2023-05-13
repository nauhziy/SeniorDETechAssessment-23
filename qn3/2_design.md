### Design 2

You are designing data infrastructure on the cloud for a company whose main business is in processing images.

The company has a web application which allows users to upload images to the cloud using an API. There is also a separate web application which hosts a Kafka stream that uploads images to the same cloud environment. This Kafka stream has to be managed by the company's engineers. 

Code has already been written by the company's software engineers to process the images. This code has to be hosted on the cloud. For archival purposes, the images and its metadata has to be stored in the cloud environment for 7 days, after which it has to be purged from the environment for compliance and privacy. The cloud environment should also host a Business Intelligence resource where the company's analysts can access and perform analytical computation on the data stored.

As a technical lead of the company, you are required to produce a system architecture diagram (Visio, PowerPoint, draw.io) depicting the end-to-end flow of the aforementioned pipeline. You may use any of the cloud providers (e.g. AWS, Azure, GCP) to host the environment. The architecture should specifically address the requirements/concerns above. 

In addition, you will need to address several key points brought by stakeholders. These includes:
- Securing access to the environment and its resources as the company expands
- Security of data at rest and in transit
- Scaling to meet user demand while keeping costs low
- Maintainance of the environment and assets (including processing scripts)


You will need to ensure that the architecture takes into account the best practices of cloud computing. This includes (non-exhaustive):
- Managability
- Scalability
- Secure
- High Availability
- Elastic
- Fault Tolerant and Disaster Recovery
- Efficient
- Low Latency
- Least Privilege

Do indicate any assumptions you have made regarding the architecture. You are required to provide a detailed explanation on the diagram.

## Architecture
[Cloud Architecture](2_cloud_architecture.png)
With reference to the diagram, I'd walk through the thought process in chronological order.

1. Image Upload
    There are two separate web applications from which users can upload images for processing:
    - API: The web application should authenticate users before allowing them to upload images, as well as restrict their ability to access any data depending on the use case. Uploading the image would be done via a POST request to the API endpoint, which should be configured to ensure the validity of the request, rate limiting and such. A cloud function can then retrieve the image from the request, perform some level of validation and then upload it into the Google Cloud Storage bucket. 
    - Kafka Streaming: A kafka producer would publish the image data as message to a kafka topic, which will be picked up by a kafka consumer running on Google Compute Engine that's subscribed to the topic. The image data is retrieved, can be processed, and then written to the same Google Cloud Storage bucket as the API method.

2. Image Processing
    When a raw image is uploaded in Google Cloud Storage bucket, a notification trigger can be used to call the micro-service used to process the image and generate meta-data. The processed image is then stored in another Google Cloud Storage bucket, while the metadata will be stored in the Google BigQuery database for downstream analytics.
    - Image Archival: Object Lifecycle Management policies can be put in place to delete data after 7 days as per policy. These can be configured in the Google Cloud Storage settings. For Google BigQuery, while there isn't an automated process, we can set up a scheduled query that deletes the data based on a filter.
    - Rationale: The reason why image data should be stored in a data lake is due to the scalability and maintainability of this approach. Databases are not designed for image data, and trying to do so will lead to higher storage and querying costs. Additionally, it will degrade the query performance due to the significantly higher volume of binary data as opposed to text or numeric data.

3. Data Analytics
    The analytics team can query the data directly in Google BigQuery and visualise it in Data Studio. They can also connect to the data using a number of other data visualization tools depending on preference.

# Considerations
1. Security
    - Permissioning via Identity Access Management configurations to manage user access to resources. This ensures that a user only has the privileges they need. It's generally good practice to audit permissions from time to time to ensure that they continue to stay relevant.
    - Data stored in Google Cloud Storage and BigQuery is encrypted by default whereas data in transit should also be encrypted using TLS protocols. Personally Identifiable Information like user information should be anonymised where possible, with limited access to internal users.
2. Scalability and Costing
    - Cloud Infrastructure providers like GCP / AWS allow the architecture to scale up or down depending on demand, which also reduces the cost of maintenance as images can be processed in parallel. This offers significant advantages over on-premise data solutions, which require a more significant up-front cost.
    - While automated lifecycle management and scheduled queries are in place to delete older data for compliance, it also reduces the data storage cost. 
3. Maintainability:
    - Using managed infrastructure provided by cloud providers reduces the overhead of having to maintain or develop the infrastructure in-house. 
4. Fault Tolerance
    - While there is inherent dependency due to the fact that it is a data pipeline, this can be isolated to the individual step, and the service can be configured to retry or alert users when there's an error.
    - Cloud infrastructure has been designed to allow for better control around the ability to track changes or roll back changes when needed. Or to fix specific parts of the infrastructure without impacting others due to the serverless nature and use of micro-services. For example, if a cloud function worker fails due to errors in the image or any other reason, other workers can be spun in parallel to serve requests such that other users are not impacted.