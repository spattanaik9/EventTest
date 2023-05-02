FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    created_at { Faker::Date.backward }
    updated_at { Faker::Date.forward }
    is_admin { false }

    factory :user_with_events do
      transient do
        n_event { 3 }
      end

      after(:create) do |user, evaluator|
        create_list :event_all, evaluator.n_event, user: user
        user.reload
      end
    end
  end
end