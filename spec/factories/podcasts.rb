FactoryGirl.define do

  factory :podcast do
    name "My Podcast"
    stream { FactoryGirl.create(:stream) }
    length 60
    start_at Time.now
    day_of_week 6

    trait :invalid do
      name ""
    end

    trait :today do
      day_of_week Time.now.wday
    end

    trait :tomorrow do
      day_of_week Time.now.tomorrow.wday
    end

    trait :yesterday do
      day_of_week Time.now.yesterday.wday
    end
  end
end
