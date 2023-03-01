require "application_system_test_case"

class AgendasTest < ApplicationSystemTestCase
  setup do
    @agenda = agendas(:one)
  end

  test "visiting the index" do
    visit agendas_url
    assert_selector "h1", text: "Agendas"
  end

  test "creating a Agenda" do
    visit agendas_url
    click_on "New Agenda"

    fill_in "Apresentacaotelaini", with: @agenda.apresentacaotelaini
    fill_in "Nome", with: @agenda.nome
    fill_in "Observacao", with: @agenda.observacao
    click_on "Create Agenda"

    assert_text "Agenda was successfully created"
    click_on "Back"
  end

  test "updating a Agenda" do
    visit agendas_url
    click_on "Edit", match: :first

    fill_in "Apresentacaotelaini", with: @agenda.apresentacaotelaini
    fill_in "Nome", with: @agenda.nome
    fill_in "Observacao", with: @agenda.observacao
    click_on "Update Agenda"

    assert_text "Agenda was successfully updated"
    click_on "Back"
  end

  test "destroying a Agenda" do
    visit agendas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Agenda was successfully destroyed"
  end
end
