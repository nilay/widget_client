class Session

  include Api::Resource

  attr_accessor :email

  attr_accessor :password

  # validates_presence_of :email, :password

  def attributes
    { email: nil,
      password: nil }
  end


  class << self
    def destroy(token)
      execute(:post, '/oauth/revoke', token, {"Authorization": "Bearer #{token[:token]}"})
    end
  end

  def persisted?
    false
  end

  def create
    configuration = YAML.load_file("#{Rails.root}/config/api.yml")[Rails.env]
    self.class.execute(:post, '/oauth/token', self.serializable_hash.merge!({
                                                                                "grant_type": "password",
                                                                                "client_id": configuration['client_id'],
                                                                                client_secret: configuration['client_secret']
                                                                            }))
  end
end