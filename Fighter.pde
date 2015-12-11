//================================================================================================================
//================================================================================================================

class Fighter extends DrawingOBJ implements KeyPressListener {

  private final int SHOOT_DELAY = 100;

  public int hp;
  public boolean fighting, healing;

  private ArrayList<Integer> xKeyStack, yKeyStack;                    // sequence of key pressed
  private int xKeyPressedTime=1, yKeyPressedTime=1;                   // how long did user pressed a key

  private color hpColor = #ffffff;
  private long lastShootTime;
  private int healRange;

  public Fighter() {
    super(50, 50, resourcesManager.get(ResourcesManager.fighter), ObjType.FIGHTER);
    xKeyStack = new ArrayList();
    yKeyStack = new ArrayList();
    x = 600;
    y = 240;
    healRange = 0;
    lastShootTime = 0;
    healing = false;
    fighting = false;
  }

  public void setHP(int hp) {
    if (this.hp < hp) {
      healing = true;
    }
    this.hp = hp;
  }

  public void SpecialDraw() {
    float hpVal = hp;
    stroke(hpColor);
    fill(hpColor);
    ellipse(x, y, 45 + floor(hpVal/4f), 50);
    if (healing) {
      healRange +=10;
      ellipse(x, y, healRange, healRange);
      if (healRange >= 90) {
        healing = false;
      }
    } else if (healRange > 30) {
      healRange -= 5;
      ellipse(x, y, healRange, healRange);
    }
  }

  public void doGameLogic() {
    refreshKeyState();
    float hpVal = hp;
    if (hp>66) {
      int val = floor((hpVal - 66f) / 33f * 255f);
      hpColor = color(val, 255, val);
    } else if (hp>33) {
      int val = 255 - floor((hpVal - 33f) / 33f * 255f);
      hpColor = color(val, 255, 0);
    } else {
      int val = floor(hpVal / 33f * 255f);
      hpColor = color(255, val, 0);
    }
  }

  public void shoot(Bullet[] bulletArray) {
    if (fighting) {
      long timeErr = millis() - lastShootTime;
      if (timeErr>SHOOT_DELAY) {
        boolean isShoot =false;
        for (int i=0; (i<5); i++) {
          isShoot = bulletArray[i].shoot();
          if (isShoot) {
            lastShootTime = millis();
            timeErr = 0;
            break;
          }
        }
      }
    }
  }

  private void refreshKeyState() {
    if (xKeyStack.size()>0) {
      xKeyPressedTime ++;
      if (xKeyPressedTime>20) {
        xKeyPressedTime = 20;
      }
      switch(xKeyStack.get(xKeyStack.size()-1)) {
      case LEFT:
        x-=xKeyPressedTime>>1;
        break;
      case RIGHT:
        x+=xKeyPressedTime>>1;
      }
      int offset = objWidth >> 1;
      if (x < offset) {
        x = offset;
      } else if (x > (width - offset)) {
        x = width - offset;
      }
    }
    if (yKeyStack.size()>0) {
      yKeyPressedTime ++; 
      if (yKeyPressedTime > 20) {
        yKeyPressedTime = 20;
      }
      switch(yKeyStack.get(yKeyStack.size()-1)) {
      case UP:
        y -= yKeyPressedTime >> 1;
        break;          
      case DOWN:
        y += yKeyPressedTime >> 1;
      }
      int offset = objHeight >> 1;
      if (y < offset) {
        y = offset;
      } else if (y > (height - offset)) {
        y = height - offset;
      }
    }
  }

  /**
   * when key released
   */
  public void keyReleasedFun(int keyCode1) {
    if (keyCode1 == LEFT || keyCode1 == RIGHT) {
      xKeyPressedTime = 1;
      for (int i=0; i<xKeyStack.size(); i++) {
        if (xKeyStack.get(i)==keyCode1) {
          xKeyStack.remove(i);
          break;
        }
      }
    }
    if (keyCode1 == UP||keyCode1 == DOWN) {
      yKeyPressedTime = 1;
      for (int i=0; i<yKeyStack.size(); i++) {
        if (yKeyStack.get(i)==keyCode1) {
          yKeyStack.remove(i);
          break;
        }
      }
    }
    if (keyCode1 == 32) {
      fighting = false;
    }
  }

  /**
   * when key pressed
   */
  public void keyPressedFun(int keyCode1) {
    if (keyCode1 == 32) {
      if (keyCode1 == 32) {
        if (fighting == false) {
          lastShootTime = millis() - SHOOT_DELAY -1;
        }
        fighting = true;
      }
    }
    if (keyCode1 == LEFT || keyCode1 == RIGHT) {
      if (xKeyStack.size()==0 || xKeyStack.get(xKeyStack.size()-1)-keyCode1 != 0) {
        xKeyStack.add(keyCode1);
      }
    }
    if (keyCode1 == UP||keyCode1 == DOWN) {
      if (yKeyStack.size()==0 || yKeyStack.get(yKeyStack.size()-1)-keyCode1 != 0) {
        yKeyStack.add(keyCode1);
      }
    }
  }
}
