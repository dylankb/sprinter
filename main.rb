require 'rubygems'
require 'sinatra'
require 'pry'
require 'date'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'barmaged0n'

SPRINT_DAYS = 14
MINUTES_IN_HOUR = 60

helpers do

  def format_time_in_hours(time)
    time.to_f % 1 == 0 ? time.to_i / 60 : time.to_f / 60
  end
end

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
  session[:projects] = nil

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
  
  project = {
    params[:project_name] => { 
      'time'=>params[:project_minutes].to_f, 
      'days'=> 0 } 
    }
  
  #binding.pry
  if session[:projects]
    session[:projects].merge!(project)
  else
    session[:projects] = project 
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
  session[:hours_available] = params[:time_available]
  session[:time_available] = params[:time_available].to_f * MINUTES_IN_HOUR * SPRINT_DAYS
  session[:show_results_button] = true
  session[:show_availability_button] = false

  redirect '/project_list'
end

post '/calculate_sprint' do

  #binding.pry
  daily_projects_times = []
  days_to_complete_projects = 0
  projects_updated = session[:projects].dup
  projects_iterator = session[:projects].dup

  session[:projects].each do |_, info|
    daily_projects_times << info['time']
  end
  uniq_project_times = daily_projects_times.uniq.size

  uniq_project_times.times do
    num_of_projects = projects_iterator.size
  
    current_daily_project_time = (session[:time_available] / SPRINT_DAYS) / num_of_projects
    smallest_project = projects_iterator.group_by { |_, info| info['time'] }.min.last.to_h
    days_to_complete_smallest_project = smallest_project.first[1]['time'] / current_daily_project_time
    days_to_complete_projects += days_to_complete_smallest_project

    projects_iterator.each do |name, info|
      projects_updated[name] = projects_updated[name].dup
      projects_updated[name]['days'] += days_to_complete_smallest_project
    end

    smallest_project.size.times do |i|
      projects_iterator.delete(smallest_project.keys[i])
    end

    projects_iterator.each do |name, info|
      info['time'] = info['time'] - current_daily_project_time * days_to_complete_smallest_project
    end
  end

  session[:days_to_complete_projects] = days_to_complete_projects.to_i
  session[:projects_updated] = projects_updated
  #binding.pry
  session[:today] = Time.new.to_date
  
  redirect '/project_list_results'
end

get '/project_list_results' do
  erb :project_list_results
end