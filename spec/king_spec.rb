require "spec_helper"

describe King do
  
  let(:test_board){Board.new("test", "board")}
  let(:test_king){King.new("white")}
  
  describe "#possible_moves" do
    
    before do
      test_board.set_piece("f7", test_king)
    end
    
    it "returns directly diagonal squares" do
      expect(test_king.possible_moves).to include("e8", "e6", "g8", "g6")
    end
    
    it "returns directly horizontal squares" do
      expect(test_king.possible_moves).to include("e7", "g7")
    end
    
    it "returns directly vertical squares" do
      expect(test_king.possible_moves).to include("f6", "f8")
    end
    
    it "doesn't return squares outside its one-space limits" do
      expect(test_king.possible_moves).not_to include("d5", "f3")
    end  
  end
end