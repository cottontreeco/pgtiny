class CacheController < ApplicationController
  def index
    @gears = Gear.all
  end
end
