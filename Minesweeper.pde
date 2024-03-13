PImage Menu,logo, block, mine, flag, gameOverImg, gameWinImg;
ArrayList<PImage> nums = new ArrayList<PImage>();

int boxSize = 16, sideLength = 30, cellsLeft, flagsLeft;
boolean gameStarted = false, dead = false, deadNextFrame = true, won = false, wonNextFrame = false;

Minefield field;

int interval = 250; // delay(milliseconds)
int lastUpdate = 0; 

void drawMenu() {
  image(Menu, 0, 0, width, height); //background image
  int now = millis();
  if (now - lastUpdate >= interval) {
    lastUpdate = now;
    color c = color(random(255), random(255), random(255));
    fill(c);
  }
  textSize(70);
  textAlign(CENTER, CENTER);
  text("press 'enter' to start game", width/2, 350);
}

void setup(){
  textFont(createFont("Game Over", 32)); //set font to GameOverfont 
  field = new Minefield(); //
  Menu = loadImage("menu.png");
  logo = loadImage("logo.png");
  block = loadImage("block.png");
  mine = loadImage("mine.png");
  flag = loadImage("flagged.png");
  gameOverImg = loadImage("gameover.png");
  gameWinImg = loadImage("gamewin.png");
  for(int i = 0; i < 9; i++){
    String name = str(i);
    name += ".png";
    nums.add(loadImage(name));
  }
}

void draw(){
  if (!gameStarted) {
  drawMenu();
  } else {
  flagsLeft = sideLength * 4;
  cellsLeft = sideLength * sideLength;
  
  if(!dead && !won){
    settings();
    background(255);
    for(int i = 0; i < sideLength; i++){
      for(int j = 0; j < sideLength; j++){
        if(field.unturned[i][j] == 1){
          cellsLeft--;
          if(field.fieldMat[i][j] == -1){
            image(mine, j * boxSize, i * boxSize);
          }
          else{
            image(nums.get(field.bombsAroundMe(i, j)), j * boxSize, i * boxSize);
          }
        }
        else if(field.unturned[i][j] == 2){
          image(flag, j * boxSize, i * boxSize);
          cellsLeft--;
          flagsLeft--;
        }
        else{
          image(block, j * boxSize, i * boxSize);
        }
      }
    }
    fill(0); 
    textSize(40);
    text("Cells Left: " + cellsLeft, 70, 490); // display the number of cells left to uncover
    text("Flags Left: " + flagsLeft, 400, 490); // display the number of flags left to place
    if(cellsLeft == 0){ // went cellsLeft is zero
        won = true; // set the won variable to true
      }
  }
  else if(won && !wonNextFrame){
    for(int i = 0; i < sideLength; i++){
      for(int j = 0; j < sideLength; j++){
        if(field.unturned[i][j] == 1){
          cellsLeft--;
          if(field.fieldMat[i][j] == -1){
            image(mine, j * boxSize, i * boxSize);
          }
          else{
            image(nums.get(field.bombsAroundMe(i, j)), j * boxSize, i * boxSize);
          }
        }
        else if(field.unturned[i][j] == 2){
          image(flag, j * boxSize, i * boxSize);
          cellsLeft--;
        }
        else{
          image(block, j * boxSize, i * boxSize);
        }
      }
    }
    image(gameWinImg, width/2 - gameWinImg.width/2, height/2 - gameWinImg.height/2);
    wonNextFrame = true;
  }
  if(dead){
    if(deadNextFrame){
      for(int i = 0; i < sideLength; i++){
        for(int j = 0; j < sideLength; j++){
          if(field.unturned[i][j] == 1){
            cellsLeft--;
            if(field.fieldMat[i][j] == -1){
              image(mine, j * boxSize, i * boxSize);
            }
            else{
              image(nums.get(field.bombsAroundMe(i, j)), j * boxSize, i * boxSize);
            }
          }
          else if(field.unturned[i][j] == 2){
            image(flag, j * boxSize, i * boxSize);
            cellsLeft--;
            flagsLeft--;
          }
          else{
            image(block, j * boxSize, i * boxSize);
          }
        }
      }
      textSize(50);
      fill(255, 0, 0);
      image(gameOverImg, width/2 - gameOverImg.width/2, height/2 - gameOverImg.height/2);
    }
    deadNextFrame = false;
  }
}
}

public void settings(){
  size(boxSize * sideLength, boxSize * sideLength + 30);
}

void mousePressed(){
  int y = mouseY / boxSize;
  int x = mouseX / boxSize;
  
  if (!gameStarted) {
    gameStarted = true;
  }
  
  if(mouseButton == LEFT){
    if(field.unturned[y][x] != 2){
      if(field.fieldMat[y][x] == -1){
        dead = true;
        for(int i = 0; i < sideLength; i++){
          for(int j = 0; j < sideLength; j++){
            if(field.fieldMat[i][j] == -1){
              field.unturned[i][j] = 1;
            }
          }
        }
      }
      revealBlocks(y, x);
    }
  }
  else if(mouseButton == RIGHT){
    if(field.unturned[y][x] != 1){
      if(field.unturned[y][x] == 2){
        field.unturned[y][x] = 0;
      }
      else{
        field.unturned[y][x] = 2;
      }
    }
  }
}

void revealBlocks(int row, int col){
  if(field.bombsAroundMe(row, col) == 0){
    if(field.unturned[row][col] != 1){
      if(row == 0 && col == 0){
        for(int i = row; i <= row + 1; i++){
          for(int j = col; j <= col + 1; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(row == 0 && col == sideLength - 1){
        for(int i = row; i <= row + 1; i++){
          for(int j = col - 1; j <= col; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(row == sideLength - 1 && col == 0){
        for(int i = row - 1; i <= row; i++){
          for(int j = col; j <= col + 1; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(row == sideLength - 1 && col == sideLength - 1){
        for(int i = row - 1; i <= row; i++){
          for(int j = col - 1; j <= col; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(row == sideLength - 1 && col == sideLength - 1){
        for(int i = row - 1; i <= row; i++){
          for(int j = col - 1; j <= col; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(row == 0){
        for(int i = row; i <= row + 1; i++){
          for(int j = col - 1; j <= col + 1; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(col == 0){
        for(int i = row - 1; i <= row + 1; i++){
          for(int j = col; j <= col + 1; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(row == sideLength - 1){
        for(int i = row - 1; i <= row; i++){
          for(int j = col - 1; j <= col + 1; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(col == sideLength - 1){
        for(int i = row - 1; i <= row + 1; i++){
          for(int j = col - 1; j <= col; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else{
        for(int i = row - 1; i <= row + 1; i++){
          for(int j = col - 1; j <= col + 1; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
    }
  }
  else{
    field.unturned[row][col] = 1;
  }
}

void resetGame() {
  field = new Minefield();
  dead = false;
  deadNextFrame = true;
  won = false;
  wonNextFrame = false;
}

void keyPressed() {
if (!gameStarted && key == ENTER ) {
gameStarted = true;
  }
else if (key == 'r' || key == 'R') { //  Press the 'r' button to restart game.
resetGame();
  }
else if (key == 'k' || key == 'K') { //  Press the 'k' button to view answer.
  for (int i = 0; i < field.fieldMat.length; i++) {
    for (int j = 0; j < field.fieldMat[0].length; j++) {
       if (field.fieldMat[i][j] != -1) {
           field.unturned[i][j] = (field.unturned[i][j] + 1) % 2;
        }
      }
    }
  }
}
