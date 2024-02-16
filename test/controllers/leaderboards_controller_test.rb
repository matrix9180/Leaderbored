# test/controllers/leaderboards_controller_test.rb
require 'test_helper'

class LeaderboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @leaderboard_id = 'test'
    @leaderboard = Leaderboard.new(id: @leaderboard_id)
    @leaderboard.reset! # Clear the leaderboard before each test
  end

  context 'POST /leaderboards' do
    should 'create a new leaderboard' do
      post leaderboards_url, params: { id: 'new' }, as: :json
      assert_response :created
      assert_equal('new', JSON.parse(@response.body)['id'])
    end
  end

  context 'POST /leaderboards/:id/scores' do
    should 'add score to leaderboard' do
      post add_score_leaderboard_url(@leaderboard_id), params: { user_id: 1, score: 100 }, as: :json
      assert_response :no_content
      assert_equal [['1', 100.0]], @leaderboard.top_scores(1)
    end
  end

  context 'DELETE /leaderboards/:id/scores/:user_id' do
    setup do
      @leaderboard.add_score(1, 100)
    end

    should 'delete score from leaderboard' do
      delete score_leaderboard_url(@leaderboard_id, 1), as: :json
      assert_response :no_content
      assert_equal [], @leaderboard.top_scores(1)
    end
  end

  context 'GET /leaderboards/:id/scores' do
    setup do
      @leaderboard.add_score(1, 100)
      @leaderboard.add_score(2, 200)
    end

    should 'get top scores' do
      get scores_leaderboard_url(@leaderboard_id), as: :json
      assert_response :success
      assert_equal [['2', 200.0], ['1', 100.0]], JSON.parse(@response.body)
    end
  end

  context 'GET /leaderboards/:id/ranks/:user_id' do
    setup do
      @leaderboard.add_score(1, 100)
      @leaderboard.add_score(2, 200)
    end

    should 'get rank of user' do
      get rank_leaderboard_url(@leaderboard_id, 1), as: :json
      assert_response :success
      assert_equal({ 'rank' => 2 }, JSON.parse(@response.body))
    end
  end

  context 'DELETE /leaderboards/:id' do
    setup do
      @leaderboard.add_score(1, 100)
    end

    should 'reset leaderboard' do
      delete reset_leaderboard_url(id: @leaderboard_id), as: :json
      assert_response :no_content
      assert_equal [], @leaderboard.top_scores(1)
    end
  end
end
