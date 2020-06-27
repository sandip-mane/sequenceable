# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "sequenceable"
require "minitest/autorun"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

require 'support/schema'
require 'support/models'

def teardown_db
  ActiveRecord::Base.connection.data_sources.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
