class Admin::FavoriteExchangeRatesController < AdminController
  before_action :set_admin_favorite_exchange_rate, only: [:show, :edit, :update, :destroy]

  # GET /admin/favorite_exchange_rates
  # GET /admin/favorite_exchange_rates.json
  def index
    @favorite_exchange_rates = current_user.favorite_exchange_rates
  end

  # GET /admin/favorite_exchange_rates/1
  # GET /admin/favorite_exchange_rates/1.json
  def show
  end

  # GET /admin/favorite_exchange_rates/new
  def new
    @favorite_exchange_rate = current_user.favorite_exchange_rates.new
  end

  # GET /admin/favorite_exchange_rates/1/edit
  def edit
  end

  # POST /admin/favorite_exchange_rates
  # POST /admin/favorite_exchange_rates.json
  def create
    @favorite_exchange_rate = current_user.favorite_exchange_rates.new(favorite_exchange_rate_params)

    respond_to do |format|
      if @favorite_exchange_rate.save
        format.html { redirect_to [:admin, @favorite_exchange_rate], notice: 'Favorite Exchange rate was successfully created.' }
        format.json { render :show, status: :created, location: @favorite_exchange_rate }
      else
        format.html { render :new }
        format.json { render json: @favorite_exchange_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/favorite_exchange_rates/1
  # PATCH/PUT /admin/favorite_exchange_rates/1.json
  def update
    respond_to do |format|
      if @favorite_exchange_rate.update(favorite_exchange_rate_params)

        format.html { redirect_to [:admin, @favorite_exchange_rate], notice: 'Exchange rate was successfully updated.' }
        format.json { render :show, status: :ok, location: @favorite_exchange_rate }
      else
        format.html { render :edit }
        format.json { render json: @favorite_exchange_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/favorite_exchange_rates/1
  # DELETE /admin/favorite_exchange_rates/1.json
  def destroy
    @favorite_exchange_rate.destroy
    respond_to do |format|
      format.html { redirect_to admin_favorite_exchange_rates_url, notice: 'Exchange rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin_favorite_exchange_rate
    @favorite_exchange_rate = FavoriteExchangeRate.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def favorite_exchange_rate_params
    params.require(:favorite_exchange_rate).permit(:amount, :base_currency, :target_currency)
  end
end
