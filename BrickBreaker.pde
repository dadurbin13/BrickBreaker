// Global variables
float ballX, ballY;
float ballSpeedX = 6, ballSpeedY = 6;
float paddleX, paddleSpeed = 10, paddleWidth = 100, paddleHeight = 20;
boolean moveLeft = false, moveRight = false;

String[] grid = {
  "OOOOOOOOOOOOOOOOOOOO",
  "OOOOOOOOOOOOOOOOOOOO",
  "OOOOOOOOOXXOOOOOOOOO",
  "OOOOOOOXXXXXXXOOOOOO",
  "OOOOOXXXXXXXXXXXOOOO",
  "OOOOXXXXXXXXXXXXXOOO",
  "OOOXXXXXXXXXXXXXXXOO",
  "OOXXXXXXXXXXXXXXXXXO",
  "OXXXXXXXXXXXXXXXXXXX",
  "XXXXXXXXXXXXXXXXXXXX",
  "XXXXXXXXXXXXXXXXXXXX",
  "OXXXXXXXXXXXXXXXXXXX",
  "OOXXXXXXXXXXXXXXXXXO",
  "OOOXXXXXXXXXXXXXXXOO",
  "OOOOXXXXXXXXXXXXXOOO",
  "OOOOOXXXXXXXXXXXOOOO",
  "OOOOOOOXXXXXXXOOOOOO",
  "OOOOOOOOOXXOOOOOOOOO",
  "OOOOOOOOOOOOOOOOOOOO",
  "OOOOOOOOOOOOOOOOOOOO"
};


int rows = 20; // 20 rows
int cols = 20; // 20 columns
boolean[][] bricks = new boolean[rows][cols];

float brickWidth, brickHeight = 20;
int score = 0;
int lives = 3;
int brickOffsetY = 50; // Offset for bricks to move them down
boolean gameOver = false; // Game over state

void setup() {
  size(1600, 1200);
  initializeGame();
}

void draw() {
  if (!gameOver) {
    background(0);
    moveBall();
    displayBall();
    displayPaddle();
    displayBricks();
    displayLivesAndScore();
  } else {
    displayGameOver();
  }
}

void initializeGame() {
  ballX = width / 2;
  ballY = height / 2;
  paddleX = width / 2 - paddleWidth / 2;
  brickWidth = width / cols;
  ballSpeedX = 6;
  ballSpeedY = 6;
  gameOver = false;
  score = 0;
  lives = 3;

  initializeBricks();
}

void initializeBricks() {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      bricks[i][j] = (grid[i].charAt(j) == 'X');
    }
  }
}

void moveBall() {
  ballX += ballSpeedX;
  ballY += ballSpeedY;
  
  // Boundary checking for the ball
  if (ballX < 0 || ballX > width) {
    ballSpeedX *= -1; // Bounce off left and right walls
  }
  
  if (ballY < 0) {
    ballSpeedY *= -1; // Bounce off the top wall
  }
  
  if (ballY > height) {
    lives--; // Decrement lives when the ball hits the bottom
    if (lives <= 0) {
      gameOver = true; // Set game over if no lives left
      return; // Exit the function to avoid resetting the ball position
    }

    // Reset ball position for the next life
    ballX = width / 2;
    ballY = height / 2;
    ballSpeedY = -abs(ballSpeedY); // Ensure the ball starts moving upwards
  }
  
  // Paddle collision
  if (ballY + 10 >= height - paddleHeight && ballX >= paddleX && ballX <= paddleX + paddleWidth) {
    ballSpeedY *= -1; // Bounce off the paddle
  }
  
  // Brick collision
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (bricks[i][j]) {
        float brickX = j * brickWidth;
        float brickY = i * brickHeight + brickOffsetY;
        if (ballX > brickX && ballX < brickX + brickWidth && ballY > brickY && ballY < brickY + brickHeight) {
          bricks[i][j] = false; // Destroy the brick on collision
          ballSpeedY *= -1; // Reverse the ball's vertical direction
          score += 10; // Increase the score for each brick destroyed
        }
      }
    }
  }
}

void displayBall() {
  fill(255);
  ellipse(ballX, ballY, 20, 20);
}

void displayPaddle() {
  // Update paddle position based on key presses
  if (moveLeft && paddleX > 0) {
    paddleX -= paddleSpeed;
  }
  if (moveRight && paddleX < width - paddleWidth) {
    paddleX += paddleSpeed;
  }

  rect(paddleX, height - paddleHeight, paddleWidth, paddleHeight);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      moveLeft = true;
    } else if (keyCode == RIGHT) {
      moveRight = true;
    }
  }

  if (gameOver && key == 'r') {
    initializeGame();
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      moveLeft = false;
    } else if (keyCode == RIGHT) {
      moveRight = false;
    }
  }
}

void displayBricks() {
  fill(255, 0, 0);
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (bricks[i][j]) {
        rect(j * brickWidth, i * brickHeight + brickOffsetY, brickWidth, brickHeight);
      }
    }
  }
}

void displayLivesAndScore() {
  textSize(20);
  fill(255);
  text("Lives: " + lives, 20, 30);
  text("Score: " + score, width - 120, 30);
}

void displayGameOver() {
  background(0);
  textSize(40);
  fill(255, 0, 0);
  text("GAME OVER", width / 2 - 100, height / 2);
  textSize(20);
  text("Score: " + score, width / 2 - 50, height / 2 + 40);
  text("Press 'R' to Restart", width / 2 - 75, height / 2 + 70);
}
