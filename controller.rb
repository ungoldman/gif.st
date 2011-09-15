class Controller < Sinatra::Base
  
  before do
    oauth_connect
    s3_connect
  end
  
  get '/?' do
    if @access_token
      @user = @client.account.verify_credentials.json?
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
  
  get '/s3/?' do
    if @access_token
      @user = @client.account.verify_credentials.json?
      @total_files = @bucket.inspect
      erubis :s3_test
    else
      '<a href="/login"><img src="/img/twitter-sign-in.png"/></a>'
    end
  end
  
  get '/credcheck' do
    cred = @client.account.verify_credentials.json?
    id = cred.id
    id.inspect
  end
  
  post '/gif' do
    @gif = Gif.new(
      :short_url => gen_short_url,
      :filename => params[:filename],
      :s3_location => s3_save)
    
    # !!!!!
    # need to implement a method for saving to s3,
    # confirming save, then creating local object

    if @gif.save
      status 201
      redirect '/' + @gif.short_url
    else
      status 400
      'error'
    end
  end
  
  get '/:short_url' do
    begin
      @gif = Gif.get(params[:short_url])
      @gif.s3_location
    rescue
      status 404
    end
  end
  
end