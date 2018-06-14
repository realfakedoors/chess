require "spec_helper"

describe Queen do
  
  let(:test_board){Board.new("test", "board")}
  let(:test_queen){Queen.new("white")}
  
  describe "#possible_moves" do
    
    before do
      test_board.set_piece("c6", test_queen)
    end
    
    it "returns diagonal squares" do
      expect(test_queen.possible_moves).to include("e4", "d7", "a8", "b5")
    end
    
    it "returns horizontal squares" do
      expect(test_queen.possible_moves).to include("a6", "h6")
    end
    
    it "returns vertical squares" do
      expect(test_queen.possible_moves).to include("c1", "c8")
    end
    
    it "doesn't return squares outside its trajectory" do
      expect(test_queen.possible_moves).not_to include("e1", "g7")
    end  
  end
end