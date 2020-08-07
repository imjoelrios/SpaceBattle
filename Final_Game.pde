/* CHARACTERS */
Hero player;
Grunt[] grunts;
Chaotic[] chaotics;
Shooter[] shooters;
Token token;

/* BACKGROUND ELEMENTS */
Star[] stars;
Galaxy galaxy;

/* MOVEMENT VARS */
boolean leftPressed = false;
boolean rightPressed = false;

/* TIMERS AND COUNTERS */
int typeTimer;
int gruntTimer = millis();
int chaoticTimer = millis();
int shooterTimer = millis();
int scoreTimer = millis();
int waveTime;
int shooterStart;
int chaoticStart;
int gruntCounter = 0;
int chaoticCounter = 0;
int shooterCounter = 0;

/* INTERFACE IMAGES */
PImage heroSkin;
//PImage normal;
//PImage hard;
PImage gameOver;
PImage quit;
PImage bg;

/* FONT */
PFont font;

/* STATE ELEMENTS */
int state, score, finalScore, enemyMaxSpeed, enemyMinSpeed;

import processing.sound.*;
SoundFile introSound, normalSound, hardSound, buttonSound;

void setup()
{
  size(500, 667);
  imageMode(CENTER);
  
  /************************* LOAD DATA ***************************/
  bg = loadImage("spacebattle.jpg");
  
  heroSkin = loadImage("Option1.png");
  
  small = loadImage("Enemy1.3.png");
  medium = loadImage("Enemy1.2.png");
  large = loadImage("Enemy1.png");
  
  chaotic = loadImage("Enemy3.png");
  
  shooterIm = loadImage("Enemy2.png");
  
  starIms = new PImage[2];
  starIms[0] = loadImage("Star.png");
  starIms[1] = loadImage("Star2.png");
  
  galaxyIm = loadImage("Galaxy.png");
  
  tokenIm = loadImage("Token.png");
  
  font = createFont("Death Star.otf", 32);
  textFont(font);
  
  //SOUNDS
  damage = new SoundFile(this, "minecraftAlphaDamageSound.mp3");
  introSound = new SoundFile(this, "Sci-fi Pulse Loop.wav");
  normalSound = new SoundFile(this, "Space Cube.wav");
  hardSound = new SoundFile(this, "Arpeggio1 120.wav");
  tokenSound = new SoundFile(this, "Token Sound Effect.mp3");
  eatEnemySound = new SoundFile(this, "Transforming Sound Effect.mp3");
  eatEnemySound.amp(0.2);
  laserSound = new SoundFile(this, "Laser Gun Sound Effect.mp3");
  buttonSound = new SoundFile(this, "button click.mp3");


  /*******************************GAME SETUP****************************/
  score = -1;
  
  player = new Hero(30, 5, 0, heroSkin);
  
  galaxy = new Galaxy(random(0, width), random(0, height), random(80,150));
  
  stars = new Star[20];
  for (int i = 0; i < stars.length; i++)
  {
    stars[i] = new Star(random(0,width), random(0,height), random(10,30), starIms[(int)random(0,1.99)]);
  }
  
  shooters = new Shooter[10];
  for (int i = 0; i < shooters.length; i++)
  {
    shooters[i] = new Shooter(40,random(30,width-30),0.7);
  }
  
  token = new Token(random(20, width - 20));
  
  chaotics = new Chaotic[10];
  for (int i = 0; i < chaotics.length; i++)
  {
    chaotics[i] = new Chaotic(30,random(3,5), random(1,2), random(0, width));
  }

  grunts = new Grunt[20];
  for (int i = 0; i < 20; i++)
  {
    grunts[i] = new Grunt(random(20, 100), random(20, width-20), random(1, 2));
  }
  
  frameRate(60);
  noStroke();
  
   /*******************************SOUND****************************/
   introSound.loop();
}

void draw()
{
  if (state == 0) 
  {
    /************************** MENU ********************************/
    background(bg);
    
    /*normal = loadImage("normal.jpg");
    imageMode(CENTER);
    image(normal, width/2, height/2-100, 254, 61);

    hard = loadImage("hard.jpg");
    imageMode(CENTER);
    image(hard, width/2, height/2, 251, 63);*/

    quit = loadImage("quit.jpg");
    imageMode(CENTER);
    image(quit, width/2, height - 100, 254, 62);

    if (onNormal())
    {
      noFill();
      strokeWeight(8);
      stroke(255, 255, 255);
      rectMode(CENTER);
      rect(width/2, height/2 -80, 254, 61);
    } 
    else if (onHard())
    {
      noFill();
      strokeWeight(8);
      stroke(255, 255, 255);
      rectMode(CENTER);
      rect(width/2, height/2 + 20, 254, 61);
    } 
    else if (onQuit())
    {
      noFill();
      strokeWeight(8);
      stroke(255, 255, 255);
      rectMode(CENTER);
      rect(width/2, height-100, 254, 61);
    }
  } 
  else if (state == 1 || state == 2) // GAME MODE
  {
    if (state == 1) // NORMAL
    {
      waveTime = 2000;
      enemyMaxSpeed = 4;
      enemyMinSpeed = 1;
      chaoticStart = 90000;
      shooterStart = 45000;
    }
    else if (state == 2) // HARD
    {
      waveTime = 500;
      enemyMaxSpeed = 10;
      enemyMinSpeed = 5;
      chaoticStart = 0;
      shooterStart = 0;
    }
    
    /********************* RESET GAME UPON DEATH*********************/
    if (player.lives == 0)
    {
      introSound = new SoundFile(this, "Sci-fi Pulse Loop.wav");
      introSound.loop();
      
      if(state == 1){//SOUND
        normalSound.stop(); 
      }
      else{
        hardSound.stop(); 
      }
      
      state = 3;
      finalScore = score;
      score = 0;
      typeTimer = millis();
      player = new Hero(30, 5, 0, heroSkin);
      
      token = new Token(random(20, width-20));

      for (int i = 0; i < 20; i++)
      {
        grunts[i] = new Grunt(random(20, 100), random(20, width-20), random(1, 2));
      }
  
      for (int i = 0; i < shooters.length; i++)
      {
        shooters[i] = new Shooter(40,random(30,width-30),0.7);
      }
   
      for (int i = 0; i < chaotics.length; i++)
      {
        chaotics[i] = new Chaotic(30,random(3,5), random(1,2), random(0, width));
      }
    }
    
    background(0);

    galaxy.display();
    galaxy.move();
    
    for (int i = 0; i < stars.length; i++)
    {
      stars[i].display();
      stars[i].move();
    }
    
    /************************MOVES AND DISPLAYS PLAYER*****************/
    player.move(leftPressed, rightPressed);
    player.display();

    /**************************DEPLOY ENEMIES************************/

    if (millis() - gruntTimer >= waveTime) // GRUNTS
    {
      for (int i = 0; i < (int)random(0, 5); i++)
      {
        gruntTimer = millis();
        grunts[gruntCounter%20].respawn(random(20, player.size*2), random(20, width-20), random(enemyMinSpeed, enemyMaxSpeed));
        gruntCounter++;
      }
    }
    
    
    if (millis() - chaoticTimer >= 12000 && millis() - typeTimer >= chaoticStart) // CHAOTICS
    {
      for (int i = 0; i < (int)random(0, 3); i++)
      {
        chaoticTimer = millis();
        chaotics[chaoticCounter%10].respawn(random(3,5), random(1,2), random(50,width-50));
        chaoticCounter++;
      }
    }
    
    if (millis() - shooterTimer >= 14000  && millis() - typeTimer >= shooterStart) // SHOOTERS
    {
      for (int i = 0; i < (int)random(0,3); i++)
      {
        shooterTimer = millis();
        shooters[shooterCounter%10].respawn(random(50,width-50));
        shooterCounter++;
      }
    }
    
    if (millis() - typeTimer >= shooterStart)
    {
      if (token.captured)
      {
        token.loop(random(20, width-20));
      }
    }

    /************************MOVES ENEMIES AND CHECKS FOR COLLISION/DEATHS*********************/

    if (!token.captured)
    {
      token.move();
      token.display();
      
      if (player.tokenCollision(token))
      {
        player.eatToken(token);
        score += 10;
      }
    }
    
    for (int i = 0; i < grunts.length; i++) // GRUNTS
    {
      if (!grunts[i].isDead)
      {
        grunts[i].move();
        grunts[i].display();

        if (player.gruntCollision(grunts[i]))
        {  
          if (player.size > grunts[i].size)
          {
            player.eatGrunt(grunts[i]); 
            grunts[i].isDead = true;
            score += 10;
          } 
          else if (!grunts[i].hasAttacked) // if grunt is bigger and hasnt already made contact
          {
            player.takeDamage();
            grunts[i].hasAttacked = true; // has made contact
          }
        }
      }
    }
    
    for (int i = 0; i < chaotics.length; i++) // CHAOTICS
    {
      if (!chaotics[i].isDead)
      {
        chaotics[i].move();
        chaotics[i].display();
        
        if (player.chaoticCollision(chaotics[i]))
        {
          if (chaotics[i].yPos < 627 - (0.5*player.size))
          {
            player.eatChaotic();
            chaotics[i].isDead =true;
            score += 50;
          }
          else if (!chaotics[i].hasAttacked) // if chaotic hits the side of your ship
          {
            player.takeDamage();
            chaotics[i].hasAttacked = true;
          }
        }
      }
    }
    
    for (int i = 0; i < shooters.length; i++) // SHOOTERS
    {
       if (!shooters[i].hasPassed)
       {
        shooters[i].move();
        shooters[i].display();
        shooters[i].shoot();
        
        for (int j= 0; j < shooters[i].weapons.length; j++)
        {
          if (player.bulletCollision(shooters[i].weapons[j]) && !shooters[i].weapons[j].hasHit)
          {
            shooters[i].weapons[j].fired = false;
            shooters[i].weapons[j].hasHit = true;
            if (player.shield == 0)
            {
              player.takeDamage();
            }
            else
            {
              player.loseShield();
            }
          }
        }
      }
    }
    
    /********************************STATS***************************/
    if (millis() - scoreTimer >= 1000)
    {
      scoreTimer = millis();
      score++;
    }
    
    fill(255);
    textSize(20);
    text("Lives: " + player.lives, 410, 30);
    text("Score: " + score, 20, 30);
  }
  else if(state == 3) 
  {
    background(0);

    gameOver = loadImage("gameOver.jpg");
    imageMode(CENTER);
    image(gameOver, 250, 300, 500, 667);
    
    textAlign(CENTER, CENTER);
    textSize(32);
    fill(255,255,0);
    text("Score: " + finalScore ,width/2, height/2 - 20);
    textAlign(LEFT);
    
    if (onQuit2())
    {
      noFill();
      strokeWeight(8);
      stroke(255, 255, 255);
      rectMode(CENTER);
      rect(345, 565, 160, 50);
    }
    
    else if (onHome())
    {
      noFill();
      strokeWeight(8);
      stroke(255, 255, 255);
      rectMode(CENTER);
      rect(147, 550, 80, 80);
    }
  }
}

boolean onNormal()
{
    if(mouseX >= (width/2 - 127) && mouseX <= (width/2 + 127) && mouseY >= (height/2 - 110) && mouseY <= (height/2 - 50))
    {
      return true;
    } 
    else 
    {
      return false;
    }
}
  
boolean onHard()
{
    if(mouseX >= (width/2 - 127) && mouseX <= (width/2 +127) && mouseY >= (height/2 - 10) && mouseY <= (height/2 + 50)) 
    {
      return true;
    } 
    else 
    {
      return false;
    }
}
  
boolean onQuit()
{
    if(mouseX >= (width/2 - 127) && mouseX <= (width/2 + 127) && mouseY >= (height - 130) && mouseY <= (height - 70))
    {
      return true;
    } 
    else
    {
      return false;
    }
}

boolean onQuit2()
{
    if(mouseX >= 265 && mouseX <= 425 && mouseY >= 550 && mouseY <= 590)
    {
      return true;
    } 
    else
    {
      return false;
    }
}

boolean onHome()
{
  if (mouseX >= 107 && mouseX <= 187 && mouseY >= 510 && mouseY <= 590 )
  {
    return true;
  } 
  else 
  {
    return false;
  }
}
  
  
void mouseClicked()
{
  /********************* USER INTERFACE FOR MENU***********************/
  if (onNormal() && state == 0)
  {
    state = 1;
    typeTimer = millis();
    //SOUND
    buttonSound.play();
    introSound.stop(); 
    normalSound.loop();
  }
  else if (onHard() && state == 0) 
  {
    state = 2;
    typeTimer = millis();
    //SOUND
    buttonSound.play();
    introSound.stop(); 
    hardSound.loop();
  }
  else if (onQuit() && state == 0)
  {
    exit();
  }
  else if (onQuit2() && state == 3)
  {
    exit();
  }
  else if (onHome())
  {
    state = 0;
  }
}

void keyPressed()
{
  /****************USER CONTROLS*****************/
  if (keyCode == LEFT) 
  {
    leftPressed = true;
  } else if (keyCode == RIGHT)
  {
    rightPressed = true;
  }
}

void keyReleased()
{
  /**************USER CONTROLS*********************/
  if (keyCode == RIGHT)
  {
    rightPressed = false;
  } else if (keyCode == LEFT)
  {
    leftPressed = false;
  }
}
