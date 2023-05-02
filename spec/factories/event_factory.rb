FactoryBot.define do
  factory :event do
    association :user

    title { Faker::Lorem.word }
    address { Faker::Address.full_address }
    datetime { Faker::Date.forward }
    description { Faker::Lorem.paragraph }

    # ORIGINAL:
    #file_img = Dir.glob('spec/fixtures/files/img/**/*').reject {|f| File.directory?(f)}.sample
    #image { Rack::Test::UploadedFile.new(file_img, Rack::Mime.mime_type(File.extname(file_img))) }
    #
    #file_ss = Dir.glob('spec/fixtures/files/spreadsheet/*').reject {|f| File.directory?(f)}.sample
    #box_office { Rack::Test::UploadedFile.new(file_ss, Rack::Mime.mime_type(File.extname(file_ss))) }
    #
    # workaround for passing tests on docker due to issues in
    # Rack::Test::UploadedFile
    # https://github.com/docker/for-linux/issues/1015
    after(:build) do |event|
      img_glob = Rails.root.join('spec', 'fixtures', 'files', 'img', '**', '*')
      img_path = Dir.glob(img_glob).reject {|f| File.directory?(f)}.sample
      event.image.attach(
        {
          io: File.open(img_path),
          filename: File.basename(img_path),
          content_type: Rack::Mime.mime_type(File.extname(img_path))
        }
      )

      ss_glob = Rails.root.join('spec', 'fixtures', 'files', 'spreadsheet', '*')
      ss_path = Dir.glob(ss_glob).reject {|f| File.directory?(f)}.sample
      event.box_office.attach(
        {
          io: File.open(ss_path),
          filename: File.basename(ss_path),
          content_type: Rack::Mime.mime_type(File.extname(ss_path))
        }
      )
    end

    factory :event_all do
      transient do
        guests_count {3}
        referral_count {3}
      end

      after(:create) do |event, evaluator|
        create_list :guest, evaluator.guests_count, event: event
        event.reload
      end
    end
  end
end