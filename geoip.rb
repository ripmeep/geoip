#!/usr/bin/env ruby

require 'socket'
require 'open-uri'
require 'net/http'
require 'json'


$bold      = "\x1b[1m"
$underline = "\x1b[4m"

$red    = "\x1b[91m"
$green  = "\x1b[92m"
$yellow = "\x1b[93m"
$white  = "\x1b[97m"
$grey   = "\x1b[90m"
$reset  = "\x1b[0m"

module GeoIP
      class Lookup
            @@api_url       = "http://ip-api.com"

            def api_url() @@api_url end
            def http_response() @@http_response end

            def initialize(ip_address)
                  @ip_address     = ip_address.to_s
                  @data_type      = "json"
                  @geoip_response = {'status_code': nil, 'response_body': nil}
            end

            attr_accessor :ip_address
            attr_reader :data_type
            attr_accessor :geoip_response

            def search_geoip
                  begin
                        forged_url = "#{@@api_url}/#{self.data_type}/#{self.ip_address}"
                        uri = URI.parse(forged_url)

                        http_request = Net::HTTP.new(uri.host, uri.port)
                        http_request = http_request.get(uri.request_uri)

                        self.geoip_response["status_code"] = http_request.code.to_i
                        self.geoip_response["response_body"] = http_request.body.to_s

                        return true
                  rescue
                        return false
                  end
            end
      end

      class Parser
            def self.show(geoip_results)
                  json_attributes = ["status", "country", "countryCode", "region", "regionName", "city", "zip", "lat", "lon", "timezone", "isp"]
                  json_attributes.each do |result|
                        puts "#{$reset}\t#{$bold}#{$underline}%s#{$reset}%s #{$green}=>#{$reset} #{$bold}#{$white}%s#{$reset}" % [result, " "*(15 - result.length), geoip_results[result].to_s]
                  end
            end

            def self.parse(geoip_results, show_results)
                  begin
                        results = JSON.parse(geoip_results)

                        if show_results
                              GeoIP::show_geoip_results(results)
                        end

                        return results
                  rescue
                        return false
                  end
            end
      end
end


def make_line(color, len)
      puts "#{color}#"*len.to_i
end

def has_internet_connection?
      begin
            true if Socket.gethostbyname("google.com")
      rescue
            false
      end
end

def main
      if not has_internet_connection?
            puts "#{$red}No internet connection found#{$reset}\n"
            exit(false)
      end

      if not ARGV[0]
            puts "#{$white}Usage $#{$reset} #{$yellow}#{__FILE__}#{$reset} <IP ADDRESS>"
            exit(false)
      end

      ip = ARGV[0].to_s

      geoip = GeoIP::Lookup.new(ip)

      if geoip.search_geoip
            if geoip.geoip_response["status_code"] == 200
                  results = GeoIP::Parser.parse(geoip.geoip_response["response_body"], false)
                  if results
                        puts ""
                        make_line($grey, 30)
                        puts "#{$bold}#{$green}Results for #{$white}#{geoip.ip_address}#{$reset}:"
                        make_line($grey, 30)
                        GeoIP::Parser.show(results)
                        make_line($grey, 30)
                        puts ""
                        exit(true)
                  else
                        puts "Couldnt get results"
                  end
            end
      else
            puts "#{$red}Something went wrong while searching for GeoIP data"
            exit(false)
      end

      return true
end

main
