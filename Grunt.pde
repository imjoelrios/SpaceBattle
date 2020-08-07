/* 
  This class is a basic enemy type that will move straight down the screen.  
  They will be of different speeds and sizes.  Grunts larger than the player will
  take a life if hit, and if one less than or equal to the size of the player is caught,
  the player will increase their size relative to the size of the enemy. 
  These enemies will be the first to show up.
*/

PImage small;
PImage medium;
PImage large;

class Grunt
{
  float size;
  float speed; // velocity moving down the screen
  float xPos;
  float yPos;
  boolean isDead; // true if caught by the player
  boolean hasAttacked; // true when an enemy larger than the player hits the player
  PImage skin;
 
  Grunt(float _size, float _xPos, float _speed)
  {
    size = _size;
    speed = _speed;
    xPos = _xPos;
    yPos = -200.0;
    isDead = true; // new enemies start off dead and are made alive when they are ready to be deployed/displayed
    hasAttacked = false;
  }
  
  void display()
  {  
    // displays the enmey at the correct location and with the correct size
    imageMode(CENTER);
    if (this.size < 75)
    {
      image(small,xPos,yPos,size,size);
    }
    else if (this.size < 150)
    {
      image(medium,xPos,yPos,size,size);
    }
    else
    {
      image(large,xPos,yPos,size,size);
    }
  }  
  
  void move()
  {
    if (!(this.isDead)) // if enemy isn't dead
    {
      yPos += speed; // moves down the window
    }
    if(yPos > height + 200) // if enemy has passed the bottom of the screen
    {
      isDead = true;
    }
  }
  
  void respawn(float _size, float _xPos, float _speed)
  {
    isDead = false; //"revives" the enemy
    hasAttacked = false;
    xPos = _xPos; // new x-position
    yPos = -200.0; // brings enemy back to the top of the window
    size = _size; // new size
    speed = _speed;
  }
}
