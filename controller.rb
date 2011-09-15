class Controller < Sinatra::Base
  
  before do
    oauth_connect
    s3_connect
  end
  
  get '/?' do
    init_user
    erubis :index
  end
  
  get '/login' do
    '<a href="/auth/twitter"><img src="/img/twitter-sign-in.png"/></a>'
  end
  
  get '/auth/twitter/?' do
    @request_token = @consumer.get_request_token(:oauth_callback => "http://#{@host}/auth/twitter/callback")
    session[:oauth][:request_token] = @request_token.token
    session[:oauth][:request_token_secret] = @request_token.secret
    redirect @request_token.authorize_url
  end
  
  get '/auth/twitter/callback/?' do
    @access_token = @request_token.get_access_token :oauth_verifier => params[:oauth_verifier]
    session[:oauth][:access_token] = @access_token.token
    session[:oauth][:access_token_secret] = @access_token.secret
    redirect '/'
  end
  
  get '/profile/?' do
    init_user
    if params['ajax']
      erubis :profile, :layout => false
    else
      erubis :profile
    end
  end
  
  get '/random/?' do
    init_user
    if params['ajax']
      erubis :random, :layout => false
    else
      erubis :random
    end
  end
  
  get '/logout/?' do
    session[:oauth] = {}
    session[:uid] = {}
    redirect '/'
  end
  
  get '/s3/?' do
    init_user
    @total_files = @bucket.inspect
    erubis :s3_test
  end
  
  get '/credcheck' do
    cred = @client.account.verify_credentials.json?
    id = cred.id
    id.inspect
  end
  
  get '/api/gif/random/?' do
    
  end    
  
  post '/gif/new' do
    init_user
    
    gifdir = File.join('public', 'gif')
    
    filename = File.join(gifdir, gen_short_url + '.gif')
    puts filename
    
    file = params[:file]
    puts file.inspect
    
    AWS::S3::S3Object.store(filename, open(file[:tempfile]), 'gif.st')
    
    "wrote to #{filename} on gif.st S3\n"
  end
  
  post '/gif/maybe' do
    init_user
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
  
  get '/favicon.ico' do
    ''
  end
  
  get '/:short_url' do
    begin
      @gif = Gif.get(params[:short_url])
      @gif.s3_location
    rescue
      puts 'invalid gif request'
      status 404
    end
  end
  
end