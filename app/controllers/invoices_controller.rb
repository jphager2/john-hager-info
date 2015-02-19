class InvoicesController < AdminController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    @published = Invoice.published
    @unpublished = Invoice.unpublished
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    respond_to do |f|
      f.html {}
      f.pdf do
        if @invoice.published?
          render pdf: @invoice.number, show_as_html: false, layout: 'pdf.html.erb', footer: { html: { template: 'invoices/_invoice_footer.pdf.erb' } }, disposition: 'attachment'
        else
          render pdf: @invoice.number, show_as_html: true, layout: 'pdf.html.erb', footer: { html: { template: 'invoices/_invoice_footer.pdf.erb' } }
        end
      end
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @invoice.credit_note = true if params[:credit_note] == '1'
  end

  # GET /invoices/1/edit
  def edit
    redirect_to action: :index if @invoice.published?
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(:credit_note, :number, :invoice_year, :invoice_count, :date, :due_date, :period_covered_from, :period_covered_to, :price, :client_id, :client_code, :published, :currency, service_items_attributes: [:id, :title, :description, :price, :currency, :_destroy], expense_items_attributes: [:id, :title, :description, :price, :currency, :_destroy])
    end
end
