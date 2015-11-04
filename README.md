[![Deploy to IBM Bluemix](https://bluemix.net/deploy/button.png)](https://bluemix.net/deploy?repository=https://hub.jazz.net/git/iwinoto/rails-mongo-sample/)

[Original blog post](http://moredevideas.com/getting-started-rails-4-with-mongodb/)

[Original Source](https://github.com/ezilocchi/rails_with_mongo_example.git)

This is an introduction tutorial with the intention of showing how to create a Rails 4 app with MongoDB, using Rspec and Cucumber for testing

To run locally, use foreman which will read the process start commands from Procfile and set the environment from .env

    # foreman start web

The project has been modified for Bluemix deployment. `lib/tasks/cloudfoundry.rake` contains rake tasks to create services and deploy to BLuemix.

To deploy to Bluemix execute from the app root:

 1. Update the host name in manifest.yml
 1. create the service as named in the manifest.yml

       $ rake create_services

 2. push the application using the default manifest file (manifest.yml)

        $ rake deploy

After a successful push the application will be available at:

    http://_your host name_.mybluemix.net/products

