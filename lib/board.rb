class Board
  attr_accessor :positions

  def initialize
    @positions = Array.new(8) { Array.new(8, nil) }
    place_pieces
  end

  def place_pieces
    place_white_row
    place_black_row
    place_pawns
  end

  def place_white_row
    @positions[7][0] = Rook.new([7, 0], true)
    @positions[7][1] = Knight.new([7, 1], true)
    @positions[7][2] = Bishop.new([7, 2], true)
    @positions[7][3] = Queen.new([7, 3], true)
    @positions[7][4] = King.new([7, 4], true)
    @positions[7][5] = Bishop.new([7, 5], true)
    @positions[7][6] = Knight.new([7, 6], true)
    @positions[7][7] = Rook.new([7, 7], true)
  end

  def place_black_row
    @positions[0][0] = Rook.new([0, 0], false)
    @positions[0][1] = Knight.new([0, 1], false)
    @positions[0][2] = Bishop.new([0, 2], false)
    @positions[0][3] = Queen.new([0, 3], false)
    @positions[0][4] = King.new([0, 4], false)
    @positions[0][5] = Bishop.new([0, 5], false)
    @positions[0][6] = Knight.new([0, 6], false)
    @positions[0][7] = Rook.new([0, 7], false)
  end

  def place_pawns
    place_white_pawns
    place_black_pawns
  end

  def place_white_pawns
    (0..7).each do |x|
      @positions[6][x] = Pawn.new([6, x], true)
    end
  end

  def place_black_pawns
    (0..7).each do |x|
      @positions[1][x] = Pawn.new([1, x], false)
    end
  end

  def display
    display_top_border
    display_rows
    display_bottom_border
    display_x_axis
  end

  def display_top_border
    puts '   ┌────┬────┬────┬────┬────┬────┬────┬────┐'
  end

  def display_rows
    (1..7).each do |row|
      display_row(row)
      display_separator
    end
    display_row(8)
  end

  def display_row(number)
    print "#{9 - number}  "
    @positions[number - 1].each do |position|
      if position.nil?
        print '│    '
      else
        print "│ #{position.icon}  "
      end
    end
    puts '│'
  end

  def display_separator
    puts '   ├────┼────┼────┼────┼────┼────┼────┼────┤'
  end

  def display_bottom_border
    puts '   └────┴────┴────┴────┴────┴────┴────┴────┘'
  end

  def display_x_axis
    puts "     A    B    C    D    E    F    G    H  \n\n"
  end

  def self.clone(positions)
    cache = Marshal.load(Marshal.dump(positions))
  end

  def self.includes?(x, y)
    within_seven?(x) && within_seven?(y)
  end

  def self.within_seven?(number)
    (0..7).include?(number)
  end
end