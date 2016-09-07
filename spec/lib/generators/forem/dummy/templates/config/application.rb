require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require
require "forem"
# Need to load Devise manually at this point so that the autoload hooks are loaded
# Otherwise it will bomb out because it cannot find Devise::SessionsController
require "devise"
require "devise/rails"
require 'jquery-rails'

# Need to require `bullet` here in order to use `Bullet` in `test.rb`
require 'bullet'

<%= application_definition %>
