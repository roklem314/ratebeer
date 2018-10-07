require 'rails_helper'

describe "BeermappingApi" do
  describe "in case of cache miss" do

    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do
        canned_answer = <<-END_OF_STRING
    <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

        stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

        places = BeermappingApi.places_in("turku")

        expect(places.size).to eq(1)
        place = places.first
        expect(place.name).to eq("Panimoravintola Koulu")
        expect(place.street).to eq("Eerikinkatu 18")
      end

    end

    describe "in case of cache hit" do
      before :each do
        Rails.cache.clear
      end

      it "When one entry in cache, it is returned" do
        canned_answer = <<-END_OF_STRING
    <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

        stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

        BeermappingApi.places_in("turku")
        places = BeermappingApi.places_in("turku")

        expect(places.size).to eq(1)
        place = places.first
        expect(place.name).to eq("Panimoravintola Koulu")
        expect(place.street).to eq("Eerikinkatu 18")
      end
  end

  it "When HTTP GET returns no entries, an empty table is returned" do
    canned_answer = <<~END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*meilahti/).to_return(body: answer, headers: { 'Content-Type' => "text/xml" })


    places = BeermappingApi.places_in("meilahti")

    expect(places).to be_empty
  end

  t "When HTTP GET returns several entries, return all of them" do
    canned_answer = <<~END_OF_STRING
        <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>15893</id><name>Trondhjem Mikrobryggeri</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/15893</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=15893&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=15893&amp;d=1&amp;type=norm</blogmap><street>Prinsens gate 39</street><city>Trondheim</city><state></state><zip>7011</zip><country>Norway</country><phone>+47 73 51 75 15</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>15899</id><name>Den Gode Nabo</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/15899</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=15899&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=15899&amp;d=1&amp;type=norm</blogmap><street>à˜vre Bakklandet 66</street><city>Trondheim</city><state></state><zip>7014</zip><country>Norway</country><phone>+47 40 61 88 09</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>15901</id><name>Cafe Dublin</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/15901</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=15901&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=15901&amp;d=1&amp;type=norm</blogmap><street>Kingensgate 15</street><city>Trondheim</city><state></state><zip>7013</zip><country>Norway</country><phone>+47 73500001</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING


    stub_request(:get, /.*trondheim/).to_return(body: answer, headers: { 'Content-Type' => "text/xml" })


    places = BeermappingApi.places_in("trondheim")

    expect(places.size).to eq 3

    place1 = places.first
    expect(place1.name).to eq "Trondhjem Mikrobryggeri"
    expect(place1.street).to eq "Prinsens gate 39"

    place2 = places.second
    expect(place2.name).to eq "Den Gode Nabo"
    expect(place2.street).to eq "à˜vre Bakklandet 66"

    place3 = places.second
    expect(place3.name).to eq "Cafe Dublin"
    expect(place3.street).to eq "Kingensgate 15"
  end

end
