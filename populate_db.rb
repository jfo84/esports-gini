module JSON
  def self.parse_with_nil(json)
    JSON.parse(json) if json && json.length >= 2
  end
end

def game_id_to_name_map
  @game_id_to_name_map ||= JSON.parse(File.read('./game_id_to_name_map.json'))
end

def query_by_game_id(game_id, offset)
  Typhoeus.get("http://api.esportsearnings.com/v0/LookupHighestEarningPlayersByGame?apikey=#{ENV.fetch('ESPORTS_EARNINGS_API_KEY')}&gameid=#{game_id}&offset=#{offset}")
end

game_id_to_name_map.each_with_index do |(game_id, name), index|
  player_array = []

  loop.with_index do |_, index|
    offset = index * 100
    response = query_by_game_id(game_id, offset)
    player_batch = JSON.parse_with_nil(response.body)

    break if player_batch.blank? || player_batch.size == 0 || player_batch == { "ErrorCode" => 1011 }

    player_array << player_batch

    player_batch.each do |player|
      player_id = player['PlayerId']

      Player.create!(data: player, game_id: game_id.to_i, player_id: player_id)
    end

    # Conservatively wait for 1 second delay
    sleep 5

    break if player_batch.size < 100
  end

  Game.create!(players: player_array.flatten)
end
