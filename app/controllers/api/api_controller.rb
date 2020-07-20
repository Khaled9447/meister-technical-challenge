module API
  class APIController < ActionController::API
    attr_reader :current_user

    protected

    # check if the decoding of the token (if exists) returns a valid user id
    # in case of no token, or invalid user id, the error 'Not Authenticated' will be displayed
    def authenticate_request!
      unless user_id_in_token?
        render json: { errors: ['Not Authenticated'] }, status: :unauthorized
        return
      end
      @current_user = User.find(auth_token[:user_id])
    rescue JWT::VerificationError, JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
    end

    private

    # the bearer token looks like this: 'Bearer token-xyz'
    #   that is why we need to split on white space and get the last element (token)
    def http_token
      @http_token ||= if request.headers['Authorization'].present?
                        request.headers['Authorization'].split(' ').last
      end
    end

    # using JWT library to decode the bearer token and retrieve the user_id
    #   which was used in encoding (along with the secret key)
    def auth_token
      @auth_token ||= JsonWebToken.decode(http_token)
    end

    def user_id_in_token?
      http_token && auth_token && auth_token[:user_id].to_i
    end
  end
end
