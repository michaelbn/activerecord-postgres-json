# Extends AR to add Json functionality.
module ActiveRecord

  class JsonTypeMismatch < ActiveRecord::ActiveRecordError
  end

  module ConnectionAdapters

    class TableDefinition

      # Adds json type for migrations. So you can add columns to a table like:
      #   create_table :people do |t|
      #     ...
      #     t.json :info
      #     ...
      #   end
      def json(*args)
        options = args.extract_options!
        column_names = args
        column_names.each { |name| column(name, 'json', options) }
      end

    end

    class Table

      # Adds json type for migrations. So you can add columns to a table like:
      #   change_table :people do |t|
      #     ...
      #     t.json :info
      #     ...
      #   end
      def json(*args)
        options = args.extract_options!
        column_names = args
        column_names.each { |name| column(name, 'json', options) }
      end

    end

    class PostgreSQLColumn < Column
      # Does the type casting from json columns using String#from_hstore or Hash#from_hstore.
      def type_cast_code_with_json(var_name)
        type == :json ? "#{var_name}.from_json" : type_cast_code_without_json(var_name)
      end

      # Adds the json type for the column.
      def simplified_type_with_json(field_type)
        field_type == 'json' ? :json : simplified_type_without_json(field_type)
      end

      alias_method_chain :type_cast_code, :json
      alias_method_chain :simplified_type, :json
    end

    class PostgreSQLAdapter < AbstractAdapter
      def native_database_types_with_json
        native_database_types_without_json.merge({:json => { :name => "json" }})
      end

      # Quotes correctly a json column value.
      def quote_with_json(value, column = nil)
        if value && column && column.sql_type == 'json'
          raise JsonTypeMismatch, "#{column.name} must have a Json or a valid json value (#{value})" unless value.kind_of?(Hash) || value.valid_json?
          return quote_without_json(value.to_json, column)
        end
        quote_without_json(value,column)
      end

      alias_method_chain :quote, :json
      alias_method_chain :native_database_types, :json
    end
  end
end


