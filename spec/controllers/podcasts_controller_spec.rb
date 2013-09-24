require 'spec_helper'

describe PodcastsController do

  describe "GET #index" do

    it "assigns all current podcasts" do
      podcast = FactoryGirl.create(:podcast)
      get :index
      assigns(:podcasts).should eq([podcast])
    end

    it "renders the index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET #show" do
    it "finds the correct podcast" do
      podcast = FactoryGirl.create(:podcast)
      get :show, id: podcast.id
      assigns(:podcast).should eq(podcast)
    end

    it "renders the show template" do
      podcast = FactoryGirl.create(:podcast)
      get :show, id: podcast.id
      response.should render_template(:show)
    end
  end

  describe "GET #new" do

    it "assigns a new podcast" do
      get :new
      assigns(:podcast).should_not be_nil
    end

    it "renders the new template" do
      get :new
      response.should render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid data" do
      it "creates a new podcast" do
        expect{
          post :create, podcast: FactoryGirl.build(:podcast).attributes
        }.to change(Podcast, :count).by(1)
      end

      it "should redirect to the show action" do
        post :create, podcast: FactoryGirl.build(:podcast).attributes
        response.should redirect_to(Podcast.last)
      end

      it "sets the starttime" do
        podcast = FactoryGirl.build(:podcast)
        post :create, podcast: podcast.attributes
        podcast.start_at.hour.should == assigns(:podcast).start_at.hour
      end

      it "sets the day_of_week" do
        podcast = FactoryGirl.build(:podcast)
        post :create, podcast: podcast.attributes
        podcast.day_of_week.should == assigns(:podcast).day_of_week
      end
    end

    context "with invalid data" do
      it "does not create a new podcast" do
        expect{
          post :create, podcast: FactoryGirl.build(:podcast, :invalid).attributes
        }.to change(Podcast, :count).by(0)
      end

      it "renders the new view again" do
        post :create, podcast: FactoryGirl.build(:podcast, :invalid).attributes
        response.should render_template(:new)
      end
    end
  end

  describe "PUT #update" do

    before :each do
      @podcast = FactoryGirl.create(:podcast)
      @invalid_podcast = FactoryGirl.build(:podcast, :invalid)
    end

    context "with valid data" do
      it "finds the correct podcast" do
        put :update, id: @podcast.id, podcast: @podcast.attributes
        assigns(:podcast).should eq(@podcast)
      end

      it "redirects to the show action" do
        put :update, id: @podcast.id, podcast: @podcast.attributes
        response.should redirect_to(@podcast)
      end

      it "changes the podcast" do
        attributes = @podcast.attributes
        attributes["name"] = 'My new name'
        put :update, id: @podcast.id, podcast: attributes
        Podcast.find(@podcast.id).name.should == 'My new name'
      end
    end

    context "with invalid data" do
      it "renders the edit view" do
        put :update, id: @podcast.id, podcast: @invalid_podcast.attributes
        response.should render_template(:edit)
      end

      it "does not update the podcast" do
        put :update, id: @podcast.id, podcast: @invalid_podcast.attributes
        @podcast.reload
        @podcast.name.should_not be(@invalid_podcast.name)
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @podcast = FactoryGirl.create(:podcast)
    end

    it "deletes the record" do
      expect{
        delete :destroy, id: @podcast.id
      }.to change(Podcast, :count).by(-1)
    end

    it "should redirect to #index" do
      delete :destroy, id: @podcast.id
      response.should redirect_to(action: :index)
    end
  end
end
