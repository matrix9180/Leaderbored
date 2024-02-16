# app/models/leaderboard.rb

# The Leaderboard class represents a leaderboard in the application.
# It uses a Redis sorted set to store scores, where each score is associated with a user_id.
# The scores are automatically sorted in ascending order by Redis.
class Leaderboard
  include ActiveModel::Model

  attr_accessor :id

  # Returns the Redis connection.
  def redis
    @redis ||= Redis.new
  end

  # Adds a score for a user to the leaderboard.
  #
  # @param user_id [Integer] The ID of the user.
  # @param score [Integer] The score to add.
  def add_score(user_id, score)
    redis.zadd("leaderboard:#{id}", score, user_id)
  end

  # Returns the top scores from the leaderboard.
  #
  # @param limit [Integer] The number of top scores to return. Defaults to 10.
  # @return [Array<Array>] An array of arrays, where each sub-array contains a user_id and a score.
  def top_scores(limit = 10)
    redis.zrevrange("leaderboard:#{id}", 0, limit - 1, with_scores: true)
  end

  # Returns the rank of a user in the leaderboard.
  #
  # @param user_id [Integer] The ID of the user.
  # @return [Integer, nil] The rank of the user, or nil if the user is not in the leaderboard.
  def rank_of(user_id)
    rank = redis.zrevrank("leaderboard:#{id}", user_id)
    rank ? rank + 1 : nil
  end
end
