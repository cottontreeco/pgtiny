require 'spec_helper'

describe Product do
    before do @product =
        Product.new(description: "Test product")
    end

    subject {@product}
    it {should respond_to(:description)}
    it {should respond_to(:reviews)}
end
