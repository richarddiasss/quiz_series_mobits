require "application_system_test_case"

class CharactersTest < ApplicationSystemTestCase
  setup do
    @character = characters(:one)
  end

  test "visiting the index" do
    visit characters_url
    assert_selector "h1", text: "Characters"
  end

  test "creating a Character" do
    visit characters_url
    click_on "New Character"

    fill_in "Actor name", with: @character.actor_name
    fill_in "Character name", with: @character.character_name
    fill_in "Serie", with: @character.serie_id
    fill_in "Url photo", with: @character.url_photo
    click_on "Create Character"

    assert_text "Character was successfully created"
    click_on "Back"
  end

  test "updating a Character" do
    visit characters_url
    click_on "Edit", match: :first

    fill_in "Actor name", with: @character.actor_name
    fill_in "Character name", with: @character.character_name
    fill_in "Serie", with: @character.serie_id
    fill_in "Url photo", with: @character.url_photo
    click_on "Update Character"

    assert_text "Character was successfully updated"
    click_on "Back"
  end

  test "destroying a Character" do
    visit characters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Character was successfully destroyed"
  end
end
