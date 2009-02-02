class NeighbourhoodsController < ApplicationController

  def show
    @neighbourhood = Neighbourhood.find_by_permalink(params[:id])
    @locations = @neighbourhood.locations
    build_map @locations
  end
end
