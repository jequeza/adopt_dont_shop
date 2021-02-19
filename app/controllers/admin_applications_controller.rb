class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def update
    application_pet = ApplicationPet.find(params[:id])
    application_pet.update(status: "Approved")
    redirect_to "/admin/applications/#{application_pet.application_id}"
  end

  # def delete
  #   application_pet = ApplicationPet.find(params[:id])
  #   application_pet.destroy
  #   redirect_to /
  # end
end