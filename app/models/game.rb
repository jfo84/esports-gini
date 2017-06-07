class Game < ApplicationRecord

  private

  def game_id_to_name_map
    @game_id_to_name_map ||= File.read('./game_id_to_name_map')
  end

end

## Example
# <%= line_chart @goals.map { |goal|
#     {name: goal.name, data: goal.feats.group_by_week(:created_at).count}
# } %>
