/*
  This class represents the enemy type that moves straight down the screen, firing bullets that can take a life from the player.
  It will fire in bursts of three bullets.  These enemies cannot be caught.
*/

PImage shooterIm;

SoundFile laserSound;

class Shooter
{
  float size;
  float speed;
  float xPos;
  float yPos;
  int fireTime;
  int fireCount;
  boolean hasPassed; // true if passed the bottom of the window
  Bullet[] weapons; // stores bullets to fire
  PImage skin;
  
  Shooter(float _size, float _xPos, float _speed)
  {
    weapons = new Bullet[10];
    size = _size;
    xPos = _xPos;
    yPos = -50;
    speed = _speed;
    hasPassed = true;
    skin = shooterIm;
    fireTime = millis();
    fireCount = 0;
    
    for (int i = 0; i < weapons.length; i++)
    {
      weapons[i] = new Bullet();
    }
  }
  
  void display()
  {
    // displays the imageFile for the shooter at the specified location and at the specified size
    image(shooterIm, xPos, yPos, size, size);
    for (int i = 0; i < weapons.length; i++)
    {
      if (weapons[i].fired && !weapons[i].hasHit)
      {
        weapons[i].display();
      }
    }
  }
  
  void move()
  {
    // moves the object down through the window at a specified speed
    yPos += speed;
    for (int i = 0; i < weapons.length; i++)
    {
      if (weapons[i].fired)
      {
        weapons[i].move();
      }
    }
  }
  
  void shoot()
  {
    // causes the bullets stored in "weapons" to be fired from the ship
    if ((millis() - fireTime) > 1750 && yPos >= 0 && yPos <= width + 30)
    {
      weapons[fireCount%weapons.length].xPos = this.xPos;
      weapons[fireCount%weapons.length].yPos = this.yPos + 15;
      weapons[fireCount%weapons.length].fired = true;
      fireCount++;
      fireTime = millis();
      laserSound.play();
    }
  }
  
  void respawn(float _xPos)
  {
    // recyles the object after it passes the bottom of the window, allowing it to be deployed as a "new" shooter later
    xPos = _xPos;
    yPos = -50;
    hasPassed = false;
  }
}
