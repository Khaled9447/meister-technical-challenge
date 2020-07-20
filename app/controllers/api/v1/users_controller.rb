module API
  module V1
    class UsersController < APIController
      # verifies user authentication & populates `@current_user` (api_controller.rb)
      before_action :authenticate_request!

      # Usually the avatar is part of the user's information, like name, mobile .. etc.
      # So it is better to wrap all of these information in one endpoint
      #   instead of creating a separate endpoint for avatar uploading
      def edit_profile
        if current_user.update(user_params)
          render json: { message: 'User information updated successfully!' }, status: 200
        else
          render json: { message: 'User information could not be updated' }, status: 422
        end
      end

      private

      # White-listing the needed parameters only
      def user_params
        params.permit(:avatar)
      end
    end
  end
end
