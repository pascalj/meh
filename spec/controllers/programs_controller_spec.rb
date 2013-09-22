require 'spec_helper'

describe ProgramsController do

  describe "GET #index" do

    it "assigns all current programs" do
      program = FactoryGirl.create(:program)
      get :index
      assigns(:programs).should eq([program])
    end

    it "renders the index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET #show" do
    it "finds the correct program" do
      program = FactoryGirl.create(:program)
      get :show, id: program.id
      assigns(:program).should eq(program)
    end

    it "renders the show template" do
      program = FactoryGirl.create(:program)
      get :show, id: program.id
      response.should render_template(:show)
    end
  end

  describe "GET #new" do

    it "assigns a new program" do
      get :new
      assigns(:program).should_not be_nil
    end

    it "renders the new template" do
      get :new
      response.should render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid data" do
      it "creates a new program" do
        expect{
          post :create, program: FactoryGirl.build(:program).attributes
        }.to change(Program, :count).by(1)
      end

      it "should redirect to the show action" do
        post :create, program: FactoryGirl.build(:program).attributes
        response.should redirect_to(Program.last)
      end
    end

    context "with invalid data" do
      it "does not create a new program" do
        expect{
          post :create, program: FactoryGirl.build(:program, :invalid).attributes
        }.to change(Program, :count).by(0)
      end

      it "renders the new view again" do
        post :create, program: FactoryGirl.build(:program, :invalid).attributes
        response.should render_template(:new)
      end
    end
  end

  describe "PUT #update" do

    before :each do
      @program = FactoryGirl.create(:program)
      @invalid_program = FactoryGirl.build(:program, :invalid)
    end

    context "with valid data" do
      it "finds the correct program" do
        put :update, id: @program.id, program: @program.attributes
        assigns(:program).should eq(@program)
      end

      it "redirects to the show action" do
        put :update, id: @program.id, program: @program.attributes
        response.should redirect_to(@program)
      end

      it "changes the program" do
        attributes = @program.attributes
        attributes["name"] = 'My new name'
        put :update, id: @program.id, program: attributes
        Program.find(@program.id).name.should == 'My new name'
      end
    end

    context "with invalid data" do
      it "renders the edit view" do
        put :update, id: @program.id, program: @invalid_program.attributes
        response.should render_template(:edit)
      end

      it "does not update the program" do
        put :update, id: @program.id, program: @invalid_program.attributes
        @program.reload
        @program.name.should_not be(@invalid_program.name)
      end
    end
  end
end
