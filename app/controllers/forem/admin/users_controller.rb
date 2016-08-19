require_dependency "forem/admin/admin_controller"

module Forem
  module Admin
    class UsersController < AdminController
      before_action :set_forum, only: [:edit, :update]

      def index
        @user = User.page(params[:page]).per(params[:per_page])
        respond_to do |format|
          format.html { render }
          format.json { render json: @forums, status: :ok }
        end
      end

      def new
        @forum = Forum.new
      end

      def edit
      end

      def create
        @forum = Forum.new(forum_params)
        #  @forum.user_id = current_user.id
        @forum.user_id = 1
        respond_to do |format|
          if @forum.save
            format.html { redirect_to forum_path(@forum.permalink), notice: 'Forum was successfully created.' }
            format.json { render json: @forum, status: :created, location: @forum }
          else
            format.html { render action: 'new' }
            format.json { render json: @forum.errors, status: :unprocessable_entity }
          end
        end
      end

      def update
        respond_to do |format|
          if @forum.update(forum_params)
            format.html { redirect_to forum_path(@forum.permalink), notice: 'Forum was successfully updated.' }
            format.json { render json: @forum, status: :created, location: @forum }
          else
            format.html { render action: 'edit' }
            format.json { render json: @forum.errors, status: :unprocessable_entity }
          end
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email)
      end

    end
  end
end
