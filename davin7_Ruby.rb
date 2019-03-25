=begin
DISCLAIMER: All knowledge of the Ruby language was gained though a youtube
tutorial made by Derek Banas. The video can be found at the link below.
https://www.youtube.com/watch?v=Dji9ALCgfpM
=end

=begin
IN:
OUT: wordArray(array)
This method reads each line of the file named "mastermindWordList.txt".
For each line it will parse the line into a function that checks if the
word is valid. If the method returns back true, the word has all whitespace
removed, is shifted to lowercase and added to an array named "wordArray".
Once all lines of the file have been read, this array is returned.
=end
def ReadFromFile()
    puts Dir.pwd
    wordArray = Array.new
    File.open("words.txt", "r") do |file| # Uncomment this to have a larger list (466000+ words)
    # Note: Only use if in original repository that contains words.txt
    # File.open("mastermindWordList.txt", "r") do |file| # Comment this if previous line is uncommented
        file.each_line do |word|
            if CheckValidWord(word) == true
                wordArray.push(word.chomp.downcase)
            end
        end
    end
    return wordArray
end

=begin
IN: start(boolean)
OUT: 
This method prints the opening screen for the game. If it is the first
time showing this, it will use a different format so it doesn't look out
of place.
=end
def StartScreen(start)
    puts '    __  ______   _____________________  __  ________   ______ '.center(CONSOLE_WIDTH)
    puts '   /  |/  /   | / ___/_  __/ ____/ __ \/  |/  /  _/ | / / __ \ '.center(CONSOLE_WIDTH)
    puts '  / /|_/ / /| | \__ \ / / / __/ / /_/ / /|_/ // //  |/ / / / /'.center(CONSOLE_WIDTH)
    puts ' / /  / / ___ |___/ // / / /___/ _, _/ /  / // // /|  / /_/ / '.center(CONSOLE_WIDTH)
    puts '/_/  /_/_/  |_/____//_/ /_____/_/ |_/_/  /_/___/_/ |_/_____/  '.center(CONSOLE_WIDTH)
    if start
        puts "├─────────────────────────────┤".center(CONSOLE_WIDTH)
        puts "│        ENTER to start       │".center(CONSOLE_WIDTH)
        puts "└─────────────────────────────┘".center(CONSOLE_WIDTH)
        print "".center(CONSOLE_WIDTH / 2)
        STDIN.getc
        system "clear" or system "cls" # Clears the terminal screen so it doesn't look cluttered
    else
        puts "├─────┬─────┬─────┬─────┬─────┤".center(CONSOLE_WIDTH)
    end
end

=begin
IN: 
OUT: 
This method displays the rules of the game in a legable format and waits
for the user to press a key before moving on. This allows the user ample
time to read the rules and move on at their own pace.
=end
def Rules()
    puts "┌─────────────────────────────┐".center(CONSOLE_WIDTH)
    puts "│            Rules            │".center(CONSOLE_WIDTH)
    puts "└─────────────────────────────┘".center(CONSOLE_WIDTH)
    puts ""
    puts "A random five letter word has been chosen for you to decipher. This word can only".center(CONSOLE_WIDTH)
    puts "contain one occurence of any letter e.g alice is ok where allan is not. Each turn you will".center(CONSOLE_WIDTH)
    puts "guess five letters.".center(CONSOLE_WIDTH)
    puts ""
    puts "You will be told each letter was a:".center(CONSOLE_WIDTH)
    puts "Hit  (right letter, right place)".center(CONSOLE_WIDTH)
    puts "Near (right letter, wrong place)".center(CONSOLE_WIDTH)
    puts "Miss (wrong letter, wrong place)".center(CONSOLE_WIDTH)
    puts ""
    puts "The game ends when you have run out of guesses or you uncover and correctly guess the word".center(CONSOLE_WIDTH)
    puts "Good luck".center(CONSOLE_WIDTH)
    puts "ENTER to continue".center(CONSOLE_WIDTH)
    print "".center(CONSOLE_WIDTH / 2)
    STDIN.getc
    system "clear" or system "cls" # Clears the terminal screen so it doesn't look cluttered
end

=begin
IN: wordArray(array)
OUT: wordArray[index](string)
This method generates a random number between 0 and the size of the
parsed in array "wordArray". The method returns the value stored in the
array at the randomly generated index.
=end
def GetRandomWord(wordArray)
    index = rand(wordArray.size)
    return wordArray[index]
end

=begin
IN: word(string)
OUT: valid(boolean)
This method has a string parsed in as "word". This word has all
whitespace removed, is made to be lowercase and is checked in multiple
ways.
1: The size of the word is checked to be equal to 5, if not the word is
invalid
2: The word has each letter counted, if any occur multiple times the word
is invalid
3: All letters are checked if they are included in a string that contains
the alphabet, if any aren't included the word is invalid
This method returns the value of "valid"
=end
def CheckValidWord(word)
    letters = "abcdefghijklmnopqrstuvwxyz" # String that contains all of the letters of the alphabet, used to check for invalid words
    valid = true
    word = word.chomp.downcase
    if (word.split(//).size != 5) # If the size of the word is not 5 (this game only accepts 5 letter words) the words doesn't pass this check
        valid = false
    end
    word.split(//).each do |letter| # The word is split into letters and each letter is checked for validity
        if (word.count(letter.to_s)) > 1 # If the letter occurs more than once in the word, it doesn't pass this check
            valid = false
        end
        if (letters.include?(letter) == false) # If the letter isn't in "letters" is doesn't pass this check
            valid = false
        end
    end
    return valid # Returns the value of valid. Note: if a word/letter fails even one check, this value will be false
end

=begin
IN: codeWord(string), guess(string)
OUT: array(array)
This method is parsed in two strings, the randomly chosen "codeWord" and
the users "guess". Each letter is checked in three ways.
1: If the guess letter in spot i is the same as the codeWord letter in
spot i, the string " Hit" is added to an array in spot i
2: If the codeWord contains the guess letter in spot i that isn't in
codeWord spot i, the string "Near" is added to an array in spot i
3: If there is no match from the above two conditions, the string "Miss"
is added to an array in spot i
The method then returns this array
=end
def CompareWords(codeWord, guess, contains, hit, used)
    array = Array.new
    letters = "abcdefghijklmnopqrstuvwxyz"
        (0..4).each do |i| # Iterates through 5 times, once for each letter of the words
            if (guess[i] == codeWord[i]) # Checks if the string in guess 
                array[i] = " Hit"
                hit[i] = guess[i]
                if(contains.include?(guess[i]) == false)
                    contains[' '] = guess[i]
                end
                if(used.include?(guess[i]) == false)
                    index = letters.index(guess[i])
                    used[index] = guess[i]
                end
            elsif (codeWord.include?(guess[i])) # Checks if "codeWord" includes the letter
                array[i] = "Near"
                if(contains.include?(guess[i]) == false)
                    contains[' '] = guess[i]
                end
                if(used.include?(guess[i]) == false)
                    index = letters.index(guess[i])
                    used[index] = guess[i]
                end
            else
                array[i] = "Miss"
                if(used.include?(guess[i]) == false)
                    index = letters.index(guess[i])
                    used[index] = guess[i]
                end
            end
        end
    return array, contains, hit, used # Returns an array contains 5 values of " Hit", "Near", "Miss" or any combination of the three
end

=begin
IN: 
OUT: (integer)
This method changes the amount of guesses the user gets based off of how
difficult they want it to be. Easy gives 20 guesses, Medium 15 and Hard 10.
This method then returns this number.
Note: If no or an invalid value is entered, the default difficulty will be Medium
=end
def DifficultySelect()
    puts "┌─────────────────────────────┐".center(CONSOLE_WIDTH)
    puts "│      Select Difficulty      │".center(CONSOLE_WIDTH)
    puts "├─────────────────────────────┤".center(CONSOLE_WIDTH)
    puts "│   (1) Easy  -  20 guesses   │".center(CONSOLE_WIDTH)
    puts "│   (2) Medium - 15 guesses   │".center(CONSOLE_WIDTH)
    puts "│   (3) Hard  -  10 guesses   │".center(CONSOLE_WIDTH)
    puts "│   (4) Extreme - 5 guesses   │".center(CONSOLE_WIDTH)
    puts "│   (5) Bullseye- 1 guess     │".center(CONSOLE_WIDTH)
    puts "└─────────────────────────────┘".center(CONSOLE_WIDTH)
    print "Enter your choice: ".rjust(64)
    difficulty = gets.chomp.to_s
    if difficulty == "1"
        return 20
    elsif difficulty == "3"
        return 10
    elsif difficulty == "4"
        return 5
    elsif difficulty == "5"
        return 1
    else
        return 15
    end
end

def PlayAgain()
    print "Again? (Y/N): ".rjust(64)
    input = gets.to_s.chomp.downcase
    if input != "y"
        return false
    else
        return true
    end
end

=begin
IN: guess(string), array(array), guesses(integer), contains(string), hit(string)
OUT:
This method outputs the final information to the player. Currently has be done this messy way
as I cannot find a way to update line 272 with information seperately
=end
def FeedbackDisplay(guess, array, guesses, contains, hit, used)
    system "clear" or system "cls" # Clears the terminal screen so it doesn't look cluttered
                StartScreen(false)
                puts "│  #{guess[0]}  │  #{guess[1]}  │  #{guess[2]}  │  #{guess[3]}  │  #{guess[4]}  │".center(CONSOLE_WIDTH)
                puts "│#{array[0]} │#{array[1]} │#{array[2]} │#{array[3]} │#{array[4]} │".center(CONSOLE_WIDTH)
                puts "├─────┴─────┴─────┴─────┴─────┤".center(CONSOLE_WIDTH)
                if guesses > 9
                    puts "│       Guesses left: #{guesses}      │".center(CONSOLE_WIDTH)
                else
                    puts "│       Guesses left: #{guesses}       │".center(CONSOLE_WIDTH)
                end
                puts "├─────────────────────────────┤".center(CONSOLE_WIDTH)
                puts "│     Word contains: #{contains}    │".center(CONSOLE_WIDTH)
                puts "├─────────────────────────────┤".center(CONSOLE_WIDTH)
                puts "│          Word: #{hit[0]}#{hit[1]}#{hit[2]}#{hit[3]}#{hit[4]}        │".center(CONSOLE_WIDTH)
                puts "├─────────────────────────────┤".center(CONSOLE_WIDTH)
                puts "│        Letters used:        │".center(CONSOLE_WIDTH)
                puts "│  #{used} │".center(CONSOLE_WIDTH)
                puts "└─────────────────────────────┘".center(CONSOLE_WIDTH)
end

=begin
IN: wordArray(array)
OUT: 
This method is the core of the game. An array is parsed as "wordArray".
While the player wishes to play, a random word is retrieved from wordArray.
This becomes the codeWord. The player is then prompted for what difficulty
they want, with the amount of guesses changing based on this. Then, whilst
the user hasn't entered a correct guess, the game plays. During this time
the start screen is displayed along with a formatted table containing the
information the user has entered (if any) and the feedback the game
generates for the user. After each guess is made, it is checked to be valid
(check "CheckValidWord" function description for what this does) and if it's
valid it will compare it to the codeWord and provide feedback on whether
each letter is a "Hit", "Near" or "Miss". If the word is invalid it will
display this too. The number of guesses remaining is also displayed within
the feedback table. If at any point the player has all the letters as " Hit"
the game will proclaim that they have won and prompt them to play again or
exit. If at any point the players number of guesses becomes "0", the game
will end saying they have lost and prompt them to play again or exit.
=end
def MainGame(wordArray)
        puts "┌─────────────────────────────┐".center(CONSOLE_WIDTH)
    puts "│            Rules            │".center(CONSOLE_WIDTH)
    puts "└─────────────────────────────┘".center(CONSOLE_WIDTH)
    puts ""
    puts "A random five letter word has been chosen for you to decipher. This word can only".center(CONSOLE_WIDTH)
    puts "contain one occurence of any letter e.g alice is ok where allan is not. Each turn you will".center(CONSOLE_WIDTH)
    puts "guess five letters.".center(CONSOLE_WIDTH)
    puts ""
    puts "You will be told each letter was a:".center(CONSOLE_WIDTH)
    puts "Hit  (right letter, right place)".center(CONSOLE_WIDTH)
    puts "Near (right letter, wrong place)".center(CONSOLE_WIDTH)
    puts "Miss (wrong letter, wrong place)".center(CONSOLE_WIDTH)
    puts ""
    puts "The game ends when you have run out of guesses or you uncover and correctly guess the word".center(CONSOLE_WIDTH)
    puts "Good luck".center(CONSOLE_WIDTH)
    puts "ENTER to continue".center(CONSOLE_WIDTH)
    print "".center(CONSOLE_WIDTH / 2)
    STDIN.getc
    system "clear" or system "cls" # Clears the terminal screen so it doesn't look cluttered
    again = true
    while again == true
        system "clear" or system "cls" # Clears the terminal screen so it doesn't look cluttered
        codeWord = GetRandomWord(wordArray)
        correct = false
        guesses = DifficultySelect()
        array = Array.new(5, "    ") # Creates and fills array with 5 "     "'s'
        guess = "     "
        contains = "     "
        used = "                          "
        hit = Array.new(5, "_")
        while ((correct == false) && (guesses > 0) && (again == true))
            valid = false
            while valid == false
                FeedbackDisplay(guess, array, guesses, contains, hit, used)
                print "Enter your guess: ".rjust(64)
                guess = gets.to_s.chomp.downcase
                valid = CheckValidWord(guess)
                if (valid == false)
                    puts "Invalid word, please try again".center(CONSOLE_WIDTH)
                    guess = "     "
                    sleep(1)
                end
            end
            array, contains, hit, used = CompareWords(codeWord, guess, contains, hit, used)
            guesses -= 1
            if (array.count(" Hit") == 5)
                Fireworks(0.10)
                correct = true
                FeedbackDisplay(guess, array, guesses, contains, hit, used)
                puts "YOU WON".center(CONSOLE_WIDTH)
                again = PlayAgain()
            elsif (guesses == 0)
                FeedbackDisplay(guess, array, guesses, contains, hit, used)
                puts "YOU LOST".center(CONSOLE_WIDTH)
                puts "The word was #{codeWord}".center(CONSOLE_WIDTH)
                again = PlayAgain()
            end
        end
    end
end
=begin
IN: lines(int)
OUT:
This method is parsed lines and then displays that amount of blank lines
=end
def Blank(lines)
    (0..lines).each do |i|
        puts ''
    end
end

# Ignore all of the below :) 
def Fireworks(time)
    #Frame 1
    Blank(27)
    puts ' /                   /'
        puts '*                    |      /'
        sleep(time)
        system "clear" or system "cls"
        #Frame 2
        Blank(25)
        puts '                               /'
        puts '  /                           / '
        puts ' *                   |       *'
        puts '*                    *      *'
        sleep(time)
        system "clear" or system "cls"
        #Frame 3
        Blank(23)
        puts '                                 /'
        puts '    /                           /'
        puts '   *                           *'
        puts '  *                  |        *'
        puts ' *                   *       *'
        puts '*                    *      *'
        sleep(time)
        system "clear" or system "cls"
        #Frame 3
        Blank(21)
        puts '                                   /'
        puts '      /                           /'
        puts '     *                           *'
        puts '    *                           *'
        puts '   *                 |         *'
        puts '  *                  *        *'
        puts ' *                   *       *'
        puts '*                    *      *'
        sleep(time)
        system "clear" or system "cls"
        #Frame 4
        Blank(18)
        puts '                                      X'
        puts '                                      '
        puts '        /                            '
        puts '       *                           *'
        puts '      *                           *'
        puts '     *                           *'
        puts '    *                |          *'
        puts '   *                 *         *'
        puts '  *                  *        *'
        puts ' *                   *       *'
        puts '*                    *      *'
        sleep(time)
        system "clear" or system "cls"
        #Frame 5
        Blank(16)
        puts '            0'
        puts '                                     \ /'
        puts '                                    — X —'
        puts '         *                           / \ '
        puts '        *                            '
        puts '       *                           *'
        puts '      *                           *'
        puts '     *               |           *'
        puts '    *                *          *'
        puts '                     *'
        puts '                     *'
        puts '                     *'
        puts '                     *'
        sleep(time)
        system "clear" or system "cls"
        #Frame 6
        Blank(14)
        puts '           \ /'
        puts '          — 0 —                     *****'
        puts '           / \                     * \ / *'
        puts '                                  * — X — *'
        puts '         *                         * / \ *'
        puts '        *            0              *****'
        puts '       *                           *'
        puts '      *                           *'
        puts '     *               *           *'
        puts '                     *'
        puts '                     *'
        puts '                     *'
        puts '                     *'
        sleep(time)
        system "clear" or system "cls"
        #Frame 7
        Blank(13)
        puts '          *   *'
        puts '           \ /'
        puts '        * — 0 — *                    '
        puts '           / \                       \ / '
        puts '          *   *                     — X — '
        puts '         *          \ /              / \ '
        puts '        *          — 0 —            '
        puts '       *            / \            *'
        puts '                                  *'
        puts '                     *'
        puts '                     *'
        puts '                     *'
        puts '                     *'
        sleep(time)
        system "clear" or system "cls"
        #Frame 8
        Blank(14)
        puts '           \ / '
        puts '          — 0 —'
        puts '           / \ '
        puts '                   :::::              X'
        puts '         *       :: \ / ::'
        puts '        *       :: — 0 — ::'
        puts '                 :: / \ ::         *'
        puts '                   :::::'
        puts '                     *'
        puts '                     *'
        puts '                     *'
        sleep(time)
        system "clear" or system "cls"
        #Frame 9
        Blank(15)
        puts '            0'
        puts ''
        puts ''
        puts '         *          \ / '
        puts '                   — 0 —'
        puts '                    / \ '
        puts ''
        puts '                     *'
        puts '                     *'
        sleep(time)
        system "clear" or system "cls"
        #Frame 9
        Blank(19)
        puts '                     0'
        puts ''
        puts ''
        puts '                     *'
        sleep(time)
        system "clear" or system "cls"
        #Frame 10
        sleep(time)
end

CONSOLE_WIDTH = 119
wordArray = ReadFromFile()
StartScreen(true)
MainGame(wordArray)