class ExternalIdpsController < ApplicationController
  
  # GET /external_idps
  def index
    #logger.tagged("MIRKO") {logger.warn request.host }
    @external_idps = ExternalIdp.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /external_idps/1
  def show
    @external_idp = ExternalIdp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /external_idps/new
  def new
    @new_idp = true # For the view
    @external_idp = ExternalIdp.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /external_idps/1/edit
  def edit
    @new_idp = false # For the view
    @external_idp = ExternalIdp.find(params[:id])
  end

  # POST /external_idps
  def create
    @external_idp = ExternalIdp.new(params[:external_idp])

    respond_to do |format|
      if @external_idp.save && !@external_idp.errors.any?
        format.html { redirect_to external_idps_url, notice: t('idp.form.new') }
      else
        #logger.tagged("MIRKO") {logger.warn "ERRORORRO" }
        @new_idp = true
        format.html { render action: "new" }
      end
    end
  end

  # PUT /external_idps/1
  def update
    @external_idp = ExternalIdp.find(params[:id])

    respond_to do |format|
      #logger.tagged("MIRKO") {logger.warn params[:external_idp] }
      
      res_update = @external_idp.update_attributes(params[:external_idp])
      
      if res_update && !@external_idp.errors.any?
        format.html { redirect_to external_idps_url, notice: t('idp.form.update') } # Tutto ok
      else
        @new_idp = false
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /external_idps/1
  def destroy
    @external_idp = ExternalIdp.find(params[:id])
    @external_idp.destroy

    respond_to do |format|
      format.html { redirect_to external_idps_url, notice: t('idp.delete')  }
    end
  end
  
  #def download
  #  logger.tagged("MIRKO") {logger.warn "DOWNLOAD" }
  #end
  
end
