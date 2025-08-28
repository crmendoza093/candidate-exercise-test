require 'httparty'
require 'json'

class ApiClient
  include HTTParty
  
  base_uri API_BASE_URL
  format :json
  headers 'Content-Type' => 'application/json'

  def self.create_dog(breed:, age:, name:)
    response = post('/dogs', body: {
      breed: breed,
      age: age,
      name: name
    }.to_json)
    
    # If the response is JSON, parse it, otherwise return the body as is
    content_type = response.headers['content-type'] || ''
    body = content_type.include?('application/json') ? response.parsed_response : response.body

    {
      status: response.code,
      body: body,
      headers: response.headers
    }
  end

  def self.get_dog(dog_id)
    response = get("/dogs/#{dog_id}")

    # If the response is JSON, parse it, otherwise return the body as is
    content_type = response.headers['content-type'] || ''
    body = content_type.include?('application/json') ? response.parsed_response : response.body

    {
      status: response.code,
      body: body,
      headers: response.headers
    }
  end

  def self.delete_dog(dog_id)
    response = delete("/dogs/#{dog_id}")

    # If the response is JSON, parse it, otherwise return the body as is
    content_type = response.headers['content-type'] || ''
    body = content_type.include?('application/json') ? response.parsed_response : response.body

    {
      status: response.code,
      body: body,
      headers: response.headers
    }
  end

  def self.get_all_dogs
    response = get('/dogs')
    
    # If the response is JSON, parse it, otherwise return the body as is
    content_type = response.headers['content-type'] || ''
    body = content_type.include?('application/json') ? response.parsed_response : response.body

    {
      status: response.code,
      body: body,
      headers: response.headers
    }
  end
end
