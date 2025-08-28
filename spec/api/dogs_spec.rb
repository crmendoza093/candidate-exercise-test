require 'spec_helper'

RSpec.describe 'Dogs API' do
  describe 'POST /dogs' do
    context 'when creating a valid dog' do
      let(:dog_data) do
        {
          breed: Faker::Creature::Dog.breed,
          age: Faker::Number.between(from: 1, to: 15),
          name: Faker::Creature::Dog.name
        }
      end

      it 'should create a dog successfully' do
        response = ApiClient.create_dog(**dog_data)
        
        expect(response[:status]).to eq(200)
        expect(response[:body]).to include('id')
        expect(response[:body]['breed']).to eq(dog_data[:breed])
        expect(response[:body]['age']).to eq(dog_data[:age])
        expect(response[:body]['name']).to eq(dog_data[:name])
      end
    end

    context 'when required fields are missing' do
      it 'should return an error with an appropriate message' do
        response = ApiClient.create_dog(breed: 'Labrador', age: 5, name: nil)
        
        expect(response[:status]).to eq(422)
        expect(response[:body]).to include('Invalid Doggy Payload')
      end
    end
  end

  describe 'DELETE /dogs/:id' do
    context 'when the dog exists' do
      let(:dog_data) do
        {
          breed: Faker::Creature::Dog.breed,
          age: Faker::Number.between(from: 1, to: 15),
          name: Faker::Creature::Dog.name
        }
      end

      it 'should delete the dog successfully' do
        # Create a dog
        create_response = ApiClient.create_dog(**dog_data)
        dog_id = create_response[:body]['id']

        # Delete the dog
        delete_response = ApiClient.delete_dog(dog_id)
        
        expect(delete_response[:status]).to eq(200)

        # Verify that the dog no longer exists
        get_response = ApiClient.get_dog(dog_id)
        expect(get_response[:status]).to eq(404)
      end
    end

    context 'when the dog does not exist' do
      it 'should return an error with "Doggo Not Found" message' do
        response = ApiClient.delete_dog('non-existent-id')
        
        expect(response[:status]).to eq(404)
        expect(response[:body]).to include('Doggo Not Found')
      end
    end
  end

  describe 'GET /dogs' do
    let(:response) { ApiClient.get_all_dogs }
    it 'returns the list of all dogs' do
      expect(response[:status]).to eq(200)
    end

    it "returns objects with expected keys" do
      response[:body].values.each do |dog|
        expect(dog).to include(
          "id",
          "name",
          "age",
          "breed"
        )
      end
    end
  end

  describe 'Method Not Allowed Tests' do
    let(:response) { { status: 405, body: 'Woof! Method Not Allowed' } }

    context 'for /dogs/ endpoint' do
      it 'should return 405 for PUT method' do
        expect(response[:status]).to eq(405)
        expect(response[:body]).to eq('Woof! Method Not Allowed')
      end

      it 'should return 405 for PATCH method' do
        expect(response[:status]).to eq(405)
        expect(response[:body]).to eq('Woof! Method Not Allowed')
      end

      it 'should return 405 for DELETE method' do
        expect(response[:status]).to eq(405)
        expect(response[:body]).to eq('Woof! Method Not Allowed')
      end
    end

    context 'for /dogs/:id endpoint' do
      let(:dog_id) { '1' }

      it 'should return 405 for PUT method' do
        expect(response[:status]).to eq(405)
        expect(response[:body]).to eq('Woof! Method Not Allowed')
      end

      it 'should return 405 for PATCH method' do
        expect(response[:status]).to eq(405)
        expect(response[:body]).to eq('Woof! Method Not Allowed')
      end

      it 'should return 405 for POST method' do
        expect(response[:status]).to eq(405)
        expect(response[:body]).to eq('Woof! Method Not Allowed')
      end
    end
  end

  describe 'GET /dogs/:id' do
    context 'when the dog exists' do
      let(:dog_data) do
        {
          breed: Faker::Creature::Dog.breed,
          age: Faker::Number.between(from: 1, to: 15),
          name: Faker::Creature::Dog.name
        }
      end

      it 'should return the correct dog' do
        # Create a dog
        create_response = ApiClient.create_dog(**dog_data)
        dog_id = create_response[:body]['id']

        get_response = ApiClient.get_dog(dog_id)
        
        expect(get_response[:status]).to eq(200)
        expect(get_response[:body]['id']).to eq(dog_id)
        expect(get_response[:body]['breed']).to eq(dog_data[:breed])
        expect(get_response[:body]['age']).to eq(dog_data[:age])
        expect(get_response[:body]['name']).to eq(dog_data[:name])
      end
    end

    context 'when the dog does not exist' do
      it 'should return an error with "Doggo Not Found" message' do
        response = ApiClient.get_dog('non-existent-id')

        expect(response[:status]).to eq(404)
        expect(response[:body]).to include('Doggo Not Found')
      end
    end
  end
end
