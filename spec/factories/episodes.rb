FactoryGirl.define do
  factory :episode do
    program { FactoryGirl.create(:program) }
  end
end
