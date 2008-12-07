require 'rubygems'
require 'sinatra'
require 'yaml'
require 'lib/models'

AUTH_CREDENTIALS = YAML.load(File.read(File.join(File.dirname(__FILE__),'config', "config.yml")))['piano']

# layout 'layout'



get '/' do
  login_required 
  
  @products = Product.find(:all)
  erb :index
end





helpers do

  def authorize(username, password)
    username == AUTH_CREDENTIALS['login'] && password == AUTH_CREDENTIALS['password']
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
