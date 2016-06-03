require 'captains_mistress'

module CaptainsMistress
  # The application object. Create it with options for the game, then run by
  # calling #run.
  class App
    attr_reader :verbose

    def initialize(options = {})
      @verbose = options.fetch(:verbose, false)

      @rows = options.fetch(:height, 6)
      @cols = options.fetch(:width, 7)

      @winLength = options.fetch(:length, 4)

      @grid = Array.new(@rows * @cols, 0)
    end

    def render
      # takes the game grid and renders out a graphical grid
      i = 0;

      while i < @rows do
        puts @grid.slice(@cols*i, @cols).join(" ")
        i += 1
      end
    end

    def updateGrid(column, player)
      # takes a selected column, attempts to add piece to array and re-renders
      if player > 0
        player = "@"
      else
        player = "*"
      end


      bottom_index = column - 1 + @cols * (@rows - 1)

      searching = true

      while searching && bottom_index >= 0 do

        if @grid[bottom_index] == 0
          @grid[bottom_index] = player
          searching = false
        else

          bottom_index -= @cols
        end


      end

      render()
      return bottom_index

    end

    def consecutiveLengthCalc(index, player, posIncrement, rowInc, colInc)
      # Returns number of consecutive pieces in a given direction

      pos = index
      length = 0
      searching = true
      inbounds = true
      rowNum = pos/@cols
      colNum = pos - rowNum * @cols


      while searching and inbounds do

        if @grid[pos] == player 
          length += 1
        else
          searching = !searching
        end

        # pos < @cols * @rows

        pos += posIncrement
        rowNum += rowInc
        colNum += colInc
        if yield pos, rowNum, colNum
          inbounds = !inbounds
        end


      end

      return length

    end

    def checkWin(index, player) 

      #Checks along each direction of a given index of the grid to see if atleast 4 pieces
      # are connected

      if player > 0
        player = "@"
      else
        player = "*"
      end

      # Vertical Check
      if consecutiveLengthCalc(index, player, @cols, 0, 0) {|pos, rowNum| pos > @cols * @rows - 1} >= @winLength
        return true
      end

      # Horizontal Check
      #Left
      leftLength = consecutiveLengthCalc(index, player, -1, 0, 0) {|pos, rowNum| pos < rowNum * @cols}
      #Right
      rightLength = consecutiveLengthCalc(index, player, 1, 0, 0) {|pos, rowNum| pos < rowNum * @cols}


      if leftLength + rightLength - 1 >= @winLength
        return true
      end

      # UL to LR Check
      # Left
      leftDiagLength = consecutiveLengthCalc(index, player, -(@cols + 1), -1, -1) {|pos, rowNum, colNum| rowNum < 0 or colNum < 0}
      # Right
      rightDiagLength = consecutiveLengthCalc(index, player, @cols + 1, 1, 1) {|pos, rowNum, colNum| rowNum > @rows - 1 or colNum > @cols - 1}

      if leftDiagLength + rightDiagLength - 1 >= @winLength
        return true
      end

      # UR to LL Check
      # Left
      leftDiagLength = consecutiveLengthCalc(index, player, @cols - 1, 1, -1) {|pos, rowNum, colNum| rowNum > @rows - 1 or colNum < 0}
      # Right
      rightDiagLength = consecutiveLengthCalc(index, player, -(@cols - 1), -1, 1) {|pos, rowNum, colNum| rowNum < 0 or colNum > @cols - 1}

      if leftDiagLength + rightDiagLength - 1 >= @winLength
        return true
      end

    end

    def run
      # You should implement this method.
      # raise 'Not implemented'

      #@grid[0] = '@'

      render()

      running = true

      player = 1


      while running do
        
        puts "Player #{player} select column (1 - #{@cols})"
        input = $stdin.gets.chomp

        if input == "exit" or input == "q"
          return
        end

        intInput = Integer(input) rescue false || -1

        if intInput > 0 and intInput <= @cols

          index = updateGrid(intInput,player)
          if index < 0

            puts "Invalid move: The Column is Full"

          else
            if checkWin(index, player)
              puts "Player #{player} wins!"
              running = !running
            end
            player *= -1
          end

          
        else
          puts "Invalid input, Please Integer from 1 to #{@cols}"
        end

      end

    end
  end

end
