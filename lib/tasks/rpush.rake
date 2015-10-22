namespace :rpush do
  # USAGE:
  #   $ bundle exec rake rpush:install (APNS_ENV=[sandbox|production])
  task install: :environment do |current_task|
    puts "start #{current_task.name}"

    app_name = 'FeelingCall'
    apns_env = ENV['APNS_ENV'] ? ENV['APNS_ENV'] : (Rails.env.production? ? 'production' : 'sandbox')

    if Rpush::Apns::App.where(name: app_name, environment: apns_env).exists?
      puts 'already exists: (Rpush::Apns::App (name:%s environment:%s))' % [app_name, apns_env]

      next # end the task (almost same as method's return)
    end

    certificate_path = Rails.root.join('certificates', 'apns', "#{apns_env}.pem")

    Rpush::Apns::App.create!(
      name: app_name,
      certificate: File.read(certificate_path),
      environment: apns_env,
      password: Settings.rpush,
      connections: 1
    )
    puts "saved: RAILS_ENV=#{Rails.env}, APNS_ENV=#{apns_env}, certificate_path=#{certificate_path}"

    puts "end #{current_task.name}"
  end
end