require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    DB[:conn].results_as_hash = true

    sql = "PRAGMA table_info('#{table.name}')" #returns array of hashes describing the table itself where each hash has information about one column.

    table_info = DB[:conn].execute(sql)
    column_names = []

    table_info.each do |column| #talbe_info returns a hash because of sql which is Pragma...
      column_names << column["name"] #collecting only the name key for the name column
    end

    column_names.compact
  end

  self.column_names.each do |col_name|
    attr_accessor col_name.to_sym
  end

  def initialize(options={})
    options.each do |property, value|
      self.send("#{property}", value)
    end
  end

  def table_name_for_insert
    self.class.table_name
  end

  def column_name_for_insert
    self.class.column_names.delete_if { |col| col == "id"}.join(", ")
  end

  def values_for_insert
    values = []
    self.class.column_names.each do |col_name|
      values << "'#{send(col_name)}'" unless send(col_name).nil?
  end

end
