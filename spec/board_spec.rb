require "spec_helper"

describe Board do
  
  let(:test_board){Board.new("test", "board")}
  
  let(:test_white_king){King.new("white")}
  let(:test_white_bishop){Bishop.new("white")}
  let(:test_white_rook){Rook.new("white")}
  let(:test_white_pawn){Pawn.new("white")}
  
  let(:test_black_king){King.new("black")}
  let(:test_black_bishop){Bishop.new("black")}
  let(:test_black_rook){Rook.new("black")}
  let(:test_black_pawn){Pawn.new("black")}
  let(:test_black_queen){Queen.new("black")}
  
  describe "#checkmate?" do
    
    before do
      test_board.set_piece("b1", test_white_king)
      
      test_board.set_piece("g7", test_black_king)
      test_board.set_piece("d3", test_black_bishop)
      test_board.set_piece("a4", test_black_rook)
      test_board.set_piece("d2", test_black_pawn)
      test_board.set_piece("c2", test_black_queen)
    end
    
    context "when king is in check and no moves are possible" do
      it "returns true" do
        expect(test_board.checkmate?).to be true
      end
    end
  end
  
  describe "#stalemate?" do
    
    before do
      test_board.set_piece("h8", test_white_king)
      
      test_board.set_piece("f7", test_black_king)
      test_board.set_piece("g6", test_black_queen)
    end
    
    context "when king isn't in check but can't move" do
      it "returns true" do
        expect(test_board.stalemate?).to be true
      end
    end
  end
  
  describe "#king_in_check?" do
    
    before do
      test_board.set_piece("e6", test_white_king)
      
      test_board.set_piece("h8", test_black_king)
      test_board.set_piece("a2", test_black_bishop)
      test_board.set_piece("f1", test_black_rook)
    end
    
    context "if a king is threatened" do
      it "returns true" do
        expect(test_board.king_in_check?).to be true
      end
    end
    
    context "if a king is safe" do
      it "returns false" do
        test_board.change_squares(test_white_king, "e6", "d6")
        expect(test_board.king_in_check?).to be false
      end
    end
  end
  
  describe "#move" do
    
    before do
      test_board.new_board
    end
    
    context "if a square is entered without a piece on it" do
      it "displays a 'no piece on that square' error message" do
        test_board.move("b4", "b5")
        expect(test_board.error_message).to eq("there's no piece on that square!")
      end
    end
    
    context "if a player attempts to move the wrong color piece" do
      it "displays a 'wrong color' error message" do
        test_board.move("b7", "b6")
        expect(test_board.error_message).to eq("wrong color! it's not your turn!")
      end
    end
    
    context "if a player tries to make a move that a piece can't make" do
      it "displays a 'not a legal move' error message" do
        test_board.move("b2", "b6")
        expect(test_board.error_message).to eq("not a legal move!")
      end
    end
    
    context "if a player tries to attack a friendly color" do
      it "displays a 'no friendly fire' error message" do
        test_board.move("g1", "e2")
        expect(test_board.error_message).to eq("no friendly fire!")
      end
    end
    
    context "if a player tries to move a piece that's blocked" do
      it "displays a 'you're blocked' error message" do
        test_board.move("a1", "a3")
        expect(test_board.error_message).to eq("you're blocked by another piece!")
      end
    end
    
    context "if a player moves a pawn forward" do
      it "makes the proper move forward" do
        test_board.set_piece("e2", test_white_pawn)
        test_board.move("e2", "e3")
        expect(test_white_pawn.get_current_square).to eq("e3")
      end
    end
    
    context "if a pawn moves forward two squares" do
      it "makes an en passant move available" do
        test_board.set_piece("e2", test_white_pawn)
        test_board.move("e2", "e4")
        expect(test_board.en_passant).to eq(["e3", "white"])
      end
    end
    
    context "if a pawn tries to move diagonally improperly" do
      it "displays a 'can only attack diagonally' error message" do
        test_board.move("e2", "f3")
        expect(test_board.error_message).to eq("pawns can only attack diagonally!")
      end
    end
    
    context "if a pawn is eligible for promotion" do
      it "promotes a pawn that moves into the last rank" do
        another_test_board = Board.new("test", "board")
        another_test_board.set_piece("e7", test_white_pawn)
        another_test_board.move("e7", "e8")
        expect(another_test_board.access("e8").contents).to be_a_kind_of(Queen)
      end
    end
    
    context "if a pawn attempts to capture diagonally" do
      it "captures properly" do
        test_board.set_piece("e4", test_white_pawn)
        test_board.set_piece("d5", test_black_pawn)
        test_board.move("e4", "d5")
        expect(test_board.access("d5").contents).to eq(test_white_pawn)
      end
    end
    
    context "if a non-pawn piece endangers its own king" do
      it "reverts the move and returns the board to its previous state" do
        test_board.set_piece("g3", test_black_bishop)
        test_board.move("f2", "f3")
        expect(test_board.access("f3").contents).to be nil
      end
    end
    
    context "if a non-pawn piece moves and isn't blocked" do
      it "moves the piece properly" do
        test_board.set_piece("a3", test_white_bishop)
        test_board.move("a3", "d6")
        expect(test_board.access("d6").contents).to eq(test_white_bishop)
      end
    end
  end
  
  describe "#castle" do
    
    before do
      test_board.set_piece("e1", test_white_king)
      test_board.set_piece("a1", test_white_rook)
    end
    
    context "if a castle is possible" do
      it "castles properly" do
        test_board.castle("white", "left")
        expect(test_board.access("c1").contents).to be_a_kind_of(King)
      end
    end
    
    context "if a rook moves from its starting square" do
      it "castling isn't possible" do
        test_board.change_squares(test_white_rook, "e1", "e4")
        test_board.change_squares(test_white_rook, "e4", "e1")
        test_board.castle("white", "left")
        expect(test_board.error_message).to eq("you can't castle that way!")
      end
    end
    
    context "if a piece is in the way" do
      it "castling isn't possible" do
        test_board.set_piece("c1", test_white_bishop)
        test_board.castle("white", "left")
        expect(test_board.error_message).to eq("you can't castle that way!")
      end
    end
  end
  
end