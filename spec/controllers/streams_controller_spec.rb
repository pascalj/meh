require 'spec_helper'

describe StreamsController do

  describe "GET #index" do

    it "assigns all current streams" do
      stream = FactoryGirl.create(:stream)
      get :index
      assigns(:streams).should eq([stream])
    end

    it "renders the index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET #show" do
    it "redirects to Podcast#index" do
      stream = FactoryGirl.create(:stream)
      get :show, id: stream.id
      response.should redirect_to(podcasts_path)
    end
  end

  describe "GET #new" do

    it "assigns a new stream" do
      get :new
      assigns(:stream).should_not be_nil
    end

    it "renders the new template" do
      get :new
      response.should render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid data" do
      it "creates a new stream" do
        expect{
          post :create, stream: FactoryGirl.build(:stream).attributes
        }.to change(Stream, :count).by(1)
      end

      it "should redirect to the show action" do
        post :create, stream: FactoryGirl.build(:stream).attributes
        response.should redirect_to(Stream.last)
      end
    end

    context "with invalid data" do
      it "does not create a new stream" do
        expect{
          post :create, stream: FactoryGirl.build(:stream, :invalid).attributes
        }.to change(Stream, :count).by(0)
      end

      it "renders the new view again" do
        post :create, stream: FactoryGirl.build(:stream, :invalid).attributes
        response.should render_template(:new)
      end
    end
  end

  describe "PUT #update" do

    before :each do
      @stream = FactoryGirl.create(:stream)
      @invalid_stream = FactoryGirl.build(:stream, :invalid)
    end

    context "with valid data" do
      it "finds the correct stream" do
        put :update, id: @stream.id, stream: @stream.attributes
        assigns(:stream).should eq(@stream)
      end

      it "redirects to the show action" do
        put :update, id: @stream.id, stream: @stream.attributes
        response.should redirect_to(@stream)
      end

      it "changes the stream" do
        attributes = @stream.attributes
        attributes["name"] = 'My new name'
        put :update, id: @stream.id, stream: attributes
        Stream.find(@stream.id).name.should == 'My new name'
      end
    end

    context "with invalid data" do
      it "renders the edit view" do
        put :update, id: @stream.id, stream: @invalid_stream.attributes
        response.should render_template(:edit)
      end

      it "does not update the stream" do
        put :update, id: @stream.id, stream: @invalid_stream.attributes
        @stream.reload
        @stream.name.should_not be(@invalid_stream.name)
      end
    end
  end
end
