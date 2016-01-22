#require 'date'
require 'pry'

projects = {
  'ruby' => {'time' => 300, 'days' => 0}, 
  'birdhouse' => {'time' => 180, 'days' => 0}
  #'landing page' => {'time' => 180, 'days' => 0}
}


time_avail = 840
SPRINT_DAYS = 14

project_times = []
projects.each do |_, info|
  project_times << info['time']
end

uniq_project_times = project_times.uniq.size
days_to_complete_projects = 0

projects_updated = projects.clone
projects_iterator = projects.clone

uniq_project_times.times do
  num_of_projects = projects_iterator.size

  current_daily_project_time = (time_avail / SPRINT_DAYS) / num_of_projects
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

p days_to_complete_projects

p projects_iterator
p projects
puts '----'
p projects_updated