require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def self.table_name
    self.to_s.downcase.pluralize
  end

  def column_names
    DB[:conn].results_as_hash = true

    sql = "PRAGMA table_info('#{table.name}')"

    table_info = DB[:conn].execute(sql)

  end




end
