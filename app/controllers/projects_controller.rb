class ProjectsController < ApplicationController

  def create
    unless signed_in?
      redirect_to root_path 
      return
    end

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
      return
    end
  end

  def read
    @project = Project.find(params[:id])
    respond_to do |f|
      f.html do
        load_github_activity
      end
      f.pdf do
        render pdf: "read", show_as_html: false, layout: 'pdf.html.erb'
      end
    end
  end

  def update
    unless signed_in?
      redirect_to root_path 
      return
    end

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
    unless signed_in?
      redirect_to root_path 
      return
    end

    Project.destroy(params[:id])

    redirect_to root_path 
  end
end
