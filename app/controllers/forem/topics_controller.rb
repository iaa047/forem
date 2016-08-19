require_dependency "forem/application_controller"

module Forem
  class TopicsController < ApplicationController
    before_action :set_forum
    before_action :set_topic, only: :show
    def new
      @topic = @forum.topics.build
    end
    def index
      @topics = @forum.topics.page(params[:page]).per(params[:per_page])
      respond_to do |format|
        format.html { render }
        format.json { render json: @topics, status: :ok }
      end
    end

    def show
      @posts = @topic.posts.page(params[:page]).per(params[:per_page])
      respond_to do |format|
        format.html { render }
        format.json { render json: @topic, status: :ok }
      end
    end

    def create
      @topic = @forum.topics.create(topic_params)
      # @topic.user_id = current_user.id
      @topic.user_id = 1
      respond_to do |format|
        if @topic.save
          format.html { redirect_to forum_path(@forum.permalink), notice: 'Topic was successfully created.' }
          format.json { render json: @topic, status: :created, location: @topic }
        else
          format.html { render action: 'new' }
          format.json { render json: @topic.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_forum
      @forum = Forum.find_by(permalink: params[:forum_permalink])
      unless @forum
        respond_to do |format|
          format.html { redirect_to forums_path, notice: 'Forum not found' }
          format.json { render json: { error: 'Forum not found' }, status: :not_found }
        end
      end
    end

    def set_topic
      @topic = @forum.topics.find_by(permalink: params[:permalink])
      unless @topic
        respond_to do |format|
          format.html { redirect_to forums_path, notice: 'Topic not found' }
          format.json { render json: { error: 'Topic not found' }, status: :not_found }
        end
      end
    end

    def topic_params
      params.require(:topic).permit(:title, :description)
    end

  end
end
