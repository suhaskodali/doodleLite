class OptionsController < ApplicationController
  before_action :set_option, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index,:show,:edit, :update]
  before_action :correct_user, only: [:show,:edit, :update]
  include SessionsHelper

  # GET /options
  # GET /options.json
  def index
    @options = Option.all
  end

  # GET /options/1
  # GET /options/1.json
  def show

  end

  # GET /options/new
  def new
    @option = Option.new
  end

  # GET /options/1/edit
  def edit
  end

  # POST /options
  # POST /options.json
  def create
    @option = Option.new(option_params)

    # The if statement isn't working very well
    if !params[:add_option].nil?
      @option.save
      flash[:success] = 'Option added!'
      redirect_to @option.poll
    else
      respond_to do |format|
        if @option.save
          format.html { redirect_to @option.poll, notice: 'Option was successfully created.' }
          format.json { render :show, status: :created, location: @option }
        else
          format.html { render :new }
          format.json { render json: @option.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /options/1
  # PATCH/PUT /options/1.json
  def update
    respond_to do |format|
      if @option.update(option_params)
        format.html { redirect_to @option, notice: 'Option was successfully updated.' }
        format.json { render :show, status: :ok, location: @option }
      else
        format.html { render :edit }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /options/1
  # DELETE /options/1.json
  def destroy
    @option.destroy
    respond_to do |format|
      format.html { redirect_to options_url, notice: 'Option was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_option
      @option = Option.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def option_params
      params.require(:option).permit(:poll_id, :name, :numVotes)
    end

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
end
