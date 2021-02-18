    class ApplicationsController < ApplicationController
  def show
    if params[:adopt_pet_id]
      @application_pet = ApplicationPet.new(pet_id: params[:adopt_pet_id], application_id: params[:id])
      @application_pet.save
      @application = Application.find(params[:id])
      @pet = Pet.find(params[:adopt_pet_id])
    elsif params[:pet_name]
      @application = Application.find(params[:id])
      @pets_search = Pet.application_search(params[:pet_name])
    else
      @application = Application.find(params[:id])
    end
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    if @application.save
      redirect_to "/applications/#{@application.id}"
    else
      render "/applications/new"
    end
  end

  def update
    application = Application.find(params[:id])
    application.update({description: params[:description], status: "Pending"})
    application.save
    redirect_to "/applications/#{application.id}"
  end

  private
    def application_params
      params[:application].permit(:name, :address, :city, :state, :zip, :description)
    end
end