IEX::Api.configure do |config|
    Settings.reload!
    config.publishable_token = Settings.iex.publishable_token
    config.secret_token = Settings.iex.secret_token
    config.endpoint = Settings.iex.endpoint
end