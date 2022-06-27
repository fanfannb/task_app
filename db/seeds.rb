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

user.tasks.create(title: 'task_c', content: 'task_c_content', deadline: Time.now)
user.tasks.where('deadline < ?', Time.now)
user.tasks.where(deadline: Time.now.beginning_of_day..Time.now.end_of_day)
user.tasks.where('deadline > ?', Time.now+1.week)
user.tasks.where('deadline > ?', Time.now+1.month)
user.tasks.where("title LIKE '%作业'")
user.tasks.done
# 重复的
user.tasks.first.updated_at
user.tasks.last.title
user.tasks.todo.update_all(status: 'doing')

user.tasks.each_with_index do |task, index|
  task.update(title: "作业委托(#{index})")
end

Task.all.where(user_id: user.id).update_all(user_id: user_b.id)

Task.last.update(title: 'test')

@task = Task.last
@task.update(title: 'test')

Task.first.destroy

@task.destroy

Task.where(user_id: user_b.id).destroy_all