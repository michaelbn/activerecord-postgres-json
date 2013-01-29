module ActiveRecord
  module Coders
    class Json
      def self.load(json)
        new.load(json)
      end

      def self.dump(json)
        new.dump(json)
      end

      def initialize(json=nil)
        @default=json
      end

      # this might be the database default and we should plan for empty strings or nils
      def load(s)
        s.present? ? JSON.load(s) : @default.clone
      end

      # this should only be nil or an object that serializes to JSON (like a hash or array)
      def dump(o)
        JSON.dump(o || @default)
      end
    end
  end
end