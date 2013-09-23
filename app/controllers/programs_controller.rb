class ProgramsController < ApplicationController
  def index
    @programs = Program.all
  end

  def new
    @program = Program.new
  end

  def show
    @program = Program.find(params[:id])
  end

  def create
    @program = Program.new(program_params)
    @program.valid?
    if @program.save
      redirect_to @program
    else
      render :new
    end
  end

  def update
    @program = Program.find(params[:id])
    if @program.update(program_params)
      redirect_to @program
    else
      render :edit, program: @program
    end
  end

  def destroy
    @program = Program.find(params[:id])
    @program.destroy!
    render nothing: true
  end

  private

  def program_params
    params.require(:program).permit(:name, :length, :stream, :stream_id, :start_at)
  end
end
