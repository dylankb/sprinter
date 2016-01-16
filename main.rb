require 'rubygems'
require 'sinatra'
require 'pry'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'barmaged0n' 
SPRINT_DAYS = 14


get '/' do
  if session[:username]
    redirect '/project_entry'
  else
    redirect '/new_user'
  end
end

get '/new_user' do
  erb :get_name
end

post '/new_user' do
  if params[:username].empty?
    @error = "Please enter something here"
    halt erb(:get_name)
  else
    session[:username] = params[:username]
    redirect '/project_entry'
  end
end

get '/project_entry' do
  erb :project_entry
end

post '/projects' do
  projects = {}
  projects[params[:project_name]] = params[:project_minutes]
  
  if session[:projects]
    session[:projects].merge!(projects)
  else
    session[:projects] = projects 
  end

  #if somthing
    #redirect '/project_entry'
  #else
  redirect '/project_list'
end

get '/project_list' do
  erb :project_list
end

post '/calculate_sprint' do
#### code the calculates all the things
#### redirect '/results'
end

get '/results' do

end
