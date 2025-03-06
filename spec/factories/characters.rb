FactoryBot.define do
  factory :character do
    actor_name { FFaker::Name.name }
    character_name { FFaker::Name.name }
    serie {}
  end
end
