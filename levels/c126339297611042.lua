-- The function get_name() should return a single string that is the name of the puzzle.
--
function get_name()
    return "TACAN TRN-26: A3 Repetition Rate Controller"
end

-- The function get_description() should return an array of strings, where each string is
-- a line of description for the puzzle. Surrounding text with asterisks will cause it to 
-- be rendered in bold, something we use when mentioning a signal by name.
--
-- By using the syntax that we use in our puzzle descriptions, you can also create tables:
--
--       "| This is a table. | This is a second column. | This is a column with "
--       "|                  |                          | multiple line of text."
--       "----------------------------------------------------------------------"
--       "| This is a second |                          | More text here!       "
--       "| table row.       |                          |                       "
--
-- Puzzle descriptions are not automatically paginated, so you can use the string "<PAGE>"
-- to start a new page of text. If you don't it will overflow and make Zach sad.
--
function get_description()
    return { 
        "TACAN TRN-26 Shenzhen IO Challenge",
        "Reference A3 Book Pg 8",
        "The A3 card ensures that we have a constant beacon output by adjusting the Auto Squitter Out (ASC) level increasing or decreasing the amount of noise produced by the Log IF amp depending on how many aircraft are interrogating our TACAN.",
        "All inputs into the A3 card will be expanded from a 3 microsecond negative going pulse to a 12 microsecond possitive going pulse. The ASC will also change depending on how many pulses are seen at the inout of the card. In this example ASC is drifting high indicating a lack of pulses.",
        "<PAGE>",
        "In this simulation the base level for ASC is 45, we will add 1 to the ASC value for no pulse and deduct 4 from the ASC value when we detect a pulse, in real life -4.5V means we have enough pulses, +0.8V inducates no pulses and -5.5V indicates too many pulses.",
        "The Dead Time Gate will disable the card stopping squitter bunching, when this happens the DC level will go high after each 12 microsecond pulse. Therefore when the Dead Time gate is high you will have no output going to A4.",
        "Good Luck"
    }
end

-- The function get_board() allows you to specify an 18x7 "ASCII art" grid to customize
-- the layout of the board and the placement of the input and output terminals. Generally
-- speaking, inputs are placed on the left of boards, while outputs are placed on the right.
--
-- For empty space, use the '.' character. 
-- For buildable board space, use the '#' character. 
-- For an input or output terminal, use characters '0' through '9' no more than once each.
-- For the bottom-left corner of the radio, use the 'R' character.
-- For the bottom-left corners of dials, use characters 'A', 'B', and 'C'.
--
function get_board()
    return [[
        .#0##############.
        .################.
        .##############1#.
        .################.
        .##############3#.
        .################.
        .#2##############.
    ]]
end

-- The function get_data() is called both to establish information about the puzzle (such as what
-- the inputs and outputs are) and to generate the random test cases. Signal levels and XBus data
-- should change from call to call, but information like the names and types of terminals should
-- not change at all.
--
-- To create a standard input or output terminal, call create_terminal(). Valid terminal types are
-- TYPE_SIMPLE, TYPE_XBUS, and TYPE_XBUS_NONBLOCKING. Valid terminal directions are DIR_INPUT and 
-- DIR_OUTPUT. Valid data for a simple I/O signal is an array of integers, 0 - 100 inclusive. Valid
-- data for an XBus signal is an array of integer arrays, each with values -999 to 999 inclusive.
--
--       create_terminal(name, board_character, type, direction, data)
--
-- To create a radio (C2S-RF901), call create_radio(). You may only create one radio in each puzzle.
-- Since radios are XBus-only, the only valid data for data_rx and data_tx are arrays of integer arrays,
-- each with values -999 to 999 inclusive. You cannot customize the signal names for a radio.
--
-- By default the radio will be placed in the bottom-left corner of the screen. However, if you use an 
-- 'R' character in your board layout, the bottom-left corner of the radio will be placed there instead.
--
--       create_radio(data_rx, data_tx)
--
-- To create a dial (N4DL-1000), call create_dial(). You may create up to three dials in each puzzle.
-- The names of dials should be kept short, as there is not much room to display them visually. A valid
-- value is an integer between 0 and 99, inclusive.
--
-- By default dials will be placed in the bottom-left corner of the screen. However, if you use an
-- 'A', 'B', or 'C' character in your board layout, the bottom-left corners of the first, second, and
-- third dials will be placed there, respectively.
--
--       create_dial(name, value)
--
-- NOTE: To generate random values you should use math.random(). However, you SHOULD NOT seed
--       the random number generator with a new seed value, as that is how the game ensures that
--       the first test run is consistent for all users, and thus something that allows for the
--       comparison of cycle scores.
--
-- NOTE: Fun fact! Arrays in Lua are implemented as tables (dictionaries) with integer keys that
--       start at 1 by convention. Contrast this with nearly every other programming language, in
--       which arrays start with an index of 0. Because of this, the 60 "time slices" that make
--       up a test case are indexed from 1 to 60 inclusive.
--
function get_data()
    A2Input = {50,50,50,50,50,50,50,50,0,50,50,50,50,0,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,0,50,50,50,50,50,50,50,0,50,50,50,0,50,50
                ,50,0,50,50,50,50,50,50,50,50,0,50,50,50}  
    A4Output = {50,50,50,50,50,50,50,50,100,100,100,100,50,100,100,100,100,50,50,50,50,50,50,50,50,50,50,50,50,50,50,100,100,100,100,50,50,50,50,100,100,100,100,50,50,50
                ,50,100,100,100,100,50,50,50,50,50,100,100,100,100}  
    deadTime = {0,0,0,0,0,0,0,0,0,0,0,0,100,0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,100,0,0,0,0,0,0,0,100,0,0
                ,0,0,0,0,0,100,0,0,0,0,0,0,0,0}  
    ASC = {45,46,47,48,49,50,51,52,48,49,50,51,52,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,61,62,63,64,65,66,67,68,64,65,66,67,63,64,65
                ,66,62,63,64,65,66,67,68,69,70,66,67,68,69}




    create_terminal("Input from A2", "0", TYPE_SIMPLE, DIR_INPUT, A2Input)
    create_terminal("Output to A4", "1", TYPE_SIMPLE, DIR_OUTPUT, A4Output)
    create_terminal("Dead Time", "2", TYPE_SIMPLE,  DIR_INPUT, deadTime)
    create_terminal("ASC", "3", TYPE_SIMPLE,  DIR_OUTPUT, ASC)

end
