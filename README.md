# geoip
Get information about a public IP address including Geolocation &amp; ISP

________________

# Information
This ruby script uses and API call to ip-api.com and extracts the json data in an easy to read format automatically for a quick and easy IP lookup.

A successful lookup will provide:
- Country
- Country Code
- Region
- Region Name
- City
- Zip Code
- Latitude
- Longitude
- Timezone
- Internet Service Provider (ISP)

________________

# How to use
_Run_

            $ ruby geoip.rb <IP ADDRESS>
    Example $ ruby geoip.rb 1.2.3.4
        
        OR
        
            $ chmod +x geoip.rb
            $ ./geoip.rb 1.2.3.4
            
            ##############################
            Results for 1.2.3.4:
            ##############################
                status          => success
	            country         => <country>
	            countryCode     => <country code>
	            region          => <region>
	            regionName      => <region name>
	            city            => <city>
	            zip             => <zip code>
	            lat             => <latitude>
	            lon             => <longitude>
	            timezone        => <timezone>
	            isp             => <internet service provider>
            ##############################
