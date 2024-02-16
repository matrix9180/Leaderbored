class LeaderboardsController < ApplicationController
  before_action :set_leaderboard

  # POST /leaderboards/:id/scores
  def add_score
    @leaderboard.add_score(params[:user_id], params[:score])
    head :no_content
  end

  # DELETE /leaderboards/:id/scores/:user_id
  def delete_score
    @leaderboard.delete_score!(params[:user_id])
    head :no_content
  end

  # GET /leaderboards/:id/scores
  def top_scores
    limit = params[:limit] || 10
    @scores = @leaderboard.top_scores(limit)
    render json: @scores
  end

  # GET /leaderboards/:id/ranks/:user_id
  def rank_of
    @rank = @leaderboard.rank_of(params[:user_id])
    render json: { rank: @rank }
  end

  # DELETE /leaderboards/:id
  def reset
    @leaderboard.reset!
    head :no_content
  end

  private

  def set_leaderboard
    @leaderboard = Leaderboard.new(id: params[:id])
  end
end
