require 'test_helper'

class SeriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @series = series(:one)
  end

  test "should get index" do
    get series_url
    assert_response :success
  end

  test "should get new" do
    get new_series_url
    assert_response :success
  end

  test "should create series" do
    assert_difference('Serie.count') do
      post series_url, params: { series: { average_voting: @series.average_voting, country: @series.country, id_serie: @series.id_serie, name_pt: @series.name_pt, original_name: @series.original_name, popularity: @series.popularity, synopsis: @series.synopsis, url_photo: @series.url_photo } }
    end

    assert_redirected_to series_url(Serie.last)
  end

  test "should show series" do
    get series_url(@series)
    assert_response :success
  end

  test "should get edit" do
    get edit_series_url(@series)
    assert_response :success
  end

  test "should update series" do
    patch series_url(@series), params: { series: { average_voting: @series.average_voting, country: @series.country, id_serie: @series.id_serie, name_pt: @series.name_pt, original_name: @series.original_name, popularity: @series.popularity, synopsis: @series.synopsis, url_photo: @series.url_photo } }
    assert_redirected_to series_url(@series)
  end

  test "should destroy series" do
    assert_difference('Serie.count', -1) do
      delete series_url(@series)
    end

    assert_redirected_to series_url
  end
end
