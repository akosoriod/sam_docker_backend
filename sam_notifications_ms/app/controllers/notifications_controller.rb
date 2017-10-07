class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :update, :destroy]

  # GET /notifications
  def index
    first_result = params['firstResult']
    max_result = params['maxResult']
    if (is_numeric(first_result) || first_result.nil?) && (is_numeric(max_result) || max_result.nil?)
      @notifications = Notification.all
      list_json = [
        "total": Notification.count,
        "list": @notifications
      ]
      render :json => list_json
      #render json: @notifications
    else
      render status: 406
    end
  end

  def set_app
    app = Rpush::Gcm::App.new
    app.name = "android_app"
    app.auth_key = "..."
    app.connections = 1
    app.save!
  end

  def create_push(username, sender)
    if !Rpush::Gcm::App.find_by_name("android_app")
      set_app
    end
    @devices = UserDevice.get_device_id(username)
    for i in @devices
      n = Rpush::Gcm::Notification.new
      n.app = Rpush::Gcm::App.find_by_name("android_app")
      n.registration_ids = [i.device_id]
      n.data = { message: "You got a new message from!"+sender}
      n.save!
      Rpush.push
      Rpush.apns_feedback
    end
  end

  # GET /notifications/1
  def show
    render json: @notification
  end

  # POST /notifications
  def create
    @notification = Notification.new(notification_params)

    if @notification.save
      create_push(@notification.username, @notification.sender)
      render status: :created
      #render json: @notification, status: :created, location: @notification
    else
      render status: :bad_request
      #render json: @notification.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notifications/1
  def update
    if @notification.update(notification_params)
      render status: 204
      #render json: @notification
    else
      render status: 406
      #render json: @notification.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notifications/1
  def destroy
    @notification.destroy
  end

  private

  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from(ActionController::UnpermittedParameters) do |pme|
    render status: :bad_request
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    #@notification = Notification.find(params[:id])
    id = params[:id]
    if is_numeric(id)
      @notification = Notification.find(id)
    else
      render status: 406
    end
  end

  # Only allow a trusted parameter "white list" through.
  def notification_params
    params.require(:notification).permit(:username, :sender)
  end

  def is_numeric(o)
    true if Integer(o) rescue false
  end
end
