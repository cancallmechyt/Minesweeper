class Minefield{
  int fieldMat[][] = new int [sideLength][sideLength];
  int unturned[][] = new int [sideLength][sideLength];
  int bombsNumAroundMe;
  
  Minefield(){
    for(int i = 0; i < sideLength * 4; i++){
      int col = floor(random(sideLength));
      int row = floor(random(sideLength));
      while(fieldMat[row][col] == -1){
        col = floor(random(sideLength));
        row = floor(random(sideLength));
      }
      fieldMat[row][col] = -1;
    }
  }
     
  int bombsAroundMe(int row, int col){
    bombsNumAroundMe = 0;
    try{
      if(fieldMat[row - 1][col - 1] == -1){
        bombsNumAroundMe++;
      }
    }
    catch(Exception e){
    }
    try{
      if(fieldMat[row - 1][col] == -1){
        bombsNumAroundMe++;
      }
    }
    catch(Exception e){
    }
    try{
      if(fieldMat[row - 1][col + 1] == -1){
        bombsNumAroundMe++;
      }
    }
    catch(Exception e){
    }
    try{
      if(fieldMat[row][col - 1] == -1){
        bombsNumAroundMe++;
      }
    }
    catch(Exception e){
    }
    try{
      if(fieldMat[row][col + 1] == -1){
        bombsNumAroundMe++;
      }
    }
    catch(Exception e){
    }
    try{
      if(fieldMat[row + 1][col - 1] == -1){
        bombsNumAroundMe++;
      }
    }
    catch(Exception e){
    }
    try{
      if(fieldMat[row + 1][col] == -1){
        bombsNumAroundMe++;
      }
    }
    catch(Exception e){
    }
    try{
      if(fieldMat[row + 1][col + 1] == -1){
        bombsNumAroundMe++;
      }
    }
    catch(Exception e){
    }
    return bombsNumAroundMe;
  }
}
