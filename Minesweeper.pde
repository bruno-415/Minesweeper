import de.bezier.guido.*;
private static final int NUM_ROWS = 20;
private static final int NUM_COLS = 20;
private static final int NUM_MINES = 50; //real # of mines could be lower, this is the number of times game attempts to create a mine
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;

void setup ()
{
    size(600, 600);
    textAlign(CENTER,CENTER);
    textSize(200/NUM_ROWS);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++)
      for(int j = 0; j < NUM_COLS; j++)
        buttons[i][j] = new MSButton(i,j);
    
    
    for(int i = 0; i < NUM_MINES; i++)
      setMines();
}
public void setMines()
{
  int row, col;
  row = (int)(Math.random()*NUM_ROWS);
  col = (int)(Math.random()*NUM_COLS);
  if(!mines.contains(buttons[row][col]))
    mines.add(buttons[row][col]);
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int countOfClicked = 0;
    for(int i = 0; i < NUM_ROWS; i++)
      for(int j = 0; j < NUM_COLS; j++)
        if(buttons[i][j].isClicked())
          countOfClicked++;
    if(countOfClicked == NUM_ROWS*NUM_COLS)
      return true;
    return false;
}
public void displayLosingMessage()
{
    fill(255,0,0); //not working
    buttons[0][0].setLabel("L");
    buttons[0][1].setLabel("O");
    buttons[0][2].setLabel("S");
    buttons[0][3].setLabel("E");
    buttons[0][4].setLabel("!");
    gameOver = true;
}
public void displayWinningMessage()
{
    fill(0,255,0); //not working
    buttons[0][0].setLabel("W");
    buttons[0][1].setLabel("I");
    buttons[0][2].setLabel("N");
    gameOver = true;
}
public boolean isValid(int r, int c)
{
    if (r<NUM_ROWS && r>=0 && c<NUM_COLS && c>=0)
      return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = row-1; i <= row+1; i++)
      for(int j = col-1; j <= col+1; j++)
        if(isValid(i,j) && mines.contains(buttons[i][j]))
          numMines++;
    if(mines.contains(buttons[row][col]))
      numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged, revealed;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = revealed = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
      if(!gameOver){
        clicked = true;
        if(mouseButton == RIGHT && !revealed){ //if statement should also make sure the tile is not already known to not be a mine!!!
          flagged = !flagged;
          if(flagged == false)
            clicked = false;
        }
        else if(mines.contains(this) && !flagged){
          flagged = false;
          displayLosingMessage();
        }
        else if(countMines(myRow, myCol) > 0 && !flagged){
          myLabel = "" + countMines(myRow, myCol);
          revealed = true;
        }
        else if(!flagged) {
          revealed = true;
          for(int i = myRow-1; i <= myRow+1; i++)
            for(int j = myCol-1; j <= myCol+1; j++)
              if(isValid(i,j) && !buttons[i][j].isClicked())
                buttons[i][j].mousePressed();
        }
      }
    }
    
    public void draw () 
    {    
        stroke(181, 143, 72);
        if(flagged)
            fill(217, 146, 48);
        else if(clicked && mines.contains(this)) 
            fill(255,0,0);
        else if(clicked)
            fill(230, 216, 179);
        else 
            fill(235, 210, 141);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked()
    {
      return clicked;
    }
}
