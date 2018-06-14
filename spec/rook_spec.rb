require "spec_helper"

describe Rook do
  
  let(:test_board){Board.new("test", "board")}
  let(:test_rook){Rook.new("white")}
  
  describe "#possible_moves" do
    
    before do
      test_board.set_piece("b6", test_rook)
    end
    
    it "returns horizontal squares" do
      expect(test_rook.possible_moves).to include("a6", "g6")
    end
    
    it "returns vertical squares" do
      expect(test_rook.possible_moves).to include("b2", "b8")
    end
    
    it "doesn't return diagonal squares" do
      expect(test_rook.possible_moves).not_to include("d8", "e3")
    end    
  end
end