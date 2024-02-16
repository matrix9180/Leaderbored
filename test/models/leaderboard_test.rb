# test/models/leaderboard_test.rb
require 'test_helper'

# The LeaderboardTest class tests the functionality of the Leaderboard model.
class LeaderboardTest < ActiveSupport::TestCase
  context 'Leaderboard' do
    setup do
      @leaderboard = Leaderboard.new(id: 'test')
      @leaderboard.reset! # Clear the leaderboard before each test
    end

    # Tests that a score can be added to the leaderboard.
    should 'add score to leaderboard' do
      @leaderboard.add_score(1, 100)
      assert_equal [['1', 100.0]], @leaderboard.top_scores(1)
    end

    # Tests that the top scores can be retrieved from the leaderboard.
    should 'return top scores' do
      @leaderboard.add_score(1, 100)
      @leaderboard.add_score(2, 200)
      @leaderboard.add_score(3, 300)
      assert_equal [['3', 300.0], ['2', 200.0], ['1', 100.0]], @leaderboard.top_scores(3)
    end

    # Tests that the rank of a user can be retrieved from the leaderboard.
    should 'return rank of user' do
      @leaderboard.add_score(1, 100)
      @leaderboard.add_score(2, 200)
      @leaderboard.add_score(3, 300)
      assert_equal 3, @leaderboard.rank_of(1)
      assert_equal 2, @leaderboard.rank_of(2)
      assert_equal 1, @leaderboard.rank_of(3)
    end

    # Tests that the leaderboard is empty by default.
    should 'be empty by default' do
      assert_equal [], @leaderboard.top_scores(1)
    end

    # Tests that the rank of a user not in the leaderboard is nil.
    should 'return nil rank for user not in leaderboard' do
      assert_nil @leaderboard.rank_of(1)
    end

    # Tests that scores are sorted correctly when they are the same.
    should 'sort scores correctly when they are the same' do
      @leaderboard.add_score(1, 100)
      @leaderboard.add_score(2, 100)
      assert_equal [['2', 100.0], ['1', 100.0]], @leaderboard.top_scores(2)
    end

    # Tests that a score can be deleted from the leaderboard.
    should 'delete score from leaderboard' do
      @leaderboard.add_score(1, 100)
      @leaderboard.delete_score!(1)
      assert_equal [], @leaderboard.top_scores(1)
    end

    # Tests that the leaderboard can be reset.
    should 'reset leaderboard' do
      @leaderboard.add_score(1, 100)
      @leaderboard.reset!
      assert_equal [], @leaderboard.top_scores(1)
    end

    # Tests that top_scores does not return more scores than exist in the leaderboard.
    should 'not return more scores than exist' do
      @leaderboard.add_score(1, 100)
      assert_equal [['1', 100.0]], @leaderboard.top_scores(3)
    end
  end
end
