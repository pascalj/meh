FactoryGirl.define do

  factory :program do
    name "My Program"
    stream { FactoryGirl.create(:stream) }
    length 60

    trait :invalid do
      name ""
    end
  end
end