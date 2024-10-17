Rails.application.routes.draw do
  
  #login e logout
  get 'welcome/login', as: 'login'
  get 'welcome/callback'
  get 'logout' => 'welcome#destroy', as: 'logout'
  
  resources :perfils
  resources :tipo_vinculos
  resources :usuarios

  if ENV["SALAOREQUIP"].to_s  == "sala"
    resources :salas
  else 
    resources :salas, path: 'equipamentos'
  end

  resources :agendas
  resources :events
  resources :senha_resets
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #inscricao e permissao
  get 'inscricao/:id' => 'agendas#inscricao', as: 'inscricao'
  get 'consulta/:id' => 'salas#consulta', as: 'consulta'
  get 'permissao/:id' => 'salas#permissao', as: 'permissao'

  get 'addadmin/:id/sala=:sala' => 'salas#addadmin', as: 'addadmin'
  get 'altersuper/:id/sala=:sala' => 'salas#altersuper', as: 'altersuper'
  get 'altersimples/:id/sala=:sala' => 'salas#altersimples', as: 'altersimples'
  get 'alterpendente/:id/sala=:sala' => 'salas#alterpendente', as: 'alterpendente'
  
  get 'removeracesso/:id/sala=:sala' => 'salas#removeracesso', as: 'removeracesso'

  get 'verinscritos/:id' => 'agendas#verinscritos', as: 'verinscritos'
  get 'inscreveoutro/:id/ag=:ag' => 'agendas#inscreveoutro', as: 'inscreveoutro'

  get 'alternegar/:id' => 'agendas#alternegar', as: 'alternegar'
  get 'alterinscrito/:id' => 'agendas#alterinscrito', as: 'alterinscrito'
  get 'alterusertipo/:id' => 'agendas#alterusertipo', as: 'alterusertipo'

  get 'listagem' => 'events#listagem', as: 'listagem'
  #get 'eventoagenda/:id' => 'events#eventoagenda', as: 'eventoagenda'

  get 'eventoagendalivres', to: 'events#eventoagendalivres', as: 'eventoagendalivres'

  get 'eventoagenda/:id', to: 'events#eventoagenda', as: 'eventoagenda'
  get 'resultagenda', to: 'events#resultagenda', as: 'resultagenda', defaults: { format: :json }

  get 'negarevento/:id' => 'events#negarevento', as: 'negarevento'
  get 'confirmarevento/:id' => 'events#confirmarevento', as: 'confirmarevento'

  get 'agendamentos/:id' => 'events#agendamentos', as: 'agendamentos'
  get 'deleteagend/:id' => 'events#deleteagend', as: 'deleteagend'

  get 'apresentasala' => 'events#apresentasala'

  get 'relgeral' => 'events#relgeral', as: 'relgeral'

  get 'login_ext' => 'session#new', as: 'login_ext'
  post 'login_ext' => 'session#create'
  get 'logout_ext' => 'session#destroy', as: 'logout_ext'


  #root 'welcome#login'

  root 'session#new'

  
end
