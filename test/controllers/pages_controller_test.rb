require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get go" do
    get :go
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get cv" do
    get :cv
    assert_response :success
  end

  test "should get portfolio" do
    get :portfolio
    assert_response :success
  end

end
