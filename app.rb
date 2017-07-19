require 'sinatra'

get '/' do
  erb :index
end

get '/kuroki' do
  erb :kuroki
end

post '/kurokiresult' do
  @network = params[:network]
  @wariai = params[:wariai]
  erb :kurokiresult
end
