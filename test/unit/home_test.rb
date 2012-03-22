require 'test_helper'

class HomeTest < ActiveSupport::TestCase
  test "home attributes must not be empty" do
    home = Home.new
    assert home.invalid?
    assert home.errors[:street].any?
    assert home.errors[:city].any?
    assert home.errors[:state].any?
    assert home.errors[:zip].any?
  end

  test "zip code must be valid" do
    ok = %w{00000, 00000-0000, 00000-a, 12345-67890}
    bad = %w{0, 1a2b3, 123456-1, -1234, -}

    ok.each do |zcode|
      assert new_home(zcode).valid?, "#{zcode} shouldn't be invalid"
    end

    bad.each do |zcode|
      assert new_home(zcode).invalid?, "#{zcode} shouldn't be valid"
    end
  end

  def new_home(zipcode)
    Home.new(street: "123 My St",
             city: "My City",
             state: "My State",
             zip: zipcode)
  end
end
