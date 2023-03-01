require "application_system_test_case"

class TipoVinculosTest < ApplicationSystemTestCase
  setup do
    @tipo_vinculo = tipo_vinculos(:one)
  end

  test "visiting the index" do
    visit tipo_vinculos_url
    assert_selector "h1", text: "Tipo Vinculos"
  end

  test "creating a Tipo vinculo" do
    visit tipo_vinculos_url
    click_on "New Tipo Vinculo"

    fill_in "Codigosetor", with: @tipo_vinculo.codigoSetor
    fill_in "Codigounidade", with: @tipo_vinculo.codigoUnidade
    fill_in "Nomeabreviadsetor", with: @tipo_vinculo.nomeAbreviadSetor
    fill_in "Nomeabreviadofuncao", with: @tipo_vinculo.nomeAbreviadoFuncao
    fill_in "Nomesetor", with: @tipo_vinculo.nomeSetor
    fill_in "Nomeunidade", with: @tipo_vinculo.nomeUnidade
    fill_in "Nomevinculo", with: @tipo_vinculo.nomeVinculo
    fill_in "Siglaunidade", with: @tipo_vinculo.siglaUnidade
    fill_in "Tipovinculo", with: @tipo_vinculo.tipoVinculo
    fill_in "Usuario", with: @tipo_vinculo.usuario_id
    click_on "Create Tipo vinculo"

    assert_text "Tipo vinculo was successfully created"
    click_on "Back"
  end

  test "updating a Tipo vinculo" do
    visit tipo_vinculos_url
    click_on "Edit", match: :first

    fill_in "Codigosetor", with: @tipo_vinculo.codigoSetor
    fill_in "Codigounidade", with: @tipo_vinculo.codigoUnidade
    fill_in "Nomeabreviadsetor", with: @tipo_vinculo.nomeAbreviadSetor
    fill_in "Nomeabreviadofuncao", with: @tipo_vinculo.nomeAbreviadoFuncao
    fill_in "Nomesetor", with: @tipo_vinculo.nomeSetor
    fill_in "Nomeunidade", with: @tipo_vinculo.nomeUnidade
    fill_in "Nomevinculo", with: @tipo_vinculo.nomeVinculo
    fill_in "Siglaunidade", with: @tipo_vinculo.siglaUnidade
    fill_in "Tipovinculo", with: @tipo_vinculo.tipoVinculo
    fill_in "Usuario", with: @tipo_vinculo.usuario_id
    click_on "Update Tipo vinculo"

    assert_text "Tipo vinculo was successfully updated"
    click_on "Back"
  end

  test "destroying a Tipo vinculo" do
    visit tipo_vinculos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tipo vinculo was successfully destroyed"
  end
end
