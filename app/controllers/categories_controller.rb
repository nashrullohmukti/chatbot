class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

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
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        client = ApiAiRuby::Client.new(
            :client_access_token => ENV['API_AI_ACCESS']
        )
        params = ApiAiRuby::Intent.new(
          category_params[:name]+ "_intent",
          true,
          [category_params[:contexts]],
          [category_params[:templates]],
          [{"data":[
            ApiAiRuby::UserSayData.new(category_params[:text], category_params[:alias], category_params[:meta])
          ]}],
          [ApiAiRuby::Response.new(
            category_params[:reset_contexts],
            category_params[:action],
            [ ApiAiRuby::AffectedContext.new("test", category_params[:lifespan]) ],
            [ ApiAiRuby::Parameter.new(
              category_params["intent_responses_attributes"]["0"]["intent_parameters_attributes"]["0"][:name],
              "@" + category_params["intent_responses_attributes"]["0"]["intent_parameters_attributes"]["0"][:data_type],
              "\$" + category_params["intent_responses_attributes"]["0"]["intent_parameters_attributes"]["0"][:value])
            ],
            category_params[:speech]
          )],
          500000
        )
        uer = client.create_intents_request
        uer.create(params)

        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.friendly.find(params[:id])
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
