class Uploader < Sinatra::Base
  
  before do
    oauth_connect
    s3_connect
  end
  
  get '/?' do
    if @access_token
      @user = @client.account.verify_credentials.json?
      @total_files = 1
      erubis :index
    else
      '<a href="/login"><img src="/img/twitter-sign-in.png"/></a>'
    end
  end
  
end