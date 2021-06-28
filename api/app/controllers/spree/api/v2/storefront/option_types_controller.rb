module Spree
  module Api
    module V2
      module Storefront
        class OptionTypesController < ::Spree::Api::V2::ResourceController
          private

          def collection_serializer
            Spree::Api::Dependencies.storefront_option_type_serializer.constantize
          end

          def resource_serializer
            Spree::Api::Dependencies.storefront_option_type_serializer.constantize
          end

          def collection_finder
            Spree::Api::Dependencies.storefront_option_type_finder.constantize
          end

          def paginated_collection
            @paginated_collection ||= collection_paginator.new(collection, params).call
          end

          def resource
            @resource ||= scope.find_by(name: params[:id]) || scope.find(params[:id])
          end

          def model_class
            Spree::OptionType
          end
        end
      end
    end
  end
end
