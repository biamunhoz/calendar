class Sala < ApplicationRecord
  belongs_to :agenda
  has_many :events

  has_many :permissaos, :class_name => 'Permissao', dependent: :delete_all
  has_many :perfils, :through => :permissaos

  has_many :permissaos, :class_name => 'Permissao', dependent: :delete_all
  has_many :usuarios, :through => :permissaos

end
