require 'rubygems'
require 'net/http'
require 'net/https'

class MOSTO
    attr_accessor :username, :password
    URL = "http://mosto.in"

    def initialize(username,password)
      @username = username
      @password = password
      @url = URL
    end

    def send(mobilenos, senderid, msg)
      mobile_nos = mobilenos.is_a?(Array) ? mobilenos.join(',') : mobilenos
      params = {:username => username, :password => password, :mobile => mobile_nos, :message => msg , :sender => senderid , :response => "json"}
      uri = full_path('/api/send.php', params)
      response = Net::HTTP.get(uri)
    end

    def balance
      params = {:authkey => username, :password => password, :response => "json"}
      uri = full_path('/api/balance.php', params)
      response = Net::HTTP.get(uri)
    end

    def full_path(path, params)
      encoded_params = URI.encode_www_form(params)
      params_string = [path, encoded_params].join("?")
      URI.parse(@url + params_string)
    end
end
