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

      @grid = Array.new(42, 0)
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

    def checkWin(index, player) 

      #Checks along each direction of a given index of the grid to see if atleast 4 pieces
      # are connected

      if player > 0
        player = "@"
      else
        player = "*"
      end

      # Check Vertical
      pos = index
      length = 0
      searching = true
      inbounds = true
      while searching and inbounds do

        if @grid[pos] == player 
          length += 1
        else
          searching = !searching
        end

        pos < @cols * @rows

        pos += @cols
        if pos > @cols * @rows - 1
          inbounds = !inbounds
        end


      end

      if length >= @winLength
        return true
      end

      # Horizontal
      #   Left
      pos = index
      leftLength = 0
      searching = true
      inbounds = true

      rowNum = pos/@cols

      while searching and inbounds do
        # puts "#{@grid[pos]}, #{player}, #{rowNum}, #{pos}"
        if @grid[pos] == player
          leftLength += 1
        else
          searching = !searching
        end

        pos -= 1
        if pos < rowNum * @cols
          inbounds = !inbounds
        end

      end
      # puts "Checking Left #{leftLength}"

      #   Right
      pos = index
      rightLength = 0
      searching = true
      inbounds = true

      while searching and inbounds do

        if @grid[pos] == player
          rightLength += 1
        else
          searching = !searching
        end

        pos += 1
        if pos >= rowNum * @cols + @cols
          inbounds = !inbounds
        end

      end

      # puts "Checking Right #{rightLength}"


      if leftLength + rightLength - 1 >= @winLength
        return true
      end

      # UL to LR Diag Check
      # Left
      pos = index
      leftDiagLength = 0
      searching = true
      inbounds = true
      rowNum = pos/@cols
      colNum = pos - rowNum * @cols

      while searching and inbounds do

        if @grid[pos] == player
          leftDiagLength += 1
        else
          searching = !searching
        end

        pos -= @cols + 1
        rowNum -= 1
        colNum -= 1
        if rowNum < 0 or colNum < 0
          inbounds = !inbounds
        end

      end

      # puts "Checking UpperLeft #{leftDiagLength}"

      # Right
      pos = index
      rightDiagLength = 0
      searching = true
      inbounds = true
      rowNum = pos/@cols
      colNum = pos - rowNum * @cols

      while searching and inbounds do

        if @grid[pos] == player
          rightDiagLength += 1
        else
          searching = !searching
        end

        pos += @cols + 1
        rowNum += 1
        colNum += 1
        if rowNum > @rows - 1 || colNum > @cols - 1 
          inbounds = !inbounds
        end

      end

      # puts "Checking LowerRight #{rightDiagLength}"

      if leftDiagLength + rightDiagLength - 1 >= @winLength
        return true
      end


      # LL to UR Diag Check
      # Left
      pos = index
      leftDiagLength = 0
      searching = true
      inbounds = true
      rowNum = pos/@cols
      colNum = pos - rowNum * @cols

      while searching and inbounds do

        if @grid[pos] == player
          leftDiagLength += 1
        else
          searching = !searching
        end

        pos += @cols - 1
        rowNum += 1
        colNum -= 1
        if rowNum > @rows - 1 || colNum < 0
          inbounds = !inbounds
        end

      end

      # puts "Checking LowerLeft #{leftDiagLength}"

      # Left
      pos = index
      rightDiagLength = 0
      searching = true
      inbounds = true
      rowNum = pos/@cols
      colNum = pos - rowNum * @cols

      while searching and inbounds do

        if @grid[pos] == player
          rightDiagLength += 1
        else
          searching = !searching
        end

        pos -= @cols - 1
        if rowNum < 0 || colNum > @cols - 1
          inbounds = !inbounds
        end

      end

      # puts "Checking UpperRight #{rightDiagLength}"

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
