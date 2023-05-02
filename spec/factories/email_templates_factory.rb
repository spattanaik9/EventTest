FactoryBot.define do
  factory :email_template do
    association :event
    association :user

    name { Faker::Lorem.word }
    subject { Faker::Lorem.sentence }
    body { Faker::Lorem.sentence }

    trait :is_html do
      is_html { [true, false].sample }
    end

    after(:build) do |template|
      file_glob = Rails.root.join('spec', 'fixtures', 'files', '**', '*')
      file_path = Dir.glob(file_glob).reject {|f| File.directory?(f)}.sample
      template.attachments.attach(
        {
          io: File.open(file_path),
          filename: File.basename(file_path),
          content_type: Rack::Mime.mime_type(File.extname(file_path))
        }
      )
    end

    factory :email_template_html, traits: [:is_html]
  end
end