class Sinatra::Base
  helpers do
    def h(text); Rack::Utils.escape_html text end
    
    def partial(template, *args)
      template_array = template.to_s.split('/')
      template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(:layout => false)
      if collection = options.delete(:collection) then
        collection.inject([]) do |buffer, member|
          buffer << erubis(:"#{template}", options.merge(:layout =>
          false, :locals => {template_array[-1].to_sym => member}))
        end.join("\n")
      else
        erubis(:"#{template}", options)
      end
    end
    
    def oauth_connect
      session[:oauth] ||= {}

      @host = request.host
      @host << ":9292" if request.host == "localhost" # set to dev port if local

      @consumer ||= OAuth::Consumer.new(settings.consumer_key, settings.consumer_secret, :site => "http://twitter.com")

      if !session[:oauth][:request_token].nil? && !session[:oauth][:request_token_secret].nil?
        @request_token = OAuth::RequestToken.new(@consumer, session[:oauth][:request_token], session[:oauth][:request_token_secret])
      end

      if !session[:oauth][:access_token].nil? && !session[:oauth][:access_token_secret].nil?
        @access_token = OAuth::AccessToken.new(@consumer, session[:oauth][:access_token], session[:oauth][:access_token_secret])
      end

      if @access_token
        begin
          @client = Grackle::Client.new(:auth => {
            :type => :oauth,
            :consumer_key => settings.consumer_key,
            :consumer_secret => settings.consumer_secret,
            :token => @access_token.token,
            :token_secret => @access_token.secret
          })
        rescue Grackle::TwitterError => error
          info "Twitter Error"
          @client = false
        end
      end
    end
    
    def s3_connect
      AWS::S3::Base.establish_connection!(
          :access_key_id     => settings.s3_key,
          :secret_access_key => settings.s3_secret
      )
      begin
        @bucket = AWS::S3::Bucket.find('gif.st')
      rescue
        info "S3 Error"
        @bucket = false
      end
    end
    
    def gen_short_url
      # Create an Array of possible characters
      chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
      # Create a random 3 character string from our possible
      # set of choices defined above.
      tmp = chars[rand(62)] + chars[rand(62)] + chars[rand(62)]

      # Until retreiving a Link with this short_url returns
      # false, generate a new short_url and try again.
      until Link.get(tmp).nil?
        tmp = chars[rand(62)] + chars[rand(62)] + chars[rand(62)]
      end

      # Return our new unique short_url
      tmp
    end
    
    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end

    def onclick_delete(msg='Are you sure?')
      %{ if (confirm('#{msg}')) {
           var f = document.createElement('form');
           f.style.display = 'none';
           this.parentNode.appendChild(f);
           f.method = 'POST';
           f.action = this.href;
           var m = document.createElement('input');
           m.setAttribute('type', 'hidden');
           m.setAttribute('name', '_method');
           m.setAttribute('value', 'delete');
           f.appendChild(m);f.submit();
         };
         return false;
       }
    end

    def onclick_put
      %{ var f = document.createElement('form');
         f.style.display = 'none';
         this.parentNode.appendChild(f);
         f.method = 'POST';
         f.action = this.href;
         var m = document.createElement('input');
         m.setAttribute('type', 'hidden');
         m.setAttribute('name', '_method');
         m.setAttribute('value', 'put');
         f.appendChild(m);
         f.submit();
         return false;
        }
    end
  end
end