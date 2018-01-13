# SnakeiOS - Version 1.0

A classic game of snake made entirely in Swift.

## Game type

The Game is an Arcade, you have to make the most points you possibly can and try to beat your own record.

## Architecture

### Snake
- It has the coordinates of it's head and an array of coordinates of it's body.
- It has the direction the snake is going with an enumeration of directions.
- It has a method to move the snake, calculating the next coordinate and making the body bigger if it ate the food.

### Food
- It has the coordinates of the food.
- It has a method to randomly get new coordinates.

### GameManager

- The Game mechanics and character are controlled by the GameManager.
- It has the instance of the snake and the food.
- Creates and controls a timer to make frames of the game.
- Can pause, resume and restart the game by manipulating the timer
- Controls the difficulty of the game by making a new frame faster or slower depending on how hard the game is.
- Controls if the game has ended each frame.
- Communicates with the interface via delegate to draw new frames and tell if the game has ended.

### GameViewController

- Responsible to make the graphic interface of the game.
- It adjust the size of the coordinate depending on the size of the screen.
- Draws each frame.
- Manages the player controls.
- Transform "map" coordinate into pixel to draw the something in the screen.
- Control buttons to pause, resume, restart and exit the game.
