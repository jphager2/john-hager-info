class ProjectsController < ApplicationController

  def create
    unless params[:name]
      @project = Project.new

      load_github_activity 
      render 'create' 
    else
      Project.create(
        name:        params[:name],
        url:         params[:purl],
        description: params[:description],
      )
      redirect_to controller: :pages, action: :portfolio 
    end
  end

  def update
    unless params[:name]
      @project = Project.find(params[:id])

      load_github_activity 
      render 'edit' 
    else
      @project = Project.find(params[:id])
      @project.update(
        name:        params[:name],
        url:         params[:purl],
        description: params[:description],
      )
      redirect_to controller: :pages, action: :portfolio 
    end

  end

  def destroy
    Project.destroy(params[:id])

    redirect_to root_path 
  end
end
