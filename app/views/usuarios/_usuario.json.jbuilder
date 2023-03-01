json.extract! usuario, :id, :nomeUsuario, :loginUsuario, :tipoUsuario, :emailPrincipalUsuario, :emailAlternativoUsuario, :emailUspUsuario, :numeroTelefoneFormatado, :ramalUsp, :created_at, :updated_at
json.url usuario_url(usuario, format: :json)
