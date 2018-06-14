require "spec_helper"

describe Knight do
  
  let(:test_board){Board.new("test", "board")}
  let(:test_knight){Knight.new("white")}
  
  describe "#possible_moves" do
    
    before do
      test_board.set_piece("e3", test_knight)
    end
    
    it "returns squares in an L shape" do
      expect(test_knight.possible_moves).to include("d1", "c2", "d5", "g4")
    end
    
    it "doesn't return adjacent squares" do
      expect(test_knight.possible_moves).not_to include("d3", "e4")
    end
  end
end