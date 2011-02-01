class RatingsApp
  
  # def initialize(app)
  #   @app = app
  # end

  def call(env)
    req = Rack::Request.new(env)
    [301, {"Location" => "http://#{req.env['HTTP_HOST']}/locations/#{req.params['location_id']}"}, self]
  end

  def each(&block)
  end
end
