class ProjectsController < ApplicationController

  def create
    redirect_to root_path unless signed_in?
    unless params[:name]
      @project = Project.new

      load_github_activity 
      render 'create' 
      return
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
    redirect_to root_path unless signed_in?
    unless params[:name]
      @project = Project.find(params[:id])

      load_github_activity 
      render 'edit' 
      return
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
    redirect_to root_path unless signed_in?
    Project.destroy(params[:id])

    redirect_to root_path 
  end
end
