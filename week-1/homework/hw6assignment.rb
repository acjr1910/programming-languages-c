# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here

  # class array holding all the pieces and their rotations
    All_My_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
    rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
    [[[0, 0], [-1, 0], [1, 0], [2, 0]], [[0, 0], [0, -1], [0, 1], [0, 2]]], # long (only needs two)
    rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
    rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
    rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
    rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
    rotations([[0, 0], [1, 0], [0, 1], [1, 1], [2, 1]]), # new piece 1
    rotations([[0, 0], [1, 0], [2,0], [-1, 0], [-2, 0]]), # new piece 2
    rotations([[0, 0], [0, 1], [1,0], [0, 0]])] # new piece 3
  
    def self.next_piece (board)
      MyPiece.new(All_My_Pieces.sample, board)
    end

    def self.next_cheat_piece (board)
      MyPiece.new([[[0, 0]]], board)
    end
 end

class MyBoard < Board
  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @cheating = false
    @game = game
    @delay = 500
    @test = 1
  end
  
  def score= x
    @score = x
  end

  def is_cheating?
    @cheating
  end

  def cheating= x
    @cheating = x
  end

  def rotate_clockwise_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  # gets the next piece
  def next_piece
    if @cheating
      @current_block = MyPiece.next_cheat_piece(self)
      @cheating = false
    else
      @current_block = MyPiece.next_piece(self)
    end    
    @current_pos = nil
  end
  
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.size - 1)).each{|index|
      current = locations[index]
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] =
          @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end

class MyTetris < Tetris
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super  
    @root.bind('c', proc {self.cheat}) 
    @root.bind('u', proc {@board.rotate_clockwise_180})
  end

  def cheat
    if !@board.is_cheating? && @board.score >= 100
      @board.cheating = true
      @board.score = @board.score - 100
    end
  end
end


