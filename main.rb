require 'rubygems'
require 'sinatra'
require 'pry'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'barmaged0n' 
SPRINT_DAYS = 14

@show_results_button = false
@show_availability_button = true
  
# before do

# end

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

  redirect '/project_list'
end

get '/project_list' do
  erb :project_list
end

get '/availability' do
  erb :get_availability
end

post '/availability' do
  session[:time_available] = params[:time_available].to_i
  @show_results_button = true

  redirect '/project_list'
end

post '/calculate_sprint' do
  daily_projects_times = []
  num_of_projects = session[:projects].size
  days_to_complete_projects = 0

  num_of_projects.times do |n|
    daily_projects_times << ((session[:time_available] / SPRINT_DAYS) / (n + 1))
    binding.pry
  end

  num_of_projects.times do
  
    current_daily_project_time = daily_projects_times[-1]
    smallest_project = session[:projects].select { |name, time| time == session[:projects].values.min }
    days_to_complete_smallest_project = smallest_project.values.join.to_i / current_daily_project_time
    days_to_complete_projects += days_to_complete_smallest_project
    binding.pry

    session[:projects].delete(smallest_project.keys.join)
    daily_projects_times.pop

    session[:projects].each do |name, time|
      session[:projects][name] = time.to_i - current_daily_project_time * days_to_complete_smallest_project
    end
  end

  session[:days_to_complete_projects] = days_to_complete_projects.to_i

  redirect '/results'
end

get '/results' do
  erb :results
end
