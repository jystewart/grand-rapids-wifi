class NeighbourhoodsController < ApplicationController

  def show
    @neighbourhood = Neighbourhood.find(params[:id])
    @locations = @neighbourhood.locations
    build_map @locations
  end
end
