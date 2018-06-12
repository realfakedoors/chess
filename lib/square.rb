class Square
  
  attr_accessor :contents, :column, :row
  
  def initialize(col, row)
    @column = col
    @row = row
    @contents = nil
  end
  
  public
  
  def set_contents(contents)
    @contents = contents
  end
  
  def coords
    "#{@column}#{@row}"
  end
  
end