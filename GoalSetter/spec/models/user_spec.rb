require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe 'User model' do
    
    context 'username' do
      it { should validate_presence_of(:username) }
      it { should validate_uniqueness_of(:username) }
    end
    
    context 'session_token' do
      user = User.create(username: 'Eric', password: "starwars")
      it { should validate_presence_of(:session_token) }
      #session_token = user.session_token
    end
    
    describe '#ensure_session_token' do
      user = nil
      expect(user).to receive(:ensure_session_token)
      user = User.new(username: 'Eric', password: "starwars")
      expect(user.session_token).not_to be_nil
    end
    # ensure_session_token
    
    describe "password_digest" do
      it { should validate_presence_of(:password_digest) }
    end
    
    describe "password" do
      it { should validate_length_of(:password).is_at_least(6) }
      
      context "should not persist to database" do
        User.create(username: 'Eric', password: "starwars")
        user = User.last
        expect(user.password).to be_nil
      end
      
      describe "#password=" do
        user = User.new(username: 'Eric', password: "starwars")
        expect(user).to receive(:password=).with("starwars")
        user.save
        expect(BCrypt::Password).to receive(:create).and_return_original
        # BCrypt?
      end
    end
    
    describe "#reset_session_token!" do
      user = User.create(username: 'Eric', password: "starwars")
      original_session_token = user.session_token
      user.reset_session_token!
      
      context "user.session_token" do
        expect(user.session_token).to_not eq(original_session_token)
      end
    end
    
    describe "::find_by_credentials" do
      User.create(username: 'Eric', password: "starwars")
      user = User.find_by(username: 'Eric')
      context 'with valid paramters' do
        expect(User.find_by_credentials('Eric', 'starwars')).to eq(user)
      end
      
      context 'without valid parameters' do
        expect(User.find_by_credentials('Eric', 'ssssss')).to be_nil
        expect(User.find_by_credentials('Eeee', 'starwars')).to be_nil
      end
    end
    
    describe 'associations' do 
      
      describe 'user has many goals' do
        it { should have_many(:goals).class_name('Goal') }
      end
      
      describe 'user has many comments' do
        
      end
      
    end
    
  end
  
  
  
end
