class IntentsController < ApplicationController
  before_action :set_intent, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :set_api_ai_client, only: [:create, :update, :destroy]


  # GET /intents
  # GET /intents.json
  def index
    @intents = Intent.all
  end

  # GET /intents/1
  # GET /intents/1.json
  def show
  end

  # GET /intents/new
  def new
    @intent = Intent.new
  end

  # GET /intents/1/edit
  def edit
  end

  # POST /intents
  # POST /intents.json
  def create
    intent_request = @api_ai_client.create_intents_request
    response       = intent_request.create(param_options)
    @intent = Intent.new(intent_params)

    respond_to do |format|
      if response.is_a?(Hash) && response[:status][:code].eql?(200)
        @intent.intent_id = response[:id]
        if @intent.save!
          format.html { redirect_to @intent, notice: 'Intent was successfully created.' }
          format.json { render :show, status: :created, location: @intent }
        else
          format.html { render :new }
          format.json { render json: @intent.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to new_intent_path, alert: 'Failed to create entity.'}
      end
    end
  end

  # PATCH/PUT /intents/1
  # PATCH/PUT /intents/1.json
  def update
    intent_request = @api_ai_client.create_intents_request
    response       = intent_request.update(@intent.intent_id, param_options)

    respond_to do |format|
      if response.is_a?(Hash) && response[:status][:code].eql?(200)
        if @intent.update(intent_params)
          format.html { redirect_to @intent, notice: 'Intent was successfully updated.' }
          format.json { render :show, status: :ok, location: @intent }
        else
          format.html { render :edit }
          format.json { render json: @intent.errors, status: :unprocessable_entity }
        end
      else
        @notice = response.message

        format.html { render :new }
        format.json { render json: { error: response.message }, status: response.code}
      end
    end
  end

  # DELETE /intents/1
  # DELETE /intents/1.json
  def destroy
    intent_request = @api_ai_client.create_intents_request
    response       = intent_request.delete(@intent.intent_id)

    @intent.destroy
    respond_to do |format|
      format.html { redirect_to intents_url, notice: 'Intent was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def param_options
    user_says_data = []
    responses = []

    if intent_params[:intent_user_says_attributes].nil?
      intent_params[:intent_user_says_attributes] = ""
    else
      intent_params[:intent_user_says_attributes].each do |k, us|
        user_says_data << ApiAiRuby::UserSayData.new(us[:text], "categories", "@categories")
      end
    end

    if intent_params[:intent_responses_attributes].nil?
      intent_params[:intent_responses_attributes] = ""
    else
      intent_aff_contexts = []
      intent_parameters = []
      intent_params[:intent_responses_attributes].each do |k, r|
        intent_aff_contexts << ApiAiRuby::AffectedContext.new(intent_params[:name].downcase.tr(" ","-"), "10")
        intent_parameters   << ApiAiRuby::Parameter.new("@categories", "categories", "\$categories")

        responses << ApiAiRuby::Response.new(
          "true",
          intent_params[:name].downcase.tr(" ","-") + "-action",
          intent_aff_contexts,
          intent_parameters,
          r[:speech])
      end
    end

    param_options = ApiAiRuby::Intent.new(
      intent_params[:name],
      true,
      [intent_params[:name].downcase.tr(" ","-")],
      [""],
      [ { "data": user_says_data } ],
      responses, 500000
    )

    param_options
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_intent
      @intent = Intent.find(params[:id])
    end

    def set_api_ai_client
      @api_ai_client = ApiAiRuby::Client.new(:client_access_token => ENV['API_AI_ACCESS'])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def intent_params
      params.require(:intent).permit(:name, :intent_id,
        intent_user_says_attributes: [:text, :id, :_destroy],
        intent_responses_attributes: [:speech, :id, :_destroy]
      )
    end
end
