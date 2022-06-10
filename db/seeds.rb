user_a = User.create(name: 'userA', email: 'user_a@gmail.com', password: 'usera123')
user_b = User.create(name: 'userB', email: 'user_b@gmail.com', password: 'userb123')
user_a.update(password: 'usera456')
user_b.update(email: 'changed_user_b@gmail.com')

task_a = Task.new(title: 'task_a', content: 'task_a_content', deadline: Time.now, creator_id: user_a.id, user_id: user_a.id)
task_a.save

Task.create(title: 'task_b', content: 'task_b_content', deadline: Time.now, creator_id: user_b.id, user_id: user_b.id)

10.times do |num|
  Task.create(title: "task_#{num}", content: "task_#{num}_content", deadline: Time.now, creator_id: user_a.id, user_id: user_a.id)
end

Task.all
Task.first
Task.find(1)
Task.last

user = User.find_by(name: 'userA')
user.tasks

User.find_by(name: 'userB').tasks
User.find_by(name: 'userA').tasks.count

Task.all.map { |task| task.id }
Task.all.pluck(:id)
Task.all.ids
Task.all.map { |task| task.title }
Task.all.pluck(:title)
