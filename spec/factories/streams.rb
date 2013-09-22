FactoryGirl.define do

  factory :stream do
    name "Radio gaga"
    url "http://example.com/stream.mp3"

    trait :invalid do
      name ""
    end
  end
end