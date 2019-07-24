class Admin::CalculationsController < AdminController

  before_action :set_calculation, except: [:index, :new, :create]

  def index
  end

  def new
  end

  def create
    @calculation = current_user.calculations.new(caculation_params)
    respond_to do |format|
      if @calculation.save
        format.html { redirect_to [current_user, @calculation], notice: 'Calculation was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @calculation.update(caculation_params)
        format.html { redirect_to [current_user, @calculation], notice: 'Calculation was successfully updated.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @calculation.destroy
    format.html { redirect_to [current_user, :calculations], notice: 'Calculation was successfully destroyed.' }
  end

  private

  def set_calculation
    @calculation = Caculation.find(params[:id])
  end

  def caculation_params
    params.require(:calculation).permit!(:value, :to, :from, :user_id)
  end

end
