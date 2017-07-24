class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :set_api_ai_client, only: [:create, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    intent_request = @api_ai_client.create_intents_request
    response       = intent_request.create(param_options)
    contexts_templates  = { contexts: category_params[:contexts].split(","), templates: category_params[:templates].split(",") }

    @category = Category.new(category_params.merge(contexts_templates))

    respond_to do |format|
      if response.is_a?(Hash) && response[:status][:code].eql?(200)
        @category.intent_id = response[:id]

        if @category.save

          format.html { redirect_to @category, notice: 'Category was successfully created.' }
          format.json { render :show, status: :created, location: @category }
        else
          format.html { render :new }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      else
        @notice = response.message

        format.html { render :new }
        format.json { render json: { error: response.message }, status: response.code}
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|

      intent_request = @api_ai_client.create_intents_request
      response       = intent_request.update(@category.intent_id, param_options)

      if response.is_a?(Hash) && response[:status][:code].eql?(200)

        contexts_templates  = { contexts: category_params[:contexts].split(","), templates: category_params[:templates].split(",") }

        if @category.update(category_params.merge(contexts_templates))
          format.html { redirect_to @category, notice: 'Category was successfully updated.' }
          format.json { render :show, status: :ok, location: @category }
        else
          format.html { render :edit }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      else
        @notice = response.message

        format.html { render :new }
        format.json { render json: { error: response.message }, status: response.code}
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    intent_request = @api_ai_client.create_intents_request
    response       = intent_request.delete(@category.intent_id)

    # if response.is_a?(Hash) && response[:status][:code].eql?(200)
      @category.destroy
      respond_to do |format|
        format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
        format.json { head :no_content }
      end
    # else
    #   respond_to { |f|  f.html { redirect_to categories_url, notice: response.message } }
    # end
  end

  def param_options
    user_says_data = []

    category_params[:intent_user_says_attributes].each do |k, us|
      user_says_data << ApiAiRuby::UserSayData.new(us[:text], us[:alias], us[:meta])
    end

    responses = []

    category_params[:intent_responses_attributes].each do |k, r|
      intent_aff_contexts = []
      intent_parameters   = []

      intent_aff_contexts_attr = r[:intent_affected_contexts_attributes] || Array.new
      intent_aff_contexts_attr.each do |kac, vac|
        intent_aff_contexts << ApiAiRuby::AffectedContext.new(vac[:name], vac[:lifespan])
      end

      intent_parameters_attr = r[:intent_parameters_attributes] || Array.new
      intent_parameters_attr.each do |kp, vp|
        intent_parameters << ApiAiRuby::Parameter.new(vp[:name], vp[:data_type], "\$" + vp[:value])
      end

      responses << ApiAiRuby::Response.new(
        r[:reset_contexts],
        r[:action],
        intent_aff_contexts,
        intent_parameters,
        category_params[:speech]
      )
    end

    param_options = ApiAiRuby::Intent.new(
      category_params[:name] + "_intent",
      (category_params[:auto].eql?("1") ? true : false),
      category_params[:contexts].split(","),
      category_params[:templates].split(","),
      [ { "data": user_says_data } ],
      responses, 500000
    )

    param_options
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.friendly.find(params[:id])
    end

    def set_api_ai_client
      @api_ai_client = ApiAiRuby::Client.new(:client_access_token => ENV['API_AI_ACCESS'])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :auto, :priority, :contexts, :templates,
        intent_user_says_attributes: [:text, :alias, :meta, :id, :_destroy],
        intent_responses_attributes: [:reset_contexts, :action, :speech, :id, :_destroy,
          intent_affected_contexts_attributes: [:name, :lifespan, :id, :_destroy],
          intent_parameters_attributes: [:data_type, :name, :value, :id, :_destroy]]
      )
    end
end
