module Spree
  module Api
    module V1
      OptionValuesController.class_eval do

        def find_or_create
          authorize! :create, Spree::OptionValue
          @option_value = scope.find_or_create_by(name: params[:name]) do |option_value|
            option_value.presentation = params[:presentation]
          end
          if @option_value
            render :show, status: 201
          else
            invalid_resource!(@option_value)
          end
        end
      end
    end
  end
end