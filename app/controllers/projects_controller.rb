class ProjectsController < OnedriveClientController

  skip_before_action :authenticate_user, only: [:show]
  layout 'application', only: [:show]

  before_action :set_project, except: [:index, :new, :create]
  before_action :set_client, only: [:index, :new, :edit]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.create(project_params)
    create_project_image if params[:project][:image]
    redirect_to action: :index
  end

  def show
    respond_to do |f|
      f.html {}
      f.pdf do
        render pdf: @project.name, layout: 'pdf.html.erb', disposition: 'attachment'
      end
    end
  end

  def edit
  end

  def update
    @project.update(project_params)
    create_project_image if project_params[:image]
    redirect_to action: :index
  end

  def destroy
    @project.destroy
    redirect_to action: :index
  end

  def update_image
    @project.image.update_data(@client)
    redirect_to action: :index
  end

  private
  def project_params
    params.require(:project).permit(:name, :url, :description)
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def create_project_image
    image = Image.upload(@client, params[:project][:image])
    image.update_attribute(:project_id, @project.id) if image
  end
end
