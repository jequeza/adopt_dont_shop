require 'rails_helper'

RSpec.describe "Admin Applications Show Page" do
  before :each do
    Application.destroy_all
    Shelter.destroy_all
    ApplicationPet.destroy_all

    @shelter1 = Shelter.create!(name: "Shell Shelter", address: "102 Shelter Dr.", city: "Commerce City", state: "CO", zip: 80022)
    @pet1 = @shelter1.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")
    @pet2 = @shelter1.pets.create!(image:"", name: "Athena", description: "cat", approximate_age: 3, sex: "female")
    @pet3 = @shelter1.pets.create!(image:"", name: "Zeus", description: "dog", approximate_age: 4, sex: "male")
    @application1 = Application.create!(name: "Peter Smith", address: "123 Main Ave", city: "Denver", state: "CO", zip: 80011, description: "Love pets", status: "Pending")
    @application_pet1 = ApplicationPet.create!(pet_id: @pet1.id, application_id: @application1.id)
    @application_pet2 = ApplicationPet.create!(pet_id: @pet2.id, application_id: @application1.id)
    @application_pet3 = ApplicationPet.create!(pet_id: @pet3.id, application_id: @application1.id)
  end
  describe "As a visitor" do
    describe "I see a link for approving pets for applicaiton" do
      it "lists all the pets for application" do
        visit "admin/applications/#{@application1.id}"

        within("#application-#{@application1.id}") do
          expect(page).to have_content(@pet1.name)
          expect(page).to have_content(@pet2.name)
          expect(page).to have_content(@pet3.name)
        end
      end
      it "can approve pet by clicking button" do
        visit "admin/applications/#{@application1.id}"

        within("#application-#{@application1.id}") do
          expect(page).to have_link("Approve Pet")
        end

        find(".pet-link-#{@pet1.id}").click
        expect(current_path).to eq("/admin/applications/#{@application1.id}")

        within("#application-#{@application1.id}") do
          expect(page).to_not have_link(".pet-link-#{@pet1.id}")
          expect(page).to have_content("Approved")
        end
      end
    end
  end
end