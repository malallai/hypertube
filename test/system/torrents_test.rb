require "application_system_test_case"

class TorrentsTest < ApplicationSystemTestCase
  setup do
    @torrent = torrents(:one)
  end

  test "visiting the index" do
    visit torrents_url
    assert_selector "h1", text: "Torrents"
  end

  test "creating a Torrent" do
    visit torrents_url
    click_on "New Torrent"

    fill_in "Magnet", with: @torrent.magnet
    fill_in "Movie", with: @torrent.movie_id
    fill_in "Size", with: @torrent.size
    fill_in "Source", with: @torrent.source
    fill_in "Stored", with: @torrent.stored
    fill_in "Stored name", with: @torrent.stored_name
    click_on "Create Torrent"

    assert_text "Torrent was successfully created"
    click_on "Back"
  end

  test "updating a Torrent" do
    visit torrents_url
    click_on "Edit", match: :first

    fill_in "Magnet", with: @torrent.magnet
    fill_in "Movie", with: @torrent.movie_id
    fill_in "Size", with: @torrent.size
    fill_in "Source", with: @torrent.source
    fill_in "Stored", with: @torrent.stored
    fill_in "Stored name", with: @torrent.stored_name
    click_on "Update Torrent"

    assert_text "Torrent was successfully updated"
    click_on "Back"
  end

  test "destroying a Torrent" do
    visit torrents_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Torrent was successfully destroyed"
  end
end
