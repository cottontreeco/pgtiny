require 'test_helper'

class GearTest < ActiveSupport::TestCase
  fixtures :gears

  test "gear attributes must not be empty" do
    gear = Gear.new
    assert gear.invalid?
    assert gear.errors[:title].any?
    assert gear.errors[:category].any?
    assert gear.errors[:image_url].any?
  end

  def new_gear(image_url)
    gear = Gear.new(title: "Test Product",
                    category: "Test only",
                    image_url: image_url)
  end

  test "image url" do
    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif}
    bad = %w{fred.jpeg fred.gif/more fred.gif.more}

    ok.each do |name|
      assert new_gear(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_gear(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "gear is not valid without a unique title - i18n" do
    gear = Gear.new(title: gears(:iphone).title, image_url: "a.jpg", category: "T")
    assert !gear.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'),
                 gear.errors[:title].join('; ')
  end

end
