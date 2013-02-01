require 'active_support'
require 'json'

if RUBY_PLATFORM == "jruby"
  require 'activerecord-jdbcpostgresql-adapter'
else
  require 'pg'
end

if defined? Rails
  require "activerecord-postgres-json/railties"
else
  ActiveSupport.on_load :active_record do
    require "activerecord-postgres-json/activerecord"
  end
end
require "activerecord-postgres-json/coder"
require "activerecord-postgres-json/string"
require "activerecord-postgres-json/hash"