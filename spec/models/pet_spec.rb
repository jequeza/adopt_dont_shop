require 'rails_helper'

describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to :shelter }
    it {should have_many :application_pets}
    it {should have_many(:applications).through(:application_pets)}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :sex}
    it {should validate_numericality_of(:approximate_age).is_greater_than_or_equal_to(0)}

    it 'is created as adoptable by default' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
      expect(pet.adoptable).to eq(true)
    end

    it 'can be created as not adoptable' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(adoptable: false, name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
      expect(pet.adoptable).to eq(false)
    end

    it 'can be male' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(sex: :male, name: "Fluffy", approximate_age: 3, description: 'super cute')
      expect(pet.sex).to eq('male')
      expect(pet.male?).to be(true)
      expect(pet.female?).to be(false)
    end

    it 'can be female' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(sex: :female, name: "Fluffy", approximate_age: 3, description: 'super cute')
      expect(pet.sex).to eq('female')
      expect(pet.female?).to be(true)
      expect(pet.male?).to be(false)
    end
  end

  describe "class methods" do
    describe "::application_search" do
      it "returns list of pets with matching name" do
        shelter = Shelter.create!(name: "Shell Shelter", address: "102 Shelter Dr.", city: "Commerce City", state: "CO", zip: 80022)
        pet = shelter.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")

        expect(Pet.application_search("Thor").first).to eq(pet)
        expect(Pet.application_search("Thor").length).to eq(1)
        expect(Pet.application_search("Sparky").first).to eq(nil)
      end

      it "can return matching name with just a partial string and not case sensitive" do
        shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
        pet1 = shelter.pets.create!(adoptable: false, name: "Fluffy", approximate_age: 3, sex: 'male', description: 'dog')
        pet2 = shelter.pets.create!(name: "Fluffy", approximate_age: 3, sex: 'male', description: 'dog')
        pet3 = shelter.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")
        expect(Pet.application_search("or").first.name).to eq(pet3.name)
        expect(Pet.application_search("THOR").first.name).to eq(pet3.name)
        expect(Pet.application_search("FlU").first.name).to eq(pet1.name)
        expect(Pet.application_search("FLUFFY").first.name).to eq(pet1.name)
        expect(Pet.application_search("FluFFy").length).to eq(2)
      end
    end
  end
end
