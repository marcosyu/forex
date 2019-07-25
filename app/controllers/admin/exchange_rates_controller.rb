class Admin::ExchangeRatesController < AdminController
  before_action :set_admin_exchange_rate, only: [:show, :edit, :update, :destroy]

  # GET /admin/exchange_rates
  # GET /admin/exchange_rates.json
  def index
    @exchange_rates = ExchangeRate.all
  end

  # GET /admin/exchange_rates/1
  # GET /admin/exchange_rates/1.json
  def show
  end

  # GET /admin/exchange_rates/new
  def new
    @exchange_rate = ExchangeRate.new
  end

  # GET /admin/exchange_rates/1/edit
  def edit
  end

  # POST /admin/exchange_rates
  # POST /admin/exchange_rates.json
  def create
    @exchange_rate = current_user.exchange_rates.new(exchange_rate_params)

    respond_to do |format|
      if @exchange_rate.save
        ExchangeRateJob.perform_later(@exchange_rate.id)

        format.html { redirect_to [:admin, @exchange_rate], notice: 'Exchange rate was successfully created.' }
        format.json { render :show, status: :created, location: @exchange_rate }
      else
        format.html { render :new }
        format.json { render json: @exchange_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/exchange_rates/1
  # PATCH/PUT /admin/exchange_rates/1.json
  def update
    respond_to do |format|
      if @exchange_rate.update(exchange_rate_params)
        format.html { redirect_to [:admin, @exchange_rate], notice: 'Exchange rate was successfully updated.' }
        format.json { render :show, status: :ok, location: @exchange_rate }
      else
        format.html { render :edit }
        format.json { render json: @exchange_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/exchange_rates/1
  # DELETE /admin/exchange_rates/1.json
  def destroy
    @exchange_rate.destroy
    respond_to do |format|
      format.html { redirect_to admin_exchange_rates_url, notice: 'Exchange rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin_exchange_rate
    @exchange_rate = current_user.exchange_rates.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def exchange_rate_params
    params.require(:exchange_rate).permit(:amount, :base_currency, :target_currency, :historical_duration)
  end
end
