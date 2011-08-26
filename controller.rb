class Controller < Sinatra::Base
  
  before do
    session[:oauth] ||= {}
    
    @host = request.host
    @host << ":9292" if request.host == "localhost" # set to dev port if local
    
    consumer_key = ENV['consumer_key']
    consumer_secret = ENV['consumer_secret']
    
    @consumer ||= OAuth::Consumer.new(consumer_key, consumer_secret, :site => "http://twitter.com")
    
    if !session[:oauth][:request_token].nil? && !session[:oauth][:request_token_secret].nil?
      @request_token = OAuth::RequestToken.new(@consumer, session[:oauth][:request_token], session[:oauth][:request_token_secret])
    end
    
    if !session[:oauth][:access_token].nil? && !session[:oauth][:access_token_secret].nil?
      @access_token = OAuth::AccessToken.new(@consumer, session[:oauth][:access_token], session[:oauth][:access_token_secret])
    end
    
    if @access_token
      @client = Grackle::Client.new(:auth => {
        :type => :oauth,
        :consumer_key => consumer_key,
        :consumer_secret => consumer_secret,
        :token => @access_token.token,
        :token_secret => @access_token.secret
      })
    end
  end
  
  get '/?' do
    if @access_token
      @tweets = @client.statuses.friends_timeline? :count => 100
      erubis :index
    else
      '<a href="/login"><img src="/img/twitter-sign-in.png"/></a>'
    end
  end
  
  get '/login/?' do
    @request_token = @consumer.get_request_token(:oauth_callback => "http://#{@host}/auth")
    session[:oauth][:request_token] = @request_token.token
    session[:oauth][:request_token_secret] = @request_token.secret
    redirect @request_token.authorize_url
  end
  
  get '/auth/?' do
    @access_token = @request_token.get_access_token :oauth_verifier => params[:oauth_verifier]
    session[:oauth][:access_token] = @access_token.token
    session[:oauth][:access_token_secret] = @access_token.secret
    redirect '/'
  end
  
  get '/logout/?' do
    session[:oauth] = {}
    redirect '/'
  end
  
end