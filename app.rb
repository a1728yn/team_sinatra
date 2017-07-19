require 'sinatra'
require 'json'
require 'time'

get '/' do
  erb :index
end

get '/a1728yn' do
  erb :a1728yn
end

get '/to_unixtime/:yyyymmdd' do
  yyyymmdd  = params['yyyymmdd']
  unixtime = Time.parse(yyyymmdd).to_i
  "#{unixtime}"
end
