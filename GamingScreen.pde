
//================================================================================================================
//================================================================================================================

class GamingScreen extends Screen implements KeyPressListener, GameDataChanged {


  public int score, hp;
  private int bg2x = width, teamCnt, teamId, listChangeCnt;
  private boolean  added;
  private ArrayList<DrawingOBJ>  drawingArray;
  private Fighter fighter = null;
  private HPDisplay title = null;
  private Bullet[] bulletArray;

  private void initVariables() {
    drawingArray = new ArrayList();
    hp = 20;
    score = 0;
    teamId = 0;
    setSpeed(5, 0);
    listChangeCnt = 0;
  }

  private void initComponents() {
    fighter = new Fighter();
    fighter.setHP(hp) ;
    fighter.zOrder = 2;
    drawingArray.add(fighter);

    title = new HPDisplay();
    title.hp = hp;
    title.zOrder = 4;
    drawingArray.add(title);

    Treasure t = new Treasure(fighter, this);
    t.zOrder = 3;
    drawingArray.add(t);

    bulletArray = new Bullet[5];
    for (int i = 0; i < 5; i++) {
      Bullet temp = new Bullet(fighter);
      temp.zOrder = 1;
      bulletArray[i]= temp;
      drawingArray.add(temp);
    }
  }

  public GamingScreen(ScreenChangeListener listener) {
    super(resourcesManager.get(ResourcesManager.bg1), listener);
    initVariables();
    initComponents();
    randomTeam();
  }

  public void SpecialDraw() {
    // sort drawing array by z order
    for (int i = 0; i < drawingArray.size(); i++) {
      for (int j = i+1; j < drawingArray.size(); j++) {
        if (drawingArray.get(i).zOrder > drawingArray.get(j).zOrder) {
          DrawingOBJ temp = drawingArray.get(i);
          drawingArray.set(i, drawingArray.get(j));
          drawingArray.set(j, temp);
        }
      }
    }
    //do logic and draw objects
    for (int i = 0; (i < drawingArray.size()) && (i>-1); i++) {
      drawingArray.get(i).drawFrame();
      if (listChangeCnt>0) {
        i -= listChangeCnt;
        listChangeCnt = 0;
      }
    }
  }

  public void doGameLogic() {
    doBackgroundLogic();
    // add a special enemy each 20 level
    boolean isSpealLevel = false;//(score % 200 == 0) && (score > 0);
    if ((score>-1)&&(isSpealLevel)&&(!added)) {
      added = true;
      drawingArray.add(new FreeBoss(bulletArray, fighter, this, score));
    } else if (added&&(!isSpealLevel)) {
      added = false;
    }
    // end the game while hp is under zero
    if (hp <= 0) {
      listener.endGame(score);
    }
    // fire logic
    fighter.shoot(bulletArray);
    // make bullets follow enemy
    bulletFollow();
  }

  private int closestEnemy(float x, float y) {
    int ret = -1;
    float minDestance = 999;
    for (int i = 0; (i < drawingArray.size()); i++) {
      DrawingOBJ temp = drawingArray.get(i);
      if (temp.classID == ObjType.ENEMY) {
        float destance = temp.getDestanceBetweenOBJ(floor(x), floor(y));
        if (temp.x < x && temp.x > 0) {
          if (destance < minDestance) {
            minDestance = destance;
            ret = i;
          }
        }
      }
    }
    return ret;
  }

  private void bulletFollow() {
    for (Bullet i : bulletArray) {
      if (i.isBulletEnabled()) {
        float bulletA = 0.2;
        int index = closestEnemy(i.x, i.y);
        if (index > -1) {
          DrawingOBJ temp = drawingArray.get(index);
          i.moveToOBJ(temp, bulletA);
        } else {
          i.moveToOBJ(i, bulletA);
        }
      }
    }
  }

  private void addEnemyInTeam(int x_offset, int y, float speed, boolean isBoss) {
    Enemy newEnemy = null;
    if (isBoss) {
      newEnemy = new Boss(bulletArray, fighter, this, score);
    } else {
      newEnemy = new Enemy(bulletArray, fighter, this, score);
      newEnemy.setImage(resourcesManager.get(ResourcesManager.enemy));
      newEnemy.setSpeed(speed, 0);
    }
    newEnemy.x = newEnemy.x - x_offset;
    newEnemy.y = y;
    newEnemy.setIsInTeam(true);
    drawingArray.add(newEnemy);
  }

  private void randomTeam() {
    int yy;
    float s = random(1, 5) * (score / 1000f+1);
    if (teamId==0) {
      yy= floor(random(height - 60)+30);
      teamCnt = 5;
      for (int i =0; i<teamCnt; i++) {
        addEnemyInTeam(floor(60 * i / s), yy, s, false);
      }
    } else if (teamId==1) {
      int offset = 50;
      yy= floor(random(height - 60 - (offset << 2))+30);
      teamCnt = 5;
      for (int i =0; i < teamCnt; i ++) {
        addEnemyInTeam(floor(60 * i / s), yy + offset * i, s, false);
      }
    } else if (teamId ==2) {
      yy= floor(random(height - 260 ) + 130);
      teamCnt = 8;
      addEnemyInTeam(0, yy, s, false);
      addEnemyInTeam(floor(60 / s), yy-50, s, false);
      addEnemyInTeam(floor(60 / s), yy+50, s, false);
      addEnemyInTeam(floor(120 / s), yy-100, s, false);
      addEnemyInTeam(floor(120 / s), yy+100, s, false);
      addEnemyInTeam(floor(180 / s), yy-50, s, false);
      addEnemyInTeam(floor(180 / s), yy+50, s, false);
      addEnemyInTeam(floor(240 / s), yy, s, false);
    } else if (teamId == 3) {
      teamCnt = 5;
      int border = 50;
      int offset = (height - (border << 1)) / (teamCnt-1);
      for (int i = 0; i < teamCnt; i ++) {
        addEnemyInTeam(0, border + offset * i, s, true);
      }
    }
    if (++teamId>3) {
      teamId = 0;
    }
  }

  public void updateLocation() {
  }

  private void doBackgroundLogic() {
    x = moveBG(floor(x));
    bg2x = moveBG(bg2x);
    image(resourcesManager.get(ResourcesManager.bg2), bg2x, y);
  }

  private int moveBG(int curX) {
    // the more level the more quick background moves
    int speedOffset = score / 200;
    int maxOffset = floor(getSpeed() * 2);
    if (speedOffset> maxOffset) {
      speedOffset = maxOffset;
    }
    curX +=width + getSpeed() + speedOffset;
    curX %= (width << 1);
    curX -= width;
    return curX;
  }


  /**
   * when key released
   */
  public void keyReleasedFun(int keyCode1) {
    fighter.keyReleasedFun(keyCode1);
  }

  /**
   * when key pressed
   */
  public void keyPressedFun(int keyCode1) {
    fighter.keyPressedFun(keyCode1);
  }


  public void addHP(int val) {
    hp += val;
    if (hp > 100) {
      hp = 100;
    }    
    syncInfo();
  }

  public void subHP(int val, DrawingOBJ target) {
    hp -= val;
    if (hp < 0) {
      hp = 0;
    }

    FrameAnimation explode = new FrameAnimation(this, ResourcesManager.explode, 81, 81);
    explode.bindingOBJ(fighter);
    explode.zOrder = 3;
    drawingArray.add(explode);

    syncInfo();
  }

  public void FrameAnimationFinished(FrameAnimation target) {
    drawingArray.remove(target);
    listChangeCnt ++;
    target = null;
  }

  public void enemyMoveOut(Enemy target, boolean showFrameAnimation) {
    drawingArray.remove(target);
    if (target.isInTeam) {
      if (--teamCnt==0) {
        randomTeam();
      }
    }
    if (showFrameAnimation) {
      FrameAnimation explode = new FrameAnimation(this, ResourcesManager.explode, 81, 81);
      explode.bindingOBJ(target);
      explode.zOrder = 3;
      drawingArray.add(explode);
      score += 20;
      syncInfo();
    }

    listChangeCnt ++;
    target = null;
  }

  public void drawFrame() {
    doGameLogic();
    int half_height = objHeight>>1;
    int half_width = objWidth>>1;
    image(super.img, x - half_width, y - half_height);    
    SpecialDraw();
  }

  private void syncInfo() {
    title.hp = hp;
    title.score= score;
    fighter.setHP(hp);
  }
}
