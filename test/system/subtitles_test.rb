require "application_system_test_case"

class SubtitlesTest < ApplicationSystemTestCase
  setup do
    @subtitle = subtitles(:one)
  end

  test "visiting the index" do
    visit subtitles_url
    assert_selector "h1", text: "Subtitles"
  end

  test "creating a Subtitle" do
    visit subtitles_url
    click_on "New Subtitle"

    fill_in "Lang", with: @subtitle.lang
    fill_in "Movie", with: @subtitle.movie_id
    check "Stored" if @subtitle.stored
    fill_in "Stored path", with: @subtitle.stored_path
    click_on "Create Subtitle"

    assert_text "Subtitle was successfully created"
    click_on "Back"
  end

  test "updating a Subtitle" do
    visit subtitles_url
    click_on "Edit", match: :first

    fill_in "Lang", with: @subtitle.lang
    fill_in "Movie", with: @subtitle.movie_id
    check "Stored" if @subtitle.stored
    fill_in "Stored path", with: @subtitle.stored_path
    click_on "Update Subtitle"

    assert_text "Subtitle was successfully updated"
    click_on "Back"
  end

  test "destroying a Subtitle" do
    visit subtitles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Subtitle was successfully destroyed"
  end
end
