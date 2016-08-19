require_dependency "forem/application_controller"

module Forem
  class ForumsController < ApplicationController
    before_action :set_forum, only: :show

    def index
      @forums = Forum.page(params[:page]).per(params[:per_page])
      respond_to do |format|
        format.html { render }
        format.json { render json: @forums, status: :ok }
      end
    end

    def show
      respond_to do |format|
        format.html { render }
        format.json { render json: @forum, status: :ok }
      end
    end

    private

    def set_forum
      @forum = Forum.find_by(permalink: params[:permalink])
      unless @forum
        respond_to do |format|
          format.html { redirect_to forums_path, notice: 'Forum not found' }
          format.json { render nothing: true, status: :not_found }
        end
      end
    end

  end
end
