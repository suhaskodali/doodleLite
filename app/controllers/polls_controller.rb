class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index,:show,:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  include SessionsHelper
  # GET /polls
  # GET /polls.json
  def index
    @polls = Poll.all
  end

  # GET /polls/1
  # GET /polls/1.json
  def show


    @poll = Poll.find(params[:id])
    @options = @poll.options
    @new_option = Option.new(poll_id: @poll.id)

    if request.post?
      option_ids = params[:option_ids].collect {|id| id.to_i} if params[:option_ids]
      option_ids.each do |id|
        o = Option.find_by_id(id)
        o.numVotes = o.numVotes+1
      end
    end
  end

  # PUT/PATCH /polls/1
  def vote



      if request.patch?
        option_ids = params[:option_ids] #.collect {|id| id.to_i}
        option_ids.each do |id|
          o = Option.find_by_id(id)
          o.update_attributes(numVotes: (o.numVotes+1))
        end
        respond_to do |format|
            format.html { redirect_to request.referrer, notice: 'Poll was successfully updated.' }
            format.json { render :show, status: :created, location: request.referrer }
        end
      end




  end

  # GET /polls/new
  def new
    @poll = Poll.new
  end

  # GET /polls/1/edit
  def edit
  end

  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.new(poll_params)

    respond_to do |format|
      if @poll.save
        format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
        format.json { render :show, status: :created, location: @poll }
      else
        format.html { render :new }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /polls/1
  # PATCH/PUT /polls/1.json
  def update
    respond_to do |format|
      if @poll.update(poll_params)
        format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    @poll.destroy
    respond_to do |format|
      format.html { redirect_to polls_url, notice: 'Poll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      params.require(:poll).permit(:title, :description, :user_id, :totalVotes)
    end


    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = 'Please log in.'
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        flash[:danger] = 'You are not authorized to do that.'
        redirect_to(root_url)
      end
    end

    def poll_option_id_params
      params.require(:poll).permit(:option_ids)

    end
end
