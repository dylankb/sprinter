#require 'Date'
require 'pry'

projects = {
  'ruby' => {'time' => 300, 'days' => 0}, 
  'birdhouse' => {'time' => 180, 'days' => 0},
  'landing page' => {'time' => 180, 'days' => 0}
}

p projects

time_avail = 840
SPRINT_DAYS = 14

project_times = []
projects.each do |_, info|
  project_times << info['time']
end

uniq_project_times = project_times.uniq.size
days_to_complete_projects = 0

updated_projects = {}

uniq_project_times.times do
  num_of_projects = projects.size

  current_daily_project_time = (time_avail / SPRINT_DAYS) / num_of_projects
  smallest_project = projects.group_by { |_, info| info['time'] }.min.last.to_h
  days_to_complete_smallest_project = smallest_project.first[1]['time'] / current_daily_project_time
  days_to_complete_projects += days_to_complete_smallest_project

  
  projects.each do |name, info|
    info['days'] += days_to_complete_smallest_project
  end
  updated_projects.merge!(projects)

  smallest_project.size.times do |i|
    projects.delete(smallest_project.keys[i])
  end

  projects.each do |name, info|
    info['time'] = info['time'] - current_daily_project_time * days_to_complete_smallest_project
  end
end

p days_to_complete_projects
p updated_projects
