require 'api/resource'

# Load the Api Configuration
configuration = YAML.load_file("#{Rails.root}/config/api.yml")[Rails.env]

CLIENT_ID = configuration['client_id']
CLIENT_SECRET = configuration['client_secret']
CLIENT_URL = configuration['url']