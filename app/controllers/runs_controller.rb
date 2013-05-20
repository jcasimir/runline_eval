class RunsController < ApplicationController

  def create
    params[:run][:organizer_id] = current_user.id
    friends = params[:friends].gsub(" ", "").split(",")
    run = Run.create_with_invitees(friends, params[:run])

    redirect_to run
  end

  def show
    @run = Run.find_by_id(params[:id])
  end

  def new
    @run = Run.new
    @routes = Route.all
  end

end


