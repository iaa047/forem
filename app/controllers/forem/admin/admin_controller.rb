module Forem
  module Admin
    class AdminController < ActionController::Base
      protect_from_forgery with: :exception
    end
  end
end
