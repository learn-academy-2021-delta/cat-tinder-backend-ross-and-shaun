require 'rails_helper'

RSpec.describe "Cats", type: :request do
  describe "GET /index" do
   it "gets a list of cats" do
    Cat.create name:'Mosey', age: 5, enjoys: 'showing up in odd places randomly'
    get '/cats'
    cat = JSON.parse(response.body)
    expect(response).to have_http_status(200)
    expect(cat.length).to eq 1
   end
  end

  describe "POST /create" do
    it "creates a cat" do

      cat_params = {
        cat: {
          name: 'Giraffe',
          age: 5,
          enjoys: 'showing up in odd places randomly'
        }
      }

      post '/cats', params: cat_params
      expect(response).to have_http_status(200)

      cat = Cat.first
      p cat.id
      expect(cat.name).to eq 'Giraffe'
      expect(cat.age).to eq 5
      expect(cat.enjoys).to eq 'showing up in odd places randomly'
    end
  end

  describe "PATCH /update" do
    it "updates a cat" do
      cat_params = {
        cat: {
          name: 'Tunces',
          age: 9,
          enjoys: 'driving cars off a cliff'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first
      
      updated_cat_params = {
        cat: {
          name: "Tunces",
          age: 10,
          enjoys: 'driving cars off a cliff'
        }
      }
      patch "/cats/#{cat.id}", params: updated_cat_params
      cat = Cat.first
      expect(response).to have_http_status(200)
      expect(cat.age).to eq 10
    end
  end
  
  describe "DELETE /destroy" do
    it 'deletes a cat' do
      cat_params = {
        cat: {
          name: 'Pooky',
          age: 2,
          enjoys: 'Eats garden veggies'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first
      delete "/cats/#{cat.id}"
      expect(response).to have_http_status(200)
      cats = Cat.all
      expect(cats).to be_empty
    end
  end

  describe 'cat validation error codes' do
    it 'does not create a cat with a name' do
      cat_params = {
        cat: {
          age: 2,
          enjoys: 'Eats garden veggies'
        }
      }
      post '/cats', params: cat_params
      expect(response).to have_http_status(422)
      cat = JSON.parse(response.body)
      expect(cat['name']).to include "can't be blank"
    end
    it 'does not create a cat with an age' do
      cat_params = {
        cat: {
          name: 'Toast',
          enjoys: 'Eats garden veggies'
        }
      }
      post '/cats', params: cat_params
      expect(response).to have_http_status(422)
      cat = JSON.parse(response.body)
      expect(cat['age']).to include "can't be blank"
    end
    it 'does not create a cat with an enjoys' do
      cat_params = {
        cat: {
          name: 'Toast',
          age: 3
        }
      }
      post '/cats', params: cat_params
      expect(response).to have_http_status(422)
      cat = JSON.parse(response.body)
      expect(cat['enjoys']).to include "can't be blank"
    end
  end

  describe "cannot update a cat without valid attributes" do
    it 'cannot update a cat without a name' do
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles and belly rubs'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first
      cat_params = {
        cat: {
          name: '',
          age: 2,
          enjoys: 'cuddles and belly rubs'
        }
      }
      patch "/cats/#{cat.id}", params: cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['name']).to include "can't be blank"
    end
    it 'cannot update a cat without a age' do
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles and belly rubs'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first
      cat_params = {
        cat: {
          name: 'Boo',
          age: '',
          enjoys: 'cuddles and belly rubs'
        }
      }
      patch "/cats/#{cat.id}", params: cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['age']).to include "can't be blank"
    end
    it 'cannot update a cat without an enjoys' do
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles and belly rubs'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: '',
        }
      }
      patch "/cats/#{cat.id}", params: cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['enjoys']).to include "can't be blank"
    end
    it 'cannot update a cat without an enjoys that is at least 10 characters' do
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles and belly rubs'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles'
        }
      }
      patch "/cats/#{cat.id}", params: cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['enjoys']).to include 'is too short (minimum is 10 characters)'
    end
  end

end