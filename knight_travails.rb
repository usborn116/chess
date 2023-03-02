class Piece
  attr_accessor :position, :moves, :children, :parent

  MOVES = [[1,2], [2,1], [2,-1], [1,-2], [-1,-2], [-2,-1], [-2,1], [-1,2]].freeze

  def initialize(position, parent = nil)
    @position = position
    @moves = possible_moves(@position)
    @children = []
    @parent = parent
  end

  private

  def possible_moves(position)
    next_moves = MOVES.map do |move|
      move.each_with_index.map { |n, i| n + @position[i] unless (n + @position[i]).negative? || (n + @position[i]) > 8 }
    end
    next_moves.delete_if { |move| move.include?(nil) }
    next_moves
  end

end

class Board

  def knight_moves(start, end_pos)
    current = make_tree(start, end_pos)
    history = []
    make_history(current, history, start)
    print_knight_moves(history, start, end_pos)
  end

  private
  
  def piecemaker(pos, parent = nil)
    Piece.new(pos, parent)
  end

  def make_tree(start, end_pos)
    queue = [piecemaker(start)]
    current = queue.shift
    until current.position == end_pos
      current.moves.each do |move|
        current.children << knight = piecemaker(move, current)
        queue << knight
      end
      current = queue.shift
    end
    current
  end

  def make_history(current, history, start)
    until current.position == start
      history << current.position
      current = current.parent
    end
    history << current.position
  end

  def print_knight_moves(history, start, destination)
    puts "You made it in #{history.size - 1} moves!"
    puts "To get from #{start} to #{destination} you must traverse the following path:"
    history.reverse.each { |move| puts move.to_s }
  end
end

Board.new.knight_moves([0, 0], [7, 8])