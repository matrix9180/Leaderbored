# LeaderboardsController is responsible for managing leaderboards.
# It provides actions to add a score to a leaderboard, delete a score from a leaderboard,
# get the top scores from a leaderboard, get the rank of a user, and reset a leaderboard.
class LeaderboardsController < ApplicationController
  # Sets the @leaderboard instance variable before each action.
  before_action :set_leaderboard

  # POST /leaderboards/:id/scores
  # Adds a score to the leaderboard.
  # Params:
  # +user_id+: The ID of the user.
  # +score+: The score to add.
  def add_score
    @leaderboard.add_score(params[:user_id], params[:score])
    head :no_content
  end

  # DELETE /leaderboards/:id/scores/:user_id
  # Deletes a user's score from the leaderboard.
  # Params:
  # +user_id+: The ID of the user whose score to delete.
  def delete_score
    @leaderboard.delete_score!(params[:user_id])
    head :no_content
  end

  # GET /leaderboards/:id/scores
  # Gets the top scores from the leaderboard.
  # Params:
  # +limit+: The maximum number of top scores to return (default is 10).
  def top_scores
    limit = params[:limit] || 10
    @scores = @leaderboard.top_scores(limit)
    render json: @scores
  end

  # GET /leaderboards/:id/ranks/:user_id
  # Gets the rank of a user in the leaderboard.
  # Params:
  # +user_id+: The ID of the user whose rank to get.
  def rank_of
    @rank = @leaderboard.rank_of(params[:user_id])
    render json: { rank: @rank }
  end

  # DELETE /leaderboards/:id
  # Resets the leaderboard.
  def reset
    @leaderboard.reset!
    head :no_content
  end

  private

  # Sets the @leaderboard instance variable to a new leaderboard with the given ID.
  # Params:
  # +id+: The ID of the leaderboard.
  def set_leaderboard
    @leaderboard = Leaderboard.new(id: params[:id])
  end
end
