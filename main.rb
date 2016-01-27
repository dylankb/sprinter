require 'rubygems'
require 'sinatra'
require 'date'
require 'csv'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'barmaged0n'

SPRINT_DAYS = 14.0
MINUTES_IN_HOUR = 60

helpers do

  def format_time_in_hours(time)
    time.to_f % 1 == 0 ? time.to_i / 60 : time.to_f / 60
  end

  def round_all_fractions_up(days)
    days.to_f % 1 == 0 ? days.to_i : days.to_i + 1
  end

  def calculate_total_time(projects)
    total_time = 0
    projects.each do |key,value|
      total_time += value['time']
    end
    total_time
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
  session[:time_available] = nil
  session[:show_results_button] = false

  if params[:username].empty?
    @error = "Please enter your name."
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

  if params[:project_name].empty?
    @error= 'Please add a name for your project.'
    halt erb(:project_entry)
  end

  if !(/^[0-9]*\.?[0-9]+/ =~ params[:project_minutes])
    @error= 'Please enter a valid number for your estimated project time.'
    halt erb(:project_entry)
  end
  
  project = {
    params[:project_name] => { 
      'time'=>params[:project_minutes].to_f, 
      'days'=> 0 } 
    }

  project[params[:project_name]]['time'] *= MINUTES_IN_HOUR

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
  time_in_minutes = params[:time_available].to_f * MINUTES_IN_HOUR * SPRINT_DAYS

  if time_in_minutes < calculate_total_time(session[:projects])
    @error = "Hmm, if you only spend #{params[:time_available]} hours a day it doesn't look like you'll be able to finish all your tasks by the end of the two weeks. Try entering a higher number."
    halt erb(:get_availability)
  end   

  session[:hours_available] = params[:time_available]
  session[:time_available] = time_in_minutes
  session[:show_results_button] = true
  session[:show_availability_button] = false

  redirect '/project_list'
end

post '/calculate_sprint' do

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

  session[:days_to_complete_projects] = round_all_fractions_up(days_to_complete_projects)
  session[:projects_updated] = projects_updated
  session[:today] = Time.new.to_date
  
  redirect '/project_list_results'
end

get '/project_list_results' do
  erb :project_list_results
end

post '/export_tasks' do
  projects_exporter = session[:projects_updated].dup

  projects_exporter.each do |key, value|
    projects_exporter[key] = projects_exporter[key].dup
    projects_exporter[key]['today'] = session[:today]
    projects_exporter[key]['time'] = "Time: #{value['time']} minutes"
    projects_exporter[key]['days'] = (session[:today] + value['days']).to_s
  end

  convert = []
  count = 0

  projects_exporter.each do |key,value|
    convert << [key]
    int_count = 0
    value.each do |k, v|
      convert[count] << v
      int_count += 1
      if int_count == value.size
        count += 1
      end
    end
  end

  session[:csv_export] = convert

  redirect '/download'
end

get '/download' do

  content_type 'application/csv'
  attachment "#{session[:username]}'s tasks.csv"
  result = CSV.generate do |csv|
    csv << ['Subject','Description','End Date','Start Date']
    session[:csv_export].each do |p|
      csv << p
    end
  end

end