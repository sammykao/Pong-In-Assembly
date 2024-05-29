# Pong Game in x86 Assembly Language

## Overview
This project is a simple implementation of the classic Pong game written in x86 Assembly language for the DOS environment. It features basic gameplay mechanics including ball movement, paddle control, scoring, and game-over conditions.

## Table of Contents
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Compiling and Running](#compiling-and-running)
- [Game Controls](#game-controls)
- [Game Mechanics](#game-mechanics)
- [Code Structure](#code-structure)
- [Contributing](#contributing)
- [License](#license)

## Getting Started
To get started with this project, follow the instructions below to set up your development environment, compile the game, and start playing.

## Prerequisites
- **Assembler:** You'll need an assembler like NASM or MASM to compile the assembly code.
- **DOS Emulator:** Use DOSBox or another DOS emulator to run the compiled binary on modern systems.

## Compiling and Running
### Using NASM
1. **Assemble the code:**
    ```bash
    nasm -f bin pong.asm -o pong.com
    ```

2. **Run the game:**
    - Open DOSBox or your preferred DOS emulator.
    - Navigate to the directory containing `pong.com`.
    - Run the game by typing:
      ```bash
      pong.com
      ```

## Game Controls
- **Paddle Movement:**
  - Player One (Left Paddle): Use the `W` key to move up and the `S` key to move down.
  - Player Two (Right Paddle): Use the `Up Arrow` key to move up and the `Down Arrow` key to move down.
- **Main Menu:**
  - `S` key to start a single-player game.
  - `M` key to start a multiplayer game.
  - `E` key to exit the game.
- **Game Over Screen:**
  - `R` key to restart the game.
  - `E` key to exit to the main menu.

## Game Mechanics
- The game starts with the ball in the center of the screen.
- The ball moves diagonally across the screen, bouncing off the top and bottom edges.
- Players control paddles to prevent the ball from passing them.
- When the ball passes a paddle, the opposing player scores a point.
- The first player to score 5 points wins the game.
- Upon game over, a message displays the winner, and the player can choose to restart or exit to the main menu.

## Code Structure
The code is organized into several segments and procedures, each responsible for a different aspect of the game.

### Data Segment
Defines all the game variables, including window dimensions, game state variables, ball and paddle positions, velocities, and text strings for display.

### Code Segment
Contains the main game logic and procedures:

- **MAIN:** The main procedure that initializes the game and enters the main game loop.
- **MOVE_BALL:** Handles the movement of the ball, including collision detection with the window boundaries and paddles.
- **DRAW_BALL:** Draws the ball at its current position.
- **CLEAR_SCREEN:** Clears the screen.
- **MOVE_PADDLES:** Placeholder for paddle movement logic (to be implemented).
- **DRAW_PADDLES:** Placeholder for drawing paddles at their current positions.
- **DRAW_UI:** Placeholder for drawing the user interface (score display, etc.).
- **DRAW_GAME_OVER_MENU:** Placeholder for drawing the game over menu.
- **DRAW_MAIN_MENU:** Placeholder for drawing the main menu.
- **UPDATE_TEXT_PLAYER_ONE_POINTS:** Updates the score text for player one.
- **UPDATE_TEXT_PLAYER_TWO_POINTS:** Updates the score text for player two.
- **RESET_BALL_POSITION:** Resets the ball to its original position.
- **CONCLUDE_EXIT_GAME:** Exits the game.

### Procedures to Implement
You will need to implement the placeholder procedures to complete the game:
- **DRAW_SQUARE:** Implement logic to draw a square representing the ball.
- **MOVE_PADDLES:** Implement paddle movement based on user input.
- **DRAW_PADDLES:** Implement logic to draw paddles.
- **DRAW_UI:** Implement logic to draw the user interface.
- **DRAW_GAME_OVER_MENU:** Implement logic to draw the game over menu.
- **DRAW_MAIN_MENU:** Implement logic to draw the main menu.
- **UPDATE_TEXT_PLAYER_ONE_POINTS:** Implement logic to update player one’s score text.
- **UPDATE_TEXT_PLAYER_TWO_POINTS:** Implement logic to update player two’s score text.

## Contributing
If you would like to contribute to this project, please follow these steps:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Create a new Pull Request.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
