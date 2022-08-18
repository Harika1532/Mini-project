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
debugger
RSpec.describe UsersController,:type => :controller do
  it "POST /create" do
    
    payload = {email: 'harika@test.com', password_digest: 'abcd', role: 2}
	post :create, :params=> payload
	expect(response.status).to eq(201)
	# expect(JSON.parse(response.body)).to eq (user_response)
  end
end
