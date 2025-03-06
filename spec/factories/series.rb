FactoryBot.define do
  factory :serie do
    name_pt { FFaker::Movie.title }
    original_name { FFaker::Movie.title }
    country { FFaker::Address.country }
    # adicione outros atributos necessários para o seu modelo User
  end
end