require 'simple_form'
require 'emoji'
require 'select2-rails'
require 'kaminari'

module ::Forem
  class Engine < Rails::Engine
    isolate_namespace Forem

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end

    config.to_prepare do
      Decorators.register! Engine.root, Rails.root
    end

    # Precompile any assets included straight in certain pges
    initializer "forem.assets.precompile", :group => :all do |app|
      app.config.assets.precompile += %w[
        forem/admin/members.js
      ]
    end
  end
end
