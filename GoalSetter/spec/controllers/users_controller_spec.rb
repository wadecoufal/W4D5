require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET #new' do
    before(:each) { get :new }
    it 'renders the new links page' do
      expect(response).to render_template('new')
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'POST #create' do
    context 'with valid parameters' do
      # before { post :create, params: { user: {username: 'Eric', password: 'starwars'}}}

      it do
        post :create, params: { user: {username: 'Eric', password: 'starwars'}}
        expect(response).to redirect_to(action: :show)
        # should redirect_to(action: :show)
      end
    end
    
    context 'with invalid parameters' do
      before { post :create, user: {username: 'Eric', password: 'star'}}
  
      it { should render_template('new') }
      
      it 'should flash errors' do
        expect(flash[:errors]).to be_present
      end
    end
  end
  
  describe 'GET #show' do
    User.create(username: 'Eric', password: 'starwars')
    user = User.all.first
    before { get :show, id: user.id }
    
    it 'renders show page for user' do
      expect(response).to render_template('show')
    end
  end
  
  describe 'Get #edit' do
    User.create(username: 'Eric', password: 'starwars')
    user = User.all.first
    before { get :edit, id: user.id }
    
    it 'renders edit page' do
      expect(response).to render_template('edit')
    end
  end
  
  describe 'POST #update' do
    it 'with valid parameters' do
      post :update, user: {username: 'Eric', password: 'starwars'}
      expect(response).to redirect_to(action: :show)
    end
    
    it 'with Invalid parameters' do
      post :update, user: {username: 'Eric', password: 'stas'}
      exepct(response).to render_template('edit')
      expect(flash[:errors]).to be_present
    end
  end
  
  describe 'DELETE #destroy' do
    it do
      delete :destroy, user: {username: 'Eric', password: 'starwars'}
      expect(response).to redirect_to(new_user_url)
    end
  end
  
  
end
