# README

Setup:
* clone repo
* run `bundle install`
* run `rake db:migrate` (you may need to run `yarn install --check-files` first)
* run `rails s`

Important Environment Variables:
* IEX_API_PUBLISHABLE_TOKEN
* IEX_API_SECRET_TOKEN
* IEX_API_ENDPOINT

Use test keys for development and testing as well as the sandbox endpoint. They will be prefixed by "Tpk_..." and "Tsk_...".
The sandbox endpoint is https://sandbox.iexapis.com/v1
The endpoint for real data is https://cloud.iexapis.com/v1

If there is an issue with the server not starting or environment variables not loading properly, a possible solution is to run `spring stop`
