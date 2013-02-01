# Extends AR to add Json functionality.
module ActiveRecord




  class JsonTypeMismatch < ActiveRecord::ActiveRecordError
  end

  module ConnectionAdapters



    module Quoting
      # Cast a +value+ to a type that the database understands. For example,
      # SQLite does not understand dates, so this method will convert a Date
      # to a String.
      def type_cast(value, column)
        return value.id if value.respond_to?(:quoted_id)

        case value
          when String, ActiveSupport::Multibyte::Chars
            value = value.to_s
            return value unless column

            case column.type
              when :binary then value
              when :integer then value.to_i
              when :float then value.to_f
              else
                value
            end

          when true, false
            if column && column.type == :integer
              value ? 1 : 0
            else
              value ? 't' : 'f'
            end
          # BigDecimals need to be put in a non-normalized form and quoted.
          when nil        then nil
          when BigDecimal then value.to_s('F')
          when Numeric    then value
          when Date, Time then quoted_date(value)
          when Symbol     then value.to_s
          else
            return YAML.dump(value) unless column
            case column.type
              when :json then ActiveRecord::Coders::Json.dump(value);
              else
                YAML.dump(value)
            end
        end
      end
    end


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
          raise JsonTypeMismatch, "#{column.name} must have a Json or a valid json value (#{value})" unless value.kind_of?(Hash)
          return quote_without_json(value.to_json, column)
        end
        quote_without_json(value,column)
      end

      alias_method_chain :quote, :json
      alias_method_chain :native_database_types, :json
    end

  end
end


