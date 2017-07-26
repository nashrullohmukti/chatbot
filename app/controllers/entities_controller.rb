class EntitiesController < ApplicationController
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :set_api_ai_client, only: [:create, :update, :destroy]

  # GET /entities
  # GET /entities.json
  def index
    @entities = Entity.all
  end

  # GET /entities/1
  # GET /entities/1.json
  def show
  end

  # GET /entities/new
  def new
    @entity = Entity.new
  end

  # GET /entities/1/edit
  def edit
  end

  # POST /entities
  # POST /entities.json
  def create
    uer = @api_ai_client.create_entities_request
    response = uer.create(param_options)

    @entity = Entity.new(entity_params)

    respond_to do |format|
      if response.is_a?(Hash) && response[:status][:code].eql?(200)
        @entity.entityId = response[:id]
        if @entity.save
          format.html { redirect_to @entity, notice: 'Entity was successfully created.' }
          format.json { render :show, status: :created, location: @entity }
        else
          format.html { render :new }
          format.json { render json: @entity.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to new_entity_path, alert: 'Failed to create entity.'}
      end
    end
  end

  # PATCH/PUT /entities/1
  # PATCH/PUT /entities/1.json
  def update
    param_opt = param_options("update")
    uer = @api_ai_client.create_entities_request
    response = uer.update(entity_params[:name].downcase.tr(" ","_"), param_opt)
    respond_to do |format|
      if response.is_a?(Hash) && response[:status][:code].eql?(200)
        if @entity.update(entity_params)
          format.html { redirect_to @entity, notice: 'Entity was successfully updated.' }
          format.json { render :show, status: :ok, location: @entity }
        else
          format.html { render :edit }
          format.json { render json: @entity.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @entity, alert: 'Failed to update entity.'}
      end
    end
  end

  def destroy
    uer = @api_ai_client.create_entities_request
    response = uer.delete(@entity.entityId)

    respond_to do |format|
      if response.is_a?(Hash) && response[:status][:code].eql?(200)
        @entity.destroy
        format.html { redirect_to entities_url, notice: 'Entity was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @entity, alert: 'Failed to delete entity.'}
      end
    end
  end

  def param_options(upd = "")
    entries_data = []
    if entity_params[:entries_attributes].nil?
      entity_params[:entries_attributes] = "0"
    else
      entity_params[:entries_attributes].each do |k, us|
        entries_data << ApiAiRuby::Entry.new(us[:name], synonyms = [us[:name]])
      end
    end
    if upd == "update"
      param_options = (entries_data)
    else
      param_options = ApiAiRuby::Entity.new(entity_params[:name].downcase.tr(" ","_"), entries_data)
    end
    param_options
  end
  # DELETE /entities/1
  # DELETE /entities/1.json

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity
      @entity = Entity.find(params[:id])
    end

    def set_api_ai_client
      @api_ai_client = ApiAiRuby::Client.new(:client_access_token => ENV['API_AI_ACCESS'])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_params
      params.require(:entity).permit(:name, :company_id, entries_attributes: [:id, :name, :_destroy])
    end
end
