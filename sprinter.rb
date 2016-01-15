#require 'Date'
require 'pry'

project1 = 'ruby'
project1_time = 300
projects = { project1 => project1_time }

project2 = 'birdhouse'
project2_time = 180
projects[project2] = project2_time
p projects

time_avail = 840
sprint_length = 14

daily_projects_times = []
num_of_projects = projects.size

num_of_projects.times do |n|
  daily_projects_times << ((time_avail / sprint_length) / (n + 1))
end
p daily_projects_times

days_to_complete_projects = 0

projects_hsh = projects.clone


num_of_projects.times do
  
  current_daily_project_time = daily_projects_times[-1]
  smallest_project = projects_hsh.select { |name, time| time == projects_hsh.values.min }
  days_to_complete_smallest_project = smallest_project.values.join.to_i / current_daily_project_time
  days_to_complete_projects += days_to_complete_smallest_project

  projects_hsh.delete(smallest_project.keys.join)
  daily_projects_times.pop

  projects_hsh.each do |name, time|
    projects_hsh[name] = time - current_daily_project_time * days_to_complete_smallest_project
  end
end

p days_to_complete_projects