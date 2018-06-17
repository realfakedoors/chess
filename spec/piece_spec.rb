require "spec_helper"

describe Piece do
  
  let(:test_board){Board.new("test", "board")}
  let(:test_rook){Rook.new("white")}
  let(:test_knight){Knight.new("white")}
  
  describe "#mark_as_moved" do
    
    before do
      test_board.set_piece("h1", test_rook)
    end
    
    context "when a piece is still on its starting square" do
      it "returns nil when a piece hasn't moved" do
        expect(test_rook.moved).to be_nil
      end
    end
    
    context "when a piece is moved from its starting square" do
      it "properly marks a piece as moved" do
        test_board.move("h1", "h5")
        expect(test_rook.moved).to be true
      end
    end
  end
  
  describe "#get_current_square" do
    
    before do
      test_board.set_piece("a2", test_knight)
    end
    
    it "returns the square that it was set on" do
      expect(test_knight.get_current_square).to eql("a2")
    end
    
    context "after a piece is moved" do
      it "updates the piece's current square" do
        test_board.move("a2", "c1")
        expect(test_knight.get_current_square).to eql("c1")
      end
    end
  end
end