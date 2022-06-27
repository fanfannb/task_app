# Task App

## I. Getting Started

After you have cloned this project to your `task_app` folder, be sure to do the following steps:

1. run `bundle install`. The `Gemfile` to include a number of third-party gems that you'll work with in this task including `bootstrap` (for style), `devise`(for user authentication).
2. run `rails db:create`, `rails db:migrate` to establish the database. The `Task App` code automatically uses `postgres`, so you don't need to configure it.
3. run `rails ` and see what the `Task App` code does for you.

We should see a login page on `localhost:3000`, where you'll see a navbar. If you click on any of the links, you will get different function page. 

### Understanding the Task App Code

* We configured bootstrap and some custom CSS in `/assets/stylesheets/application.scss`. These styles follow the [Bootstrap](https://v3.bootcss.com/components/).
* We set the root to `tasks#index`, created a `TasksController`, and wrote the homepage with HTML `/views/tasks/index.html.erb`.
* We provided `/views/layouts/_navbar.html.erb`, a partial used in `/views/layouts/application.html.erb`. 
* We created the `Task` model and `User` model.The `User` has a one-to-many association with `tasks`. It doesn't have controller and views.
* We use `gem 'devise'` generate register and  login form.

### Understanding the Features

To understand the expected result of this project：

You can try signing up once，add a task and assign a task to another user, edit task, delete task, log out, log in, etc.

## II. Generating Scaffolds and Models

The first task of this project is for you to figure out the CRUD models. There are 2 models involved: `Task`, `User`  `(which is just a join-table for tasks and user)`. The relationship/association between the two models are as such:

<img src="https://witcanmarkdown.oss-cn-beijing.aliyuncs.com/image-20220625223053918.png" alt="image-20220625223053918" style="zoom:50%;" />

As you can see:

We should now get started with generating scaffolds and models for these classes using the correct `rails g` commands. Recall that if you made a mistake during `rails g`, you can use `rails destroy` to reverse your action.

`rails generate devise User `

`rails g model tasks title:string content:text deadline:datetime user_id:integer:index status:integer`

### Specification for Models

#### Task

The `Task` model should have a `user` of type `references`,  a `deadline` of type `datetime`,  a `status` of type `integer`, a `title` of type `string`, a `content` of type `text`, and `creator`of type `integer`. It needs a controller and views, so it's better to use `scaffold` generator.

`rails g scaffold tasks title:string content:text deadline:datetime user_id:integer:index creator_id:integer:index status:integer`

#### User

The `User` model should have `name` and `email`, and a `password_hash` field to store passwords hashed by `BCrypt`.

Be sure to run `rails db:migrate`!

Devise 4.0 works with Rails 4.1 onwards. Add the following line to your Gemfile:

```
gem 'devise'
```

Then run `bundle install`

Next, you need to run the generator:

```
$ rails generate devise:install
```

At this point, a number of instructions will appear in the console. Among these instructions, you'll need to set up the default URL options for the Devise mailer in each environment. Here is a possible configuration for `config/environments/development.rb`:

```
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

The generator will install an initializer which describes ALL of Devise's configuration options. It is *imperative* that you take a look at it. When you are done, you are ready to add Devise to any of your models using the generator.

In the following command you will replace `MODEL` with the class name used for the application’s users (it’s frequently `User` but could also be `Admin`). This will create a model (if one does not exist) and configure it with the default Devise modules. The generator also configures your `config/routes.rb` file to point to the Devise controller.

```
$ rails generate devise MODEL
```

Next, check the MODEL for any additional configuration options you might want to add, such as confirmable or lockable. If you add an option, be sure to inspect the migration file (created by the generator if your ORM supports them) and uncomment the appropriate section. For example, if you add the confirmable option in the model, you'll need to uncomment the Confirmable section in the migration.

Then run `rails db:migrate`

We should restart your application after changing Devise's configuration options (this includes stopping spring). Otherwise, you will run into strange errors, for example, users being unable to login and route helpers being undefined.

### Controller filters and helpers

Devise will create some helpers to use inside your controllers and views. To set up a controller with user authentication, just add this before_action (assuming your devise model is 'User'):

```
before_action :authenticate_user!
```

For Rails 5, note that `protect_from_forgery` is no longer prepended to the `before_action` chain, so if you have set `authenticate_user` before `protect_from_forgery`, your request will result in "Can't verify CSRF token authenticity." To resolve this, either change the order in which you call them, or use `protect_from_forgery prepend: true`.

If your devise model is something other than User, replace "_user" with "_yourmodel". The same logic applies to the instructions below.

To verify if a user is signed in, use the following helper:

```
user_signed_in?
```

For the current signed-in user, this helper is available:

```
current_user
```

### Validations, Arel and Custom Methods

While our models have our desired attributes, they are far from complete. We want to add some validations as well as describe some custom methods for these models to make our lives easier. 

#### Task

1. We should validate that the `title`, `content`, `deadline`, and `status` are always present. 
2. We should set `status` as enum.
3. We should add `user` build relationship use `belongs_to` .

#### User

1. We should validate that the `name`, `email`.

2. We should add `tasks` build relationship use `has_many` .

3. The Devise method in your models also accepts some options to configure its modules. For example, you can choose the cost of the hashing algorithm with:

   ```
   devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
   ```

   Besides `:stretches`, you can define `:pepper`, `:encryptor`, `:confirm_within`, `:remember_for`, `:timeout_in`, `:unlock_in` among other options. For more details, see the initializer file that was created when you invoked the "devise:install" generator described above. This file is usually located at `/config/initializers/devise.rb`.




## III. User Authentication

### The Devise wiki

The Devise Wiki has lots of additional information about Devise including many "how-to" articles and answers to the most frequently asked questions.

https://github.com/heartcombo/devise/wiki

### Implementing Routes, Views and SessionsController for Authentication.

### Configuring views

We built Devise to help you quickly develop an application that uses authentication. However, we don't want to be in your way when you need to customize it.

Since Devise is an engine, all its views are packaged inside the gem. These views will help you get started, but after some time you may want to change them. If this is the case, you just need to invoke the following generator, and it will copy all views to your application:

```
$ rails generate devise:views
```

If you have more than one Devise model in your application (such as `User` and `Admin`), you will notice that Devise uses the same views for all models. Fortunately, Devise offers an easy way to customize views. All you need to do is set `config.scoped_views = true` inside the `config/initializers/devise.rb` file.

After doing so, you will be able to have views based on the role like `users/sessions/new` and `admins/sessions/new`. If no view is found within the scope, Devise will use the default view at `devise/sessions/new`. You can also use the generator to generate scoped views:

```
$ rails generate devise:views users
```

If you would like to generate only a few sets of views, like the ones for the `registerable` and `confirmable` module, you can pass a list of modules to the generator with the `-v` flag.

```
$ rails generate devise:views -v registrations confirmations
```


### Configuring ApplicationController

When you customize your own views, you may end up adding new attributes to forms. Rails 4 moved the parameter sanitization from the model to the controller, causing Devise to handle this concern at the controller as well.

There are just three actions in Devise that allow any set of parameters to be passed down to the model, therefore requiring sanitization. Their names and default permitted parameters are:

- `sign_in` (`Devise::SessionsController#create`) - Permits only the authentication keys (like `email`)
- `sign_up` (`Devise::RegistrationsController#create`) - Permits authentication keys plus `password` and `password_confirmation`
- `account_update` (`Devise::RegistrationsController#update`) - Permits authentication keys plus `password`, `password_confirmation` and `current_password`

In case you want to permit additional parameters (the lazy way™), you can do so using a simple before action in your `ApplicationController`:

```
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
```

### Customizing Views

We built Devise to help you quickly develop an application that uses authentication. However, we don't want to be in your way when you need to customize it.

Since Devise is an engine, all its views are packaged inside the gem. These views will help you get started, but after some time you may want to change them. If this is the case, you just need to invoke the following generator, and it will copy all views to your application:

```
$ rails generate devise:views
```

If you have more than one Devise model in your application (such as `User` and `Admin`), you will notice that Devise uses the same views for all models. Fortunately, Devise offers an easy way to customize views. All you need to do is set `config.scoped_views = true` inside the `config/initializers/devise.rb` file.

## IV. Task Manage

### Routes for `TasksController`

You'll need to modify `routes.rb` to add 8 routes, one for CRUD `task`. The HTTP methods and the paths are completely up to you, although our recommended combination is:

- GET    /tasks
- POST   /tasks
- GET    /tasks/new
- GET    /tasks/:id/edit
- GET    /tasks/:id
- PATCH  /tasks/:id
- PUT    /tasks/:id
- DELETE /tasks/:id

You can also use routes `resources :tasks`. it will generate above content.

### Methods in `TasksController`

`index` : Homepage.

`show` : Task detail page.

`new` : Task new page.

`edit` : Task edit page.

`create` : Task create action, it doesn't need views support.

`update` : Task update action, it doesn't need views support.

`destroy` : Task destroy action, it doesn't need views support.

`set_task` : `show` , `edit`, `update` and `destroy` use it to find task by `params[:id]`.

`check_task_auth` : Only the creator of the task can update task that created by himself.

`task_params` : `create` or `update` use strong params to create or update task.

### Views for Tasks

`index.html.erb` it returns task List, when params include `type` and value is `my`, it will show tasks relevant to you.If no parameters are included, it will show all.

![image-20220626002608741](https://witcanmarkdown.oss-cn-beijing.aliyuncs.com/image-20220626002608741.png)

`show.html.erb` include like content, deadline, status and assign tasks to other user.

![image-20220626002544649](https://witcanmarkdown.oss-cn-beijing.aliyuncs.com/image-20220626002544649.png)

`new.html.erb `  create task form

`edit.html.erb  `edit task form

`_form.html.erb` common code snippets used to create and update forms, the status bar does not display `done` status when creating new ones.

<img src="https://witcanmarkdown.oss-cn-beijing.aliyuncs.com/image-20220626002450762.png" alt="image-20220626002450762" style="zoom:50%;" />

`_task.html.erb` single task code snippets.

## V. Additional Function

### Tasks Search:

`Ransack` will help you easily add **searching to your Rails application**, without any additional dependencies.

#### In your controller

```ruby
def index
  @q = Task.ransack(params[:q])
  @tasks = @q.result(distinct: true)
end
```

or without `distinct: true`, for sorting on an associated table's columns (in this example, with preloading each Person's Articles and pagination):

```ruby
def index
  @q = Task.ransack(params[:q])
  @tasks = @q.result.includes(:articles)
end
```

#### In your views 

`index.html.erb` Search if the title field contains

```ruby
<%= search_form_for @q do |f| %>
  <%= hidden_field_tag :type, params[:type] %>
  <%= f.search_field :title_cont, class: 'form-control', style: 'width: 200px;', placeholder: 'please input title...' %>
  <div class="input-group-btn">
    <%= f.button 'Search', class: 'btn btn-default' %>
  </div>
<% end %>
```

