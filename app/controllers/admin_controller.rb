class AdminController < ApplicationController
  def index
    @gear_count = Gear.count
  end
end
