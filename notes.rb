require 'pry'

hsh = {
  'ruby' => {'time' => 300, 'days' => 0}, 
  'birdhouse' => {'time' => 180, 'days' => 0},
  'landing page' => {'time' => 180, 'days' => 0}
}
days_to_add = 5
time_int = 20
num_of_days = 9

hsh_updated = hsh.dup
hsh_iterator = hsh.dup

smallest = hsh_iterator.group_by { |_, info| info['time'] }.min.last.to_h

hsh_iterator.each do |name, info|
  hsh_updated[name] = hsh_updated[name].dup
  hsh_updated[name]['days'] += days_to_add
end

smallest.size.times do |i|
  hsh_iterator.delete(smallest.keys[i])
end

hsh_iterator.each do |name, info|
  #hsh_updated[name] = hsh_updated[name].dup
  #hsh_iterator[name]['time'] = hsh_iterator[name]['time'] - time_int * num_of_days
  binding.pry
  info['time'] = info['time'] - time_int * num_of_days
end

p hsh
p hsh_iterator
puts '---'
p hsh_updated

# # # OUTLINE

# # # Goal: set user up to create sprint goals and allocate daily time to them.

# # # User enters each the name of a project.
# # # Enters the amount of time that project will take.
# # # Repeats until no more projects
# # # User estimates how much time they have to work on these projects
# # # Display daily amount of time they will need to spend on each project

# # #Array indexes
# # # 0 - time_total
# # # 1 - length
# # # 2 - time_avail

# # # puts "What's your project name"
# # # project_1 = gets.chomp

# # # puts "How much time will this task take in minutes?"
# # # time_total = gets.chomp.to_i

# # # #set default time to now? DateTime.now.to_date

# # # puts "What's the start date?"
# # # s_date = gets.chomp  # enforce date format of YYYY/MM/DD
# # # s_date = Date.parse(s_date)

# # # puts "What's the your due date"
# # # d_date = gets.chomp # enforce date format of YYYY/MM/DD
# # # d_date = Date.parse(d_date)
# # # length = (d_date - s_date).to_i 

# # # puts "How many minutes a day do you have?"
# # # time_avail = gets.chomp.to_i

# # # project_1 = 'Ruby'
# # # time_total = 300
# # # length = 14

# # # project_2 = 'Build birdhouse'
# # # time_total_2 = 120
# # # length_2 = 14

# # # projects = {project_1 => []}
# # # projects[project_1][0] = time_total
# # # projects[project_1][1] = length

# # # projects.merge!({project_2 => []})
# # # projects[project_2][0] = time_total_2
# # # projects[project_2][1] = length_2

# # #time_avail_hsh = {'available' => time_avail}
# # # Will need to refactor to nested hashes if/when sprint length is modifiable per task
# # # projects_hsh[project_1].merge!({"length" => length })
# # # length = 14


# # Nested hash


# #require 'Date'
# require 'pry'

# projects = {
#   'ruby' => {'time' => 300, 'days' => 9}, 
#   'birdhouse' => {'time' => 180, 'days' => 4},
#   'landing page' => {'time' => 180, 'days' => 4}
# }

# p projects

# time_avail = 840
# SPRINT_DAYS = 14

# project_times = []
# projects.each do |_, info|
#   project_times << info['time']
# end

# uniq_project_times = project_times.uniq.size
# days_to_complete_projects = 0

# # projects.group_by { |a,b| b['time'] }.min.last
# # => [["birdhouse", {"time"=>180, "days"=>4}], ["landing page", {"time"=>180, "days"=>4}]]


# uniq_project_times.times do
#   num_of_projects = projects.size

#   current_daily_project_time = (time_avail / SPRINT_DAYS) / num_of_projects
#   smallest_project = projects.select { |name, info| info['time'] == projects.values.min }
#   days_to_complete_smallest_project = smallest_project.first[0][1] / current_daily_project_time
#   days_to_complete_projects += days_to_complete_smallest_project
#   #binding.pry

#   smallest_project.size.times do |i|
#     projects.delete(smallest_project.keys[i])
#   end

#   projects.each do |name, time|
#     projects[name] = time - current_daily_project_time * days_to_complete_smallest_project
#   end
# end

# p days_to_complete_projects


# # Simple hash

# project1 = 'ruby'
# project1_time = 300
# projects = { project1 => project1_time }

# project2 = 'birdhouse'
# project2_time = 180
# projects[project2] = project2_time

# project3 = 'cage'
# project3_time = 180
# projects[project3] = project3_time

# p projects

# time_avail = 840
# SPRINT_DAYS = 14

# uniq_project_times = projects.values.uniq.size
# days_to_complete_projects = 0

# uniq_project_times.times do
#   num_of_projects = projects.size

#   current_daily_project_time = (time_avail / SPRINT_DAYS) / num_of_projects
#   smallest_project = projects.select { |name, time| time == projects.values.min }
#   days_to_complete_smallest_project = smallest_project.first[1] / current_daily_project_time
#   days_to_complete_projects += days_to_complete_smallest_project
#   #binding.pry

#   smallest_project.size.times do |i|
#     projects.delete(smallest_project.keys[i])
#   end

#   projects.each do |name, time|
#     projects[name] = time - current_daily_project_time * days_to_complete_smallest_project
#   end
# end

# p days_to_complete_projects

# #Notes 

# # <!--  -->
# # <!-- <% #end %> -->
# # <!-- <% #if @show_availability_button %> -->
# # <!-- <% #end %> -->
# # <% binding.pry %>