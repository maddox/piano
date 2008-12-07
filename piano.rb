require 'rubygems'
require 'sinatra'
require 'lib/models'


# layout 'layout'

get '/' do
  use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == 'secret'
  end

  @products = Product.find(:all)
  erb :index
end


