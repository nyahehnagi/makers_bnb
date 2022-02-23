# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require './database_setup'
require './lib/space'

# Maker House a Home
class Mahah < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :"/index"
  end

  get '/spaces/new' do
    erb :"spaces/new"
  end

  post '/spaces' do
    # p params
    Space.create(name: params[:name], description: params[:description], price: params[:price], owner_customer_id: params[:owner_customer_id])
    
    redirect to "/spaces"
  end

  get '/spaces' do
    @spaces = Space.all
    
    erb :"spaces/index"
    
  end

  get '/bookings/new' do

    erb :"bookings/new"

  end

  get '/bookings' do
    erb :"bookings/index"
  end

  
  run! if app_file == $PROGRAM_NAME
end