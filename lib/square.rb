class Square
  
  def initialize(col, row)
    @column = col
    @row = row
    @contents = nil
  end
  
  def contents
    @contents
  end
  
  def set_contents(contents)
    @contents = contents
  end
  
  def coords
    "#{@column}#{@row}"
  end
  
end