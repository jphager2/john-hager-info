require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    @invoice = invoices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice" do
    assert_difference('Invoice.count') do
      post :create, invoice: { customer_code: @invoice.customer_code, customer_id: @invoice.customer_id, date: @invoice.date, due_date: @invoice.due_date, invoice_count: @invoice.invoice_count, invoice_year: @invoice.invoice_year, number: @invoice.number, period_covered_from: @invoice.period_covered_from, period_covered_to: @invoice.period_covered_to, price: @invoice.price }
    end

    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should show invoice" do
    get :show, id: @invoice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice
    assert_response :success
  end

  test "should update invoice" do
    patch :update, id: @invoice, invoice: { customer_code: @invoice.customer_code, customer_id: @invoice.customer_id, date: @invoice.date, due_date: @invoice.due_date, invoice_count: @invoice.invoice_count, invoice_year: @invoice.invoice_year, number: @invoice.number, period_covered_from: @invoice.period_covered_from, period_covered_to: @invoice.period_covered_to, price: @invoice.price }
    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete :destroy, id: @invoice
    end

    assert_redirected_to invoices_path
  end
end
