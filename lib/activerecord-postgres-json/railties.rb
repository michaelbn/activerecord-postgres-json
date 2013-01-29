require 'rails'
require 'rails/generators'
require 'rails/generators/migration'

# = Json Railtie
#
# Creates a new railtie for 1 reasons:
#
# * Initialize ActiveRecord properly
class Json < Rails::Railtie

  initializer 'activerecord-postgres-json' do
    ActiveSupport.on_load :active_record do
      require "activerecord-postgres-json/activerecord"
    end
  end

end

