require_relative '../config/environment'
require 'benchmark/ips'

class LeaderboardModelBenchmark # :nodoc: all
  def initialize
    @leaderboard = Leaderboard.new(id: 'test')
    @user_id = 1
    @score = Random.rand(100_000_000_000_000)
  end

  def add_score
    @leaderboard.add_score(@user_id, @score)
  end

  def delete_score
    @leaderboard.delete_score!(@user_id)
  end

  def top_scores
    @leaderboard.top_scores(10)
  end

  def rank_of
    @leaderboard.rank_of(@user_id)
  end

  def reset
    @leaderboard.reset!
  end
end

benchmark = LeaderboardModelBenchmark.new

Benchmark.ips do |x|
  x.report('add_score') { benchmark.add_score }
  x.report('delete_score') { benchmark.delete_score }
  x.report('top_scores') { benchmark.top_scores }
  x.report('rank_of') { benchmark.rank_of }
  x.report('reset') { benchmark.reset }

  x.compare!
end
