module Api
  module Resource
    mattr_accessor :url
    def self.included(base)
      # Make our models react like an ActiveRecord
      base.include ActiveModel::Model
      base.include ActiveModel::Serialization
      base.extend ClassMethods
    end

    # Helper method that parses a 422 API response's body and adds the errors to our models.
    def add_errors_to_resource(exception, resource)
      errors = JSON.parse(exception.response.body, symbolize_names: true)[:errors]
      if errors
        errors.each do |key, value|
          resource.errors.add(key, value.join(', '))
        end
      end
    end

    # Form builders use this to generate proper URLs in forms etc.
    # Our models without id should override this with false.
    def persisted?
      id.present?
    end

    # Allow assignment of attributes to existent model instances.
    # ActiveModel::Model does this only in initializer.
    def attributes=(attributes)
      attributes.each do |attr, value|
        self.public_send("#{attr}=", value)
      end if attributes
    end

    module ClassMethods
      # Helper method that creates a nested resource with the given path, executes the request with the given method
      # and passes the respective data if present.
      def execute(method, path, data = {}, headers = {})
        url = CLIENT_URL
        client_details = {client_id: CLIENT_ID, client_secret:CLIENT_SECRET}
        data.merge!(client_details)

        headers.merge!({"Content-Type":"application/json"})
        
        parameters = []
        parameters.unshift(data) unless data.blank?

        client = RestClient::Resource.new(url, headers: headers)
        response = client[path].send(method,*parameters)

        JSON.parse(response, symbolize_names: true) unless response.blank?

      end
    end 
  end
end