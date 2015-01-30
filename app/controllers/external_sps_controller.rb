class ExternalSpsController < ApplicationController
  
  # GET /external_sps
  def index
    @external_sps = ExternalSp.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /external_sps/1
  def show
    @external_sp = ExternalSp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /external_sps/new
  def new
    @new_sp = true # For the view
    @external_sp = ExternalSp.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /external_sps/1/edit
  def edit
    @new_sp = false # For the view
    @external_sp = ExternalSp.find(params[:id])
  end

  # POST /external_sps
  def create
    @external_sp = ExternalSp.new(params[:external_sp])

    respond_to do |format|
      if @external_sp.save && !@external_sp.errors.any?
        format.html { redirect_to external_sps_url, notice: t('sp.form.new') }
      else
        @new_sp = true
        format.html { render action: "new" }
      end
    end
  end

  # PUT /external_sps/1
  def update
    @external_sp = ExternalSp.find(params[:id])

    respond_to do |format|
      
      res_update = @external_sp.update_attributes(params[:external_sp])
      
      if res_update && !@external_sp.errors.any?
        format.html { redirect_to external_sps_url, notice: t('sp.form.update') } # Tutto ok
      else
        @new_sp = false
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /external_sps/1
  def destroy
    @external_sp = ExternalSp.find(params[:id])
    @external_sp.destroy

    respond_to do |format|
      format.html { redirect_to external_sps_url, notice: t('sp.delete')  }
    end
  end
    
end
