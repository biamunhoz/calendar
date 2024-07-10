# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_07_10_182641) do

  create_table "agendamentos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "data_inicio"
    t.date "data_fim"
    t.time "hora_inicio"
    t.time "hora_fim"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_agendamentos_on_event_id"
  end

  create_table "agendas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nome"
    t.boolean "apresentacaotelaini"
    t.string "observacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tipo"
    t.boolean "validaextra"
    t.string "reservadoformextra"
    t.boolean "mostrainfouser", default: false
  end

  create_table "events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.date "start_date"
    t.string "datetime"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "descricao"
    t.boolean "domingo"
    t.boolean "segunda"
    t.boolean "terca"
    t.boolean "quarta"
    t.boolean "quinta"
    t.boolean "sexta"
    t.boolean "sabado"
    t.boolean "pendente"
    t.string "registropara"
    t.integer "sala_id"
    t.integer "usuario_id"
    t.time "timeini"
    t.time "timefim"
    t.boolean "desmarcado", default: false
  end

  create_table "inscricaos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "usuario_id"
    t.bigint "agenda_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tipo"
    t.string "usertipo"
    t.index ["agenda_id"], name: "index_inscricaos_on_agenda_id"
    t.index ["usuario_id"], name: "index_inscricaos_on_usuario_id"
  end

  create_table "perfils", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nomeperfil"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissaos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "usuario_id"
    t.bigint "sala_id"
    t.bigint "perfil_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perfil_id"], name: "index_permissaos_on_perfil_id"
    t.index ["sala_id"], name: "index_permissaos_on_sala_id"
    t.index ["usuario_id"], name: "index_permissaos_on_usuario_id"
  end

  create_table "salas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nome"
    t.string "cor"
    t.boolean "permissaoauto"
    t.text "observacao"
    t.boolean "confirmacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "agenda_id"
    t.boolean "avisoadmhoravaga", default: false
    t.boolean "limiteqtdeuso", default: false
    t.integer "limitehoras"
    t.boolean "bloqforaintervalo", default: false
    t.time "prihoraini"
    t.time "prihorafim"
    t.time "seghoraini"
    t.time "seghorafim"
    t.integer "valorinterval"
    t.boolean "disablefds", default: false
    t.boolean "permitiapagarevento", default: true
  end

  create_table "tipo_vinculos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tipoVinculo"
    t.string "codigoSetor"
    t.string "nomeAbreviadSetor"
    t.string "nomeSetor"
    t.string "codigoUnidade"
    t.string "siglaUnidade"
    t.string "nomeUnidade"
    t.string "nomeVinculo"
    t.string "nomeAbreviadoFuncao"
    t.bigint "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_tipo_vinculos_on_usuario_id"
  end

  create_table "usuarios", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nomeUsuario"
    t.string "loginUsuario"
    t.string "tipoUsuario"
    t.string "emailPrincipalUsuario"
    t.string "emailAlternativoUsuario"
    t.string "emailUspUsuario"
    t.string "numeroTelefoneFormatado"
    t.string "ramalUsp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cpf"
    t.string "endereco"
    t.string "tel_contato"
    t.string "password_digest"
    t.string "auth_token"
    t.string "senha_reset_token"
    t.datetime "senha_reset_sent_at"
    t.string "instituicao"
    t.string "vinculo"
  end

  add_foreign_key "agendamentos", "events"
  add_foreign_key "inscricaos", "agendas"
  add_foreign_key "inscricaos", "usuarios"
  add_foreign_key "permissaos", "perfils"
  add_foreign_key "permissaos", "salas"
  add_foreign_key "permissaos", "usuarios"
  add_foreign_key "tipo_vinculos", "usuarios"
end
