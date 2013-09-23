FactoryGirl.define do

  factory :program do
    name "My Program"
    stream { FactoryGirl.create(:stream) }
    length 60
    start_at Time.now
    day_of_week 6

    trait :invalid do
      name ""
    end
  end
end