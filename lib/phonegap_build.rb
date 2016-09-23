require 'rest-client'
require 'json'
require 'uri'

require "phonegap_build/version"
require "phonegap_build/deep_struct"

API_BASE = 'https://build.phonegap.com/api/v1'

module PhonegapBuild
  class Client
    def initialize(username, password)
      @client = RestClient::Resource.new API_BASE, username, password
    end

    def me
      Resource.new(self, @client['me'])
    end

    def apps
      ResourceCollection.new(self, @client['apps'], false, 'apps')
    end

    def keys
      ResourceCollection.new(self, @client['keys'], false, 'keys')
    end

    def parse(text)
      JSON.parse(text, object_class: OpenStruct, array_class: Array)
    end

    def action(res, name, more = nil)
      available = { build: :post, unlock: :post }
      method = available[name.to_sym]
      puts res[name] if ENV['DEBUG']
      if method
        res = res[name]
        res = res[more] if more
        puts "#{method.upcase} #{res}" if ENV['DEBUG']
        res.send(method, data: {})
        true
      else
        false
      end
    end
  end

  class ResourceCollection
    def initialize(client, res, singular, xkey = nil)
      @client = client
      @res = res
      @singular = singular
      @key = xkey
    end

    def create(options)
      @client.parse(@res.post(options))
    end

    def method_missing(method, *arguments, &block)
      puts "MM_RC: #{method}" if ENV['DEBUG']
      if [:android, :ios].include?(method.to_sym)
        ResourceCollection.new(@client, @res[method], false, 'keys')
      else
        all.send(method, *arguments, &block)
      end
    end

    def all
      return @client.parse(@res.get)[@key] if !@singular
      return @client.parse(@res.get) if @singular
    end

    def find(id, options = {})
      Resource.new(@client, @res[id])
    end
  end

  class Resource
    def initialize(client, res)
      @client = client
      @res = res
    end

    def method_missing(method, *arguments, &block)
      puts "MM_R: #{method}" if ENV['DEBUG']
      if !@client.action(@res, method, arguments.first)
        @client.parse(@res.get()).send(method, *arguments, &block).get()
      end
    end

    def destroy
      @client.parse(@res.delete)
    end

    def update(options)
      puts @res if ENV['DEBUG']
      @client.parse(@res.put data: options)
    end

    def to_s
      @client.parse(@res.get())
    end
  end
end
