# SnakeiOS - Version 1.0

A classic game of snake made entirely in Swift.

## Game type

The Game has two modes an Arcade Mode and a Story Mode.

##### Arcade Mode
In this mode you have to make the most points you possibly can and try to beat your own record in three different difficulties.

##### Story Mode
In this mode you have to reach a certain amount of points each level to go to the next one.

## Architecture

### Snake
- It has the coordinates of it's head and an array of coordinates of it's body.
- It has the direction the snake is going with an enumeration of directions.
- It has a method to move the snake, calculating the next coordinate and making the body bigger if it ate the food.

### Food
- It has the coordinates of the food.
- It has a method to randomly get new coordinates.

### Level
- It is only used in story mode.
- It communicates with a plist that records all game levelsinformation.
- It has the information of how many walls the level has, the coordinates of each wall and amount of points to reach the next level.

### GameManager

- The Game mechanics and character are controlled by the GameManager.
- It has the instance of the snake and the food.
- Creates and controls a timer to make frames of the game.
- Can pause, resume and restart the game by manipulating the timer
- Communicates with the interface via delegate to draw new frames and tell if the game has ended.

### ArcadeManager

- Inherits from GameManager.
- Overrides methods to change mechanics to make the game checks difficulties high scores and update those values.
- Controls the difficulty of the game by making a new frame faster or slower depending on how hard the game is.
- Controls if the game has ended each frame.

### StoryManager

- Inherits from GameManager.
- Overrides methods to change mechanics to make the game change levels and to know when the game ends.
- Controls the level by having a instance of Level that makes, and manages current level.

### GameViewController

- Responsible to make the graphic interface of the game.
- It adjust the size of the coordinate depending on the size of the screen.
- Draws each frame.
- Manages the player controls.
- Transform "map" coordinate into pixel to draw the something in the screen.
- Control buttons to pause, resume, restart and exit the game.

### ViewController

- Responsible to make the graphic interface of the menu.
- Controls which gameMode the player has choosen and tells the GameViewController.
- Makes animations in the snakeLabel and in the transitions between menus.
- Controls which difficulty the player has choosen in Arcade Mode and tells the GameViewController.
