require_dependency "forem/application_controller"

module Forem
  class PostsController < ApplicationController
    before_action :set_forum
    before_action :set_topic
    before_action :set_post, only: :show
    def new
      @post = @topic.posts.build
    end

    def show
      respond_to do |format|
        format.html { render }
        format.json { render json: @post, status: :ok }
      end
    end

    def create
      @post = @topic.posts.create(post_params)
      # @post.user_id = current_user.id
      @post.user_id = 1
      respond_to do |format|
        if @post.save
          format.html { redirect_to forum_topic_path(@forum.permalink, @topic.permalink), notice: 'Post was successfully created.' }
          format.json { render json: @post, status: :created, location: @post }
        else
          format.html { render action: 'new' }
          format.json { render json: @post.errors, status: :unprocessable_entity }
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
      @topic = @forum.topics.find_by(permalink: params[:topic_permalink])
      unless @topic
        respond_to do |format|
          format.html { redirect_to forums_path, notice: 'Topic not found' }
          format.json { render json: { error: 'Topic not found' }, status: :not_found }
        end
      end
    end

    def set_post
      @post = @topic.posts.find_by(id: params[:id])
      unless @post
        respond_to do |format|
          format.html { redirect_to forum_topic_path(@forum.permalink, @topic.permalink), notice: 'Post not found' }
          format.json { render json: { error: 'Post not found' }, status: :not_found }
        end
      end
    end

    def post_params
      params.require(:post).permit(:body, :reply_to)
    end

  end
end
