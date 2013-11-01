namespace :kakao do
  # kakao access_token, uid 가 제대로 된 유저인지 확인
  task :user_validate => :environment do
    # validation 해야하는 유저들
    users = User.where(:is_validated => nil)
    users.find_each do |user|
      #https://api.kakao.com/v1/token/check.json / GET
    #  access_token, user_id, client_id, sdkver
      require 'net/http'

      access_token = user.kakao_access_token
      user_id = user.uid
      client_id = 90575957607253040
      sdkver = "1.2.0"

      uri = URI('https://api.kakao.com/v1/token/check.json')
      args = {access_token: access_token, user_id: user_id, client_id: client_id, sdkver: sdkver}
      uri.query = URI.encode_www_form(args)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)

      # success : code = 200, status = 0
      # 그 이외에 unauthorized, unregistered, parameter error 가 있음
      if response.code.to_i == 200
        begin
          json_body = JSON.parse response.body
          status_key = "status"
          if json_body[status_key] and json_body[status_key] == 0
            user.is_validated = true
          end
        rescue => e
          user.is_validated = false
          puts e
        end
      else
        user.is_validated = false
      end
      user.save!
    end
  end
end