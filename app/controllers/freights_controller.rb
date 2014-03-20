class FreightsController < ApplicationController
  # GET /freights
  # GET /freights.json
  def index
    @freights = Freight.all

    respond_to do |format|
      format.html # index.html.delete.erb
      format.json { render json: @freights }
    end
  end

  # GET /freights/1
  # GET /freights/1.json
  def show
    @freight = Freight.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @freight }
    end
  end

  # GET /freights/new
  # GET /freights/new.json
  def new
    @freight = Freight.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @freight }
    end
  end

  # GET /freights/1/edit
  def edit
    @freight = Freight.find(params[:id])
  end

  # POST /freights
  # POST /freights.json
  def create
    @freight = Freight.new(params[:freight])

    respond_to do |format|
      if @freight.save
        format.html { redirect_to @freight, notice: 'Freight was successfully created.' }
        format.json { render json: @freight, status: :created, location: @freight }
      else
        format.html { render action: "new" }
        format.json { render json: @freight.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /freights/1
  # PUT /freights/1.json
  def update
    @freight = Freight.find(params[:id])

    respond_to do |format|
      if @freight.update_attributes(params[:freight])
        format.html { redirect_to @freight, notice: 'Freight was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @freight.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /freights/1
  # DELETE /freights/1.json
  def destroy
    @freight = Freight.find(params[:id])
    @freight.destroy

    respond_to do |format|
      format.html { redirect_to freights_url }
      format.json { head :no_content }
    end
  end
end
