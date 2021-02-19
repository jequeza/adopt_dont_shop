class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def update
    application_pet = ApplicationPet.find(params[:application_pet_id])
    application_pet.update(status: params[:status])
    redirect_to "/admin/applications/#{application_pet.application_id}"
  end
end