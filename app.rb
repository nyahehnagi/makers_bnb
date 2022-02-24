# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'

require './database_setup'
require './lib/space'
require './lib/customer'

require_relative './controllers/customer_controller'
require_relative './controllers/session_controller'
require './lib/booking'

# Maker House a Home
class Mahah < Sinatra::Base
  use CustomerController
  use SessionController

  configure :development do
    register Sinatra::Reloader
  end

  register Sinatra::Flash

  enable :sessions

  get '/' do
    @customer = Customer.find(customer_id: session[:customer_id])
    erb :"/index"
  end

  get '/spaces/new' do
    erb :"spaces/new"
  end

  post '/spaces' do
    Space.create(name: params[:name], description: params[:description], price: params[:price],
                 owner_customer_id: session[:customer_id])

    redirect to '/spaces'
  end

  get '/spaces' do
    @customer = Customer.find(customer_id: session[:customer_id])
    @spaces = Space.all

    erb :"spaces/index"
  end

  get '/bookings/new' do
    @spaces = Space.all
    erb :"bookings/new"
  end

  get '/bookings' do
    erb :"bookings/index"
  end

  post '/bookings' do
    session[:booking_date] = params[:booking_date]
    session[:property] = Space.find(space_id: params[:space_id])
    Booking.create(customer_id: session[:customer_id], space_id: session[:property].space_id, date_of_stay: params[:booking_date])
    redirect '/bookings'
  end

  run! if app_file == $PROGRAM_NAME
end
