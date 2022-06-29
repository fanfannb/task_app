class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[ show assign edit update destroy ]
  before_action :check_task_auth, only: %i[ edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    if params[:type] == 'my'
      @tasks = current_user.tasks.where.not(status: '完了')
    else
      @tasks = Task.all
    end

    @q = @tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  def assign
  end

  # GET /tasks/new
  def new
    @task = Task.new(status: '未対応')
  end

  # GET /tasks/1/edit
  def edit
    origin_url
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params.merge!(creator_id: current_user.id))

    respond_to do |format|
      if @task.save
        format.html { redirect_to task_url(@task), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update!(task_params)
        format.html { redirect_to cookies[:refer] || tasks_path, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def check_task_auth
      redirect_to tasks_path, notice: 'no auth' and return if @task.creator_id != current_user.id
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :deadline, :user_id, :status)
    end

    def origin_url
      cookies[:refer] = request.referer || tasks_path
    end
end
