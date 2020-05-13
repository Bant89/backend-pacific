# frozen_string_literal: true

module RequestSpecHelper
  # Parse json to ruby hash
  def json
    JSON.parse(response.body)
  end
end
