require "spec_helper"

describe Square do
  
  let(:test_square){Square.new("g", "7")}
  let(:test_piece){Queen.new("white")}
  
  describe "#set_contents" do
    
    before do
      test_square.set_contents(test_piece)
    end
    
    context "when a piece is set on this square" do
      it "contains the piece that was set" do
        expect(test_square.contents).to eql(test_piece)
      end
    end
  end
  
  describe "#coords" do
    it "returns the square's proper coordinates" do
      expect(test_square.coords).to eql("g7")
    end
  end
end