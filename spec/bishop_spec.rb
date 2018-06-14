require "spec_helper"

describe Bishop do
  
  let(:test_board){Board.new("test", "board")}
  let(:test_bishop){Bishop.new("white")}
  
  describe "#possible_moves" do
    
    before do
      test_board.set_piece("a3", test_bishop)
    end
    
    it "returns diagonal squares" do
      expect(test_bishop.possible_moves).to include("b4", "c1")
    end
    
    it "doesn't return horizontal or vertical squares" do
      expect(test_bishop.possible_moves).not_to include("d3", "a2")
    end    
  end
end