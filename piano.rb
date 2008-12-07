require 'rubygems'
require 'sinatra'
require 'lib/models'


# layout 'layout'

get '/' do
  @products = Product.find(:all)
  erb :index
end
