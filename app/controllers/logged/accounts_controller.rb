class Logged::AccountsController < LoggedController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # GET /accounts
  # GET /accounts.json
  def index
    smart_listing_create :accounts, current_user.accounts, partial: "accounts/list",
                         sort_attributes: [[:account_id, "accounts.id"]], default_sort: {account_id: 'asc'}
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    transactions = Transaction.apply_filters @account.transactions, params.delocalize(date_params_config)

    smart_listing_create :transactions, transactions, partial: "transactions/list"
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)
    @account.user = current_user

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Účet bol úspešne vytvorený.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to accounts_path, notice: 'Účet bol úspešne upravený.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Účet bol úspešne odstránený.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name, :warning_limit, :notified)
    end

    def date_params_config
      {from_filter: :date, to_filter: :date}
    end
end
