module Spree
  UserRegistrationsController.class_eval do

    private

    def spree_user_params
      params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes, :first_name, :last_name)
    end
  end
end

