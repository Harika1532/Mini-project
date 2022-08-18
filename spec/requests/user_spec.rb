require 'rails_helper'
def user_response
	{
		"user": 
		{
	        "id": 10,
	        "email": "test@test",
	        "password_digest": "test",
	        "role": 2
    	}
    }
end

RSpec.describe "Users", type: :controller do
  it "GET /index" do
    
    payload = {email: 'harika@test.com', password: 'abcd'}
		post :create, params: payload
		expect(response.status).to eq(201)
		expect(JSON.parse(response.body)).to eq (user_response)
  end
end
