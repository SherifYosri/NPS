# NPS Application (Net Promoter Score)


# Installation
Since the system depends on multiple services like Redis and Sidekiq to function properly and in order to ease installation and usage, I created a docker compose file so that the app can be up and running by executing just one command:
* Navigate to app directory and run "docker-compose up"

# Test files
To run spec files that are written using Rspec library, navigate to app directory and run
* bundle exec rspec spec

# Notes about use case "C" (the endpoint that returns feedbacks data)
* The endpoint should send an email to the BI team member who requests the data, but since I'm using the free plan in Mailgun service email recipient has to be added first on my Mailgun account to recieve emails.

* The implemented approach depends on sending the requested data as attachments to the user email. I know this isn't the best way as the max limit for attachments is just 10 or 15 MB. There is another way by uploading the data to a third party service like Amazon S3 and send just the download link in the email but since my CC is linked to AWS account I couldn't compromise my credenitals in a public repository - Security comes first :) -

# API docs
You can find detailed docs for the the implemented endpoints at this link
