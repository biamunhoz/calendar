require "application_system_test_case"

class UsuariosTest < ApplicationSystemTestCase
  setup do
    @usuario = usuarios(:one)
  end

  test "visiting the index" do
    visit usuarios_url
    assert_selector "h1", text: "Usuarios"
  end

  test "creating a Usuario" do
    visit usuarios_url
    click_on "New Usuario"

    fill_in "Emailalternativousuario", with: @usuario.emailAlternativoUsuario
    fill_in "Emailprincipalusuario", with: @usuario.emailPrincipalUsuario
    fill_in "Emailuspusuario", with: @usuario.emailUspUsuario
    fill_in "Loginusuario", with: @usuario.loginUsuario
    fill_in "Nomeusuario", with: @usuario.nomeUsuario
    fill_in "Numerotelefoneformatado", with: @usuario.numeroTelefoneFormatado
    fill_in "Ramalusp", with: @usuario.ramalUsp
    fill_in "Tipousuario", with: @usuario.tipoUsuario
    click_on "Create Usuario"

    assert_text "Usuario was successfully created"
    click_on "Back"
  end

  test "updating a Usuario" do
    visit usuarios_url
    click_on "Edit", match: :first

    fill_in "Emailalternativousuario", with: @usuario.emailAlternativoUsuario
    fill_in "Emailprincipalusuario", with: @usuario.emailPrincipalUsuario
    fill_in "Emailuspusuario", with: @usuario.emailUspUsuario
    fill_in "Loginusuario", with: @usuario.loginUsuario
    fill_in "Nomeusuario", with: @usuario.nomeUsuario
    fill_in "Numerotelefoneformatado", with: @usuario.numeroTelefoneFormatado
    fill_in "Ramalusp", with: @usuario.ramalUsp
    fill_in "Tipousuario", with: @usuario.tipoUsuario
    click_on "Update Usuario"

    assert_text "Usuario was successfully updated"
    click_on "Back"
  end

  test "destroying a Usuario" do
    visit usuarios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Usuario was successfully destroyed"
  end
end
