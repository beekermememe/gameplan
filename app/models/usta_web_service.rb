class UstaWebService
  BASEURL = 'http://tennislink.usta.com/PublicWebServices/LeaguesMobile.asmx'


  class << self
    def update_user(usta_number,expected_name,current_user)
      response = get_user(usta_number: usta_number) #sampler_get_user_response # search(params)
      xml_doc  = Nokogiri::XML(response)

      xml_doc.xpath('userinfo').each do |userinfo|
        name = userinfo.xpath('name').children.first.text
        if name.downcase != expected_name.downcase

        else
          referenced_user = current_user
          user_to_copy = nil
          User.where({usta_number: usta_number}).each do |user|
            if(user.email != current_user.email)
              if !user_to_copy
                user_to_copy = user
              else
                user.delete!
              end
            end
          end

          if user_to_copy
            copy_from_existing_user(referenced_user, user_to_copy)
          else
            update_user_from_usta(referenced_user,usta_number,userinfo)
          end
        end
      end
      puts "Updated"
    end

    def update_user_from_usta(referenced_user,usta_number,userinfo)
      referenced_user.ranking = userinfo.xpath('//ntrprating').children.first.text
      teams = []
      userinfo.xpath('//teams/team').each do |team|
        teams << {
            teamname: team.xpath('//teamname').children.first ? team.xpath('//teamname').children.first.text : nil,
            teamid: team.xpath('//championshipyear').children.first ? team.xpath('//teamid').children.first.text : nil,
            teamcode: team.xpath('//teamcode').children.first ? team.xpath('//teamcode').children.first.text : nil,
            championshipyear: team.xpath('//championshipyear').children.first ? team.xpath('//championshipyear').children.first.text : nil,
        }
      end
      referenced_user.team = teams
      referenced_user.save!
      search_results = search_single_user(first_name: referenced_user.name.split(" ")[0],
                                          last_name: referenced_user.name.split(" ")[1],state: referenced_user.state,
                                          gender: nil, exact_match: 'true', usta_number: referenced_user.usta_number)
      if !search_results.empty?
        referenced_user.state = search_results[:state]
        referenced_user.city = search_results[:city]
        referenced_user.save!
      end
    end

    def copy_from_existing_user(referenced_user, user_to_copy)
      referenced_user.city = user_to_copy.city
      referenced_user.ranking = user_to_copy.ranking
      referenced_user.team = user_to_copy.team
      referenced_user.city = user_to_copy.city
      referenced_user.state = user_to_copy.state
      referenced_user.save!
      Match.where(opponent_id: user_to_copy.id).all do |match|
        match.opponent_id = referenced_user.id
        match.save!
      end
      user_to_copy.delete!
    end

    def search_single_user(first_name: nil, last_name: nil, state: nil, gender: nil, exact_match: 'true', usta_number: usta_number)
      result =  search({first_name: first_name, last_name: last_name, gender: gender, exact_match: exact_match})
      xml_doc  = Nokogiri::XML(result)
      player_info = nil
      xml_doc.xpath('//players/player').each do |player|
        ustanumber = player.xpath('//playerid').children.first.text
        next if usta_number != ustanumber
        player_info = parse_player(player: player)
      end
      player_info
    end

    def parse_player(player: )
      lastname = player.xpath('//lastname').children.first.text
      firstname = player.xpath('//firstname').children.first.text
      ustanumber = player.xpath('//playerid').children.first.text
      ranking = player.xpath('//ntrp').children.first.text
      state = player.xpath('//state').children.first.text
      city = player.xpath('//city').children.first.text
      teams = []
      player.xpath('//teams/team').each do |team|
        teams << {
            teamname: team.xpath('//teamname').children.first.text,
            teamid: team.xpath('//teamid').children.first.text,
            teamcode: team.xpath('//teamcode').children.first.text,
            championshipyear: team.xpath('//championshipyear').children.first.text,
        }
      end
      {
          name: "#{firstname} #{lastname}",
          usta_number: ustanumber,
          ranking: ranking,
          state: state,
          city: city,
          team: teams
      }
    end

    def search_user(first_name: nil, last_name: nil, state: nil, gender: nil, exact_match: 'false')
      params = {}
      params.update(first_name: first_name) if(first_name)
      params.update(last_name: last_name) if(last_name)
      params.update(state: state) if(state)
      params.update(gender: gender) if(first_name)
      params.update(exact_match: exact_match)
      existing_usta = []
      results = []
      if first_name && first_name.length > 3 && last_name && last_name.length > 3
        response = sample_search_response # search(params)
        xml_doc  = Nokogiri::XML(response)

        xml_doc.xpath('players/player').each do |player|
          results << parse_player(player: player)
        end

        user_results = []
        results.each do |result|
          next if existing_usta.include?(result[:usta_number])
          existing_usta << result[:usta_number]
          existing = result[:usta_number] ? User.find_by_usta_number(result[:usta_number]) : nil
          if existing
            existing.update!(result)
            user_results << [ existing.id, existing.name, existing.city, existing.state ]
          else
            result[:email] = "#{Time.now.to_i}_random@unknown.com"
            result[:password] = "#{Time.now.to_i}#{rand(100000)}"
            new_user = User.create!(result)
            user_results << [ new_user.id, new_user.name, new_user.city, new_user.state ]
          end
        end
        user_results
      else
        []
      end
    end

    def get_user(usta_number: nil)
      return unless usta_number
      soap = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
<websrcv_get_user xmlns="http://tempuri.org/">
<iUSTANumber>' + usta_number + '</iUSTANumber>
</websrcv_get_user>
</soap:Body>
</soap:Envelope>'
      http = Curl.http('POST',BASEURL,soap) do |http|
        http.headers['Content-Type'] = 'text/xml; charset=utf-8'
      end
      CGI.unescapeHTML http.body_str.split('<websrcv_get_userResult>')[1].split('</websrcv_get_userResult>')[0]
    end

    def search(params)
      soap = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
<websrvc_player_search xmlns="http://tempuri.org/">
<sFirstName>' + params[:first_name].to_s + '</sFirstName>
<sLastName>' + params[:last_name].to_s + '</sLastName>
<sGender>' + params[:gender].to_s + '</sGender>
<sState>' + params[:state].to_s + '</sState>
<bExactMatch>' + params[:exact_match].downcase + '</bExactMatch>
 <sYear>' + params[:year].to_s + '</sYear>
</websrvc_player_search>
</soap:Body>
</soap:Envelope>'
      http = Curl.http('POST',BASEURL,soap) do |http|
        http.headers['Content-Type'] = 'text/xml; charset=utf-8'
      end
      CGI.unescapeHTML http.body_str.split('<websrvc_player_searchResult>')[1].split('</websrvc_player_searchResult>')[0]
    end

    def sample_team_response
      '<team><teamname>RCC GREEN</teamname><wins>0</wins><losses>0</losses><leagueid>58998</leagueid><leaguename>2018 TRIO - DEN</leaguename><district>COLORADO</district><section>USTA/INTERMOUNTAIN</section><flightid>289170</flightid><flightname>WOMEN 3.5 - TRIO</flightname><subflightid>393199</subflightid><subflightname>NORTH</subflightname><captain>Alisa Quinn</captain><captainustanumber>2008293988</captainustanumber><cocaptain /><cocaptainustanumber /><facilityname>Ranch Country Club</facilityname><facilitycity>Westminster</facilitycity><facilitystate>CO</facilitystate><championshipyear>2018</championshipyear><leagueTypeId>14</leagueTypeId><isEkoluPlayerEnterMoreMatchesAllowed>False</isEkoluPlayerEnterMoreMatchesAllowed><MatchWinCriteriaID>1</MatchWinCriteriaID></team>'
    end
    def sampler_get_user_response
      '<userinfo><name>Jill Keogh</name><ntrprating>3.5</ntrprating><teams><team><leagueid>58998</leagueid><leaguename>2018 TRIO - DEN</leaguename><flightname>WOMEN 3.5 - TRIO</flightname><flightid>289170</flightid><teamid>1288604</teamid><teamname>RCC GREEN</teamname><teamcode>2572300215</teamcode><cyear>2018</cyear></team><team><leagueid>59000</leagueid><leaguename>2018 USTA ADULT 18 &amp; OVER - DEN</leaguename><flightname>WOMEN 3.5 - 18 &amp; OVER</flightname><flightid>289185</flightid><teamid>1288171</teamid><teamname>RCC RED</teamname><teamcode>2572299770</teamcode><cyear>2018</cyear></team><team><leagueid>54198</leagueid><leaguename>2017 USTA ADULT 18 &amp; OVER - DEN</leaguename><flightname>WOMEN 3.5 - 18 &amp; OVER</flightname><flightid>265125</flightid><teamid>1200258</teamid><teamname>RCC BLUE</teamname><teamcode>2572205982</teamcode><cyear>2017</cyear></team><team><leagueid>54189</leagueid><leaguename>2017 USTA ADULT 40 &amp; OVER - DEN</leaguename><flightname>WOMEN 3.5 - 40 &amp; OVER</flightname><flightid>265058</flightid><teamid>1200670</teamid><teamname>RCC BLUE</teamname><teamcode>2572206398</teamcode><cyear>2017</cyear></team><team><leagueid>54196</leagueid><leaguename>2017 TRIO - DEN</leaguename><flightname>WOMEN 3.5 - TRIO</flightname><flightid>265109</flightid><teamid>1202069</teamid><teamname>RCC GREEN</teamname><teamcode>2572207803</teamcode><cyear>2017</cyear></team><team><leagueid>54193</leagueid><leaguename>2017 CTA TWILIGHT - DEN</leaguename><flightname>WOMEN 3.5 - TWILIGHT</flightname><flightid>265087</flightid><teamid>1199667</teamid><teamname>RCC RED</teamname><teamcode>2572205388</teamcode><cyear>2017</cyear></team></teams></userinfo>'
    end

    def sample_search_response
      '<players><player><firstname>Sarah</firstname><middlename/><lastname>Post</lastname><playerid>11115023</playerid><ntrp>3.5</ntrp><state>TX</state><city>San Angelo</city><teams><team><teamid>1324158</teamid><teamcode>8096337381</teamcode><teamname>Halfman/Huffman</teamname><championshipyear>2018</championshipyear></team><team><teamid>1324166</teamid><teamcode>8096337389</teamcode><teamname>Jett/Lane</teamname><championshipyear>2018</championshipyear></team></teams></player><player><firstname>Sarah</firstname><middlename /><lastname>Post</lastname><playerid>2010758580</playerid><ntrp>3.0       </ntrp><state>CO</state><city>Broomfield</city><teams><team><teamid>1287806</teamid><teamcode>2572299405</teamcode><teamname>BRMST GREEN</teamname><championshipyear>2018</championshipyear></team></teams></player><player><firstname>Sarah</firstname><middlename/><lastname>Post</lastname><playerid>11115023</playerid><ntrp>3.5</ntrp><state>TX</state><city>San Angelo</city><teams><team><teamid>1221241</teamid><teamcode>8096227921</teamcode><teamname>Pfluger/Swartz</teamname><championshipyear>2017</championshipyear></team><team><teamid>1238573</teamid><teamcode>8096246962</teamcode><teamname>Bright</teamname><championshipyear>2017</championshipyear></team><team><teamid>1238657</teamid><teamcode>8096247049</teamcode><teamname>Bright</teamname><championshipyear>2017</championshipyear></team></teams></player><player><firstname>Sarah</firstname><middlename /><lastname>Post</lastname><playerid>2010758580</playerid><ntrp>3.0       </ntrp><state>CO</state><city>Broomfield</city><teams><team><teamid>1198715</teamid><teamcode>2572204418</teamcode><teamname>BRMST RED</teamname><championshipyear>2017</championshipyear></team><team><teamid>1200604</teamid><teamcode>2572206331</teamcode><teamname>BRMST GREEN</teamname><championshipyear>2017</championshipyear></team><team><teamid>1199609</teamid><teamcode>2572205330</teamcode><teamname>BRMST GREEN</teamname><championshipyear>2017</championshipyear></team></teams></player></players>'
    end
  end
end