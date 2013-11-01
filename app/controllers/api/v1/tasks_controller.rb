class Api::V1::TasksController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                    :if => Proc.new { |c| c.request.format == 'application/json' }
  before_filter :authenticate_user!

  respond_to :json

  def index
    render :json => {
      "success" => true,
      "info" => "ok",
      "data" => {
          "tasks" => [
              {"title" => "Complete the app"},
              {"title" => "Complete the tutorial"}
          ]
      }
    }
  end
end
