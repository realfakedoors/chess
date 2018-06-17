require "spec_helper"

describe Pawn do
  
  let(:test_board){Board.new("test", "board")}
  let(:test_white_pawn){Pawn.new("white")}
  let(:test_black_pawn){Pawn.new("black")}
  
  describe "#possible_moves" do
    
    before do
      test_board.set_piece("b2", test_white_pawn)
      test_board.set_piece("h6", test_black_pawn)
    end
    
    it "returns squares directly ahead of each pawn" do
      expect(test_white_pawn.possible_moves).to include("b3")
      expect(test_black_pawn.possible_moves).to include("h5")
    end
    
    context "if a pawn is in its starting row" do
      it "returns two squares ahead" do
        expect(test_white_pawn.possible_moves).to include("b4")
        expect(test_black_pawn.possible_moves).not_to include("h4")
      end
    end
    
    it "returns diagonal forward squares" do
      expect(test_white_pawn.possible_moves).to include("a3", "c3")
      expect(test_black_pawn.possible_moves).to include("g5")
    end
    
    it "doesn't return behind or horizontal squares" do
      expect(test_white_pawn.possible_moves).not_to include("b1", "c2")
      expect(test_black_pawn.possible_moves).not_to include("h7", "g6")
    end
  end
end