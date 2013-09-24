FactoryGirl.define do
  factory :episode do
    podcast { FactoryGirl.create(:podcast) }

    trait :scheduled do
      scheduled_at { Time.now.tomorrow }
    end

    trait :scheduled_yesterday do
      scheduled_at { Time.now.yesterday }
    end
  end
end
