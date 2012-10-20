class CacheController < ApplicationController
  def index
    @gears = Gear.all
  end

  def about

  end
end
