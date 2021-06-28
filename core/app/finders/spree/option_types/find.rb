module Spree
  module OptionTypes
    class Find
      def initialize(scope:, params:)
        @scope = scope
        @ids = String(params.dig(:filter, :ids)).split(',')
        @name = params.dig(:filter, :name)
        @filterable = params.dig(:filter, :filterable)
      end

      def execute
        option_types = by_ids(scope)
        option_types = by_name(option_types)
        option_types = only_filterable(option_types)

        option_types
      end

      private

      attr_reader :ids, :name, :filterable

      def ids?
        ids.present?
      end

      def name?
        name.present?
      end

      def filterable?
        filterable.present?
      end

      def name_matcher
        Spree::OptionType.arel_table[:name].matches("%#{name}%")
      end

      def by_ids(option_types)
        return option_types unless ids?

        option_types.where(id: ids)
      end

      def by_name(option_types)
        return option_types unless name?

        option_types.where(name_matcher)
      end

      def only_filterable(option_types)
        return option_types unless filterable?

        option_types.filterable
      end
    end
  end
end
