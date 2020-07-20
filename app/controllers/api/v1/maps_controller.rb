module API
  module V1
    class MapsController < APIController
      # verifies user authentication & populates `@current_user` (api_controller.rb)
      before_action :authenticate_request!
      before_action :set_map, only: %i[invite publish]
      before_action :set_user, only: %i[index invite]

      ### if params[:username] is not sent at all, display all public maps
      ### if params[:username] is sent and it returns a valid user, then display his public maps
      ### otherwise, display 'no maps found', meaning that params[:username] is sent but username is NOT valid
      # GET /v1/mind-maps  ->  all public maps
      # GET /v1/users/:username/mind-maps  ->  public maps of a user
      def index
        maps = nil
        
        if @user.eql? ''
          maps = Map.published # scope 'published' already includes (:user, :topic) to avoid n+1 problem
        elsif @user.present?
          maps = @user.maps.published
        end

        render json: paginated_maps(maps), status: :ok
      end

      ### Invite other users to have access on maps
      ### by granting them one of the access levels (read, comment or write)
      # POST /v1/mind-maps/:id/invite
      def invite
        if valid_request? && @map.grant_access_for_user(@user, params[:access_level])
          render json: { message: "Inviation has been sent!" }, status: 200
        else
          message = @user.nil? ? "User not found!" : "Could not invite the user (#{@user.username})"
          render json: { message: message }, status: 400
        end
      end

      ### Display the `current_user` maps along with his permissions (read, comment, write or owner).
      ### He can either have personal maps (the ones he created - as an owner)
      ### or permitted maps (the maps which he was granted access to)
      # GET /v1/my-maps
      def my_maps
        # TO-DO: can be refactored
        personal_maps = current_user.maps.includes(:map_permissions)
        permitted_maps = current_user.permitted_maps.includes(:map_permissions)

        render status: :ok, json: {
          personal_maps: ActiveModel::Serializer::CollectionSerializer.new(
            personal_maps, serializer: MyMapSerializer, current_user: @current_user
          ),
          other_maps: ActiveModel::Serializer::CollectionSerializer.new(
            permitted_maps, serializer: MyMapSerializer, current_user: @current_user
          )
        }
      end

      ### publich a map so all users can view it
      # PATCH /v1/mind-maps/:id/publish
      def publish
        if valid_request? && @map.publish
          render json: { message: 'Your map is now public!' }, status: 200
        else
          render json: { message: 'Cannot publish this map, please try again later!' }, status: 400
        end
      end

      private

      # meta data related to paginating maps to provide the frontend
      # with pagination details so they can request next page and display related info
      # to the users (like total number of maps)
      def meta_data maps
        {
          current_page: maps.current_page,
          per_page: maps.per_page,
          total_maps: maps.total_entries,
        }
      end

      # Checks for the sent page (from the client side) and displays the public maps
      # in that page, along with the meta data for future requests.
      def paginated_maps maps
        return { message: "No maps found" } if maps.nil?

        page = (params[:page].to_i <= 0) ? nil : params[:page]
        maps = maps.paginate(page: page, per_page: Map::PER_PAGE)
        {
          maps: ActiveModel::Serializer::CollectionSerializer.new(maps, each_serializer: MapSerializer),
          meta: meta_data(maps)
        }
      end

      # initialize the map with the id sent in request
      def set_map
        @map = Map.find_by_id(params[:id])
      end

      # initialize the user with the id sent in request
      # if the username is not sent, then set @user to empty string ('')
      # to be used in `index` action to determine whether to display all public maps
      # or just public maps of a user (if the user didn't exist, 'no maps found' is returned)
      def set_user
        @user = params[:username].present? ? User.find_by_username(params[:username]) : ''
      end

      # checks that map exists first (the passed parameter is a valid map id) and checks if the 
      # action requested (invite, share) by the currnt_user can be done if he is the owner 
      # (or have specific permissions for invite and share that can be added in the future)
      def valid_request?
        @map && @map.permitted_user?(@current_user)
      end
    end
  end
end
