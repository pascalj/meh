FactoryGirl.define do
  factory :episode do
    podcast { FactoryGirl.create(:podcast) }
  end
end
