class Widget
	include Api::Resource

	attr_accessor :id, :name, :description, :kind, :user, :owner

	def attributes
		{
			name: nil,
			description: nil,
			kind:nil
		}
	end

	def self.all(type, term = '', current_user)
		if type == "visible"
			response = self.execute(:get, "/api/v1/widgets/visible?term=#{term}&client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}", {})
		else
			response = self.execute(:get, "/api/v1/widgets", current_user.serializable_hash)
		end

		widgets = response[:data][:widgets].map{|widget| Widget.new(widget)}
		return widgets
		rescue RestClient::UnprocessableEntity => exception
		false
	end


	def self.all_by_user(id, term = '', current_user)
		response = self.execute(:get, "/api/v1/users/#{id}/widgets?term=#{term}&client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}", {}, {"Authorization": "Bearer #{current_user.access_token}"})
		widgets = response[:data][:widgets].map{|widget| Widget.new(widget)}
		return widgets
		rescue RestClient::UnprocessableEntity => exception
		[]
	end

	def save(current_user)
		if id.present?
		  response = self.class.execute(:put, "/api/v1/widgets/#{self.id}", {widget: self.serializable_hash}, {"Authorization": "Bearer #{current_user.access_token}"} )
		else
		  response = self.class.execute(:post, '/api/v1/widgets', {widget: self.serializable_hash}, {"Authorization": "Bearer #{current_user.access_token}"} )
		  self.id = response[:id]
		end
		return response
		# rescue RestClient::UnprocessableEntity => exception
		# return false
	end

	def self.destroy(current_user, id)
		response = self.execute(:delete, "/api/v1/widgets/#{id}", {"Authorization": "Bearer #{current_user.access_token}"} )
		return response
		rescue RestClient::UnprocessableEntity => exception
	end
end

