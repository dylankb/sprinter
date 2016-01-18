require 'rubygems'
require 'sinatra'
require 'pry'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'barmaged0n'


SPRINT_DAYS = 14
MINUTES_IN_HOUR = 60

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

post '/add_project' do
  
  projects = {
    params[:project_name] => { 
      'time'=>params[:project_minutes].to_i * MINUTES_IN_HOUR, 
      'days'=> 0 } 
    }
  
  if session[:projects]
    session[:projects].merge!(projects)
  else
    session[:projects] = projects 
  end

  session[:show_availability_button] = true
  redirect '/project_list'
end

get '/project_list' do
  erb :project_list
end

get '/availability' do
  erb :get_availability
end

post '/availability' do
  session[:time_available] = params[:time_available].to_i * MINUTES_IN_HOUR
  session[:show_results_button] = true
  session[:show_availability_button] = false

  redirect '/project_list'
end

post '/calculate_sprint' do

  daily_projects_times = []
  days_to_complete_projects = 0
  updated_projects = {}

  session[:projects].each do |_, info|
    daily_projects_times << info['time']
  end
  uniq_project_times = daily_projects_times.uniq.size

  uniq_project_times.times do
    num_of_projects = session[:projects].size
  
    current_daily_project_time = (session[:time_available] / SPRINT_DAYS) / num_of_projects
    smallest_project = session[:projects].group_by { |_, info| info['time'] }.min.last.to_h
    days_to_complete_smallest_project = smallest_project.first[1]['time'] / current_daily_project_time
    days_to_complete_projects += days_to_complete_smallest_project

    session[:projects].each do |name, info|
      info['days'] += days_to_complete_smallest_project
    end
    updated_projects.merge!(session[:projects])

    smallest_project.size.times do |i|
      session[:projects].delete(smallest_project.keys[i])
    end

    session[:projects].each do |name, info|
      info['time'] = info['time'] - current_daily_project_time * days_to_complete_smallest_project
    end
  end

  session[:days_to_complete_projects] = days_to_complete_projects.to_i
  session[:projects] = updated_projects
  binding.pry

  redirect '/project_list'
end
