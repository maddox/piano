module Sinatra
  module Authentication

    def authorize(username, password)
      # overide this jank
    end

    def auth
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
    end

    def unauthorized!
      header 'WWW-Authenticate' => %(Basic realm="Piano")
      throw :halt, [ 401, 'Authorization Required' ]
    end

    def authorized?
      request.env['REMOTE_USER']
    end

    def login_required
      return if authorized?
      unauthorized! unless auth.provided?
      unauthorized! unless authorize(*auth.credentials)
      request.env['REMOTE_USER'] = auth.username
    end

  end
end