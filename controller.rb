class Controller < Sinatra::Base
  
  before do
    oauth_connect
    s3_connect
  end
  
  get '/?' do
    init_user
    @gif = Gif.get(1+rand(Gif.count))
    if @gif
      erubis :gif
    else
      erubis :index
    end
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
    @profile = @user
    if params['ajax']
      erubis :profile, :layout => false
    else
      erubis :profile
    end
  end
  
  get '/profile/:user/?' do
    init_user
    @profile = User.first(:name => params[:user])
    if @profile
      if params['ajax']
        erubis :profile, :layout => false
      else
        erubis :profile
      end
    else
      'invalid profile'
    end
  end
  
  get '/latest/?' do
    init_user
    @gif = Gif.last
    if @gif
      if params['ajax']
        erubis :gif, :layout => false
      else
        erubis :gif
      end
    else
      if params['ajax']
        erubis :index, :layout => false
      else
        erubis :index
      end
    end
  end
  
  get '/random/?' do
    init_user
    @gif = Gif.get(1+rand(Gif.count))
    if @gif
      if params['ajax']
        erubis :gif, :layout => false
      else
        erubis :gif
      end
    else
      if params['ajax']
        erubis :index, :layout => false
      else
        erubis :index
      end
    end
  end
  
  get '/logout/?' do
    session[:oauth] = {}
    session[:uid] = {}
    redirect '/'
  end
  
  post '/gif/new' do
    init_user
    
    gifdir = File.join('public', 'gif')
    short_url = gen_short_url
    filename = File.join(gifdir, short_url + '.gif')    
    file = params[:file]
    
    puts filename
    
    @gif = Gif.new(
      :short_url => short_url,
      :filename => filename
    )
    @gif.user = @user
    
    puts @gif.inspect
    
    @save = AWS::S3::S3Object.store(
      filename,
      open(file[:tempfile]),
      'gif.st',
      :access => :public_read
    )
    
    if @save
      puts 'file saved on gif.st s3 bucket'
    end
    
    if @gif.save
      status 201
      redirect '/g/' + short_url
    else
      status 400
      'error saving gif to database'
    end
  end
  
  get '/favicon.ico' do
    ''
  end
  
  get '/g/:short_url/?' do
    init_user
    @gif = Gif.first(:short_url => params[:short_url])
    if @gif
      erubis :gif
    else
      'invalid gif'
    end
  end
  
  get '/:short_url/?' do
    @gif = Gif.first(:short_url => params[:short_url])
    if @gif
      '<img src="' + @gif.location + '" />'
    else
      'invalid gif'
    end
  end
  
end