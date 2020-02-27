class User
	include Api::Resource
	
	attr_accessor :id
	attr_accessor :email
	attr_accessor :name
	attr_accessor :images
	attr_accessor :first_name
	attr_accessor :last_name
	attr_accessor :date_of_birth
	attr_accessor :email
	attr_accessor :images
	attr_accessor :password
	attr_accessor :password_confirmation
	attr_accessor :image_url
	attr_accessor :access_token
	attr_accessor :refresh_token
	attr_accessor :expires_in
	attr_accessor :authentication_token_expires_at
	attr_accessor :current_password
	attr_accessor :new_password
	attr_accessor :active	



	def attributes
		{
			"first_name": nil,
			"last_name": nil,
			"password": nil,
			"email": nil,
			"image_url": nil,
			"refresh_token":nil,
			"access_token":nil,
			"new_password":nil,
		}
	end


	def save
		if id.present?
		  self.class.execute(:put, "/api/v1/users/#{id}", user: self.serializable_hash)
		else
			user = self.serializable_hash
			user.slice!(:first_name, :last_name, :password, :email, :image_url)
		  response = self.class.execute(:post, '/api/v1/users', user: user)
		  self.id = response[:id]
		end
		return response
		rescue RestClient::UnprocessableEntity => exception
			add_errors_to_resource(exception, self)
		false
	end

	def self.find(id, current_user)
		if id.present?
		  response = execute(:get, "/api/v1/users/#{id}",{}, {"Authorization": "Bearer #{current_user.access_token}"})
		end
		rescue RestClient::UnprocessableEntity => exception
			add_errors_to_resource(exception, self)
		false
	end

	def self.me(current_user)
		response = execute(:get, '/api/v1/users/me', {}, {"Authorization": "Bearer #{current_user.access_token}"})		
			return response
		rescue RestClient::UnprocessableEntity => exception
			add_errors_to_resource(exception, self)
		false
	end
end
