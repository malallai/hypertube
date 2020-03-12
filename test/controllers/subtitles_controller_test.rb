require 'test_helper'

class SubtitlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subtitle = subtitles(:one)
  end

  test "should get index" do
    get subtitles_url
    assert_response :success
  end

  test "should get new" do
    get new_subtitle_url
    assert_response :success
  end

  test "should create subtitle" do
    assert_difference('Subtitle.count') do
      post subtitles_url, params: { subtitle: { lang: @subtitle.lang, movie_id: @subtitle.movie_id, stored: @subtitle.stored, stored_path: @subtitle.stored_path } }
    end

    assert_redirected_to subtitle_url(Subtitle.last)
  end

  test "should show subtitle" do
    get subtitle_url(@subtitle)
    assert_response :success
  end

  test "should get edit" do
    get edit_subtitle_url(@subtitle)
    assert_response :success
  end

  test "should update subtitle" do
    patch subtitle_url(@subtitle), params: { subtitle: { lang: @subtitle.lang, movie_id: @subtitle.movie_id, stored: @subtitle.stored, stored_path: @subtitle.stored_path } }
    assert_redirected_to subtitle_url(@subtitle)
  end

  test "should destroy subtitle" do
    assert_difference('Subtitle.count', -1) do
      delete subtitle_url(@subtitle)
    end

    assert_redirected_to subtitles_url
  end
end
