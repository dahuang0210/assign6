//================================================================================================================
//================================================================================================================

class Enemy extends DrawingOBJ {

  protected boolean isInTeam;
  private Fighter target = null;
  private Bullet[] bulletArray;
  private GameDataChanged listener;
  private int hp, maxHP, damage;

  public Enemy(Bullet[] bulletArray, Fighter target, GameDataChanged listener, int level) {
    super(60, 60, resourcesManager.get(ResourcesManager.enemy1), ObjType.ENEMY);
    this.listener = listener;
    this.target = target;
    this.bulletArray = bulletArray;
    isInTeam = false;
    randomEnemy(true);
    setSpeed((getSpeed() * (level/1000f+1)), 0);
    maxHP = 1;
    damage = 20;
    hp = maxHP;
  }

  public void setHpAndDamage(int maxHP, int damage) {
    this.damage = damage;
    this.maxHP = maxHP;
    hp = maxHP;
  }

  public void setIsInTeam(boolean isInTeam) {
    this.isInTeam = isInTeam;
  }

  public void SpecialDraw() {
  }

  public void doGameLogic() {
    if (x < -objWidth) {
      showAlarm();
    } else {
      normalMove();
    }
  }

  public void updateLocation() {
    if (x < -objWidth) {
      x+=1;
    } else {
      super.updateLocation();
    }
  }

  public boolean isOutOfBorder() {
    int halfHeight = objHeight>>1;
    return (y > (height - halfHeight)) || (y < halfHeight) || (x > width);
  }

  private boolean isCollideWithFighter(DrawingOBJ target) {
    return this.isHitOBJ(target);
  }

  private void normalMove() {
    // normal moves
    if (!isInTeam) {
      if (x < target.x) {
        moveToOBJ(target);
      } else {
        moveToOBJ(this);
      }
    }
    if (isCollideWithFighter(target)) {
      if (listener != null) {
        listener.subHP(damage, this);
        listener.enemyMoveOut(this, false);
      }
    }
    if (bulletArray!=null) {
      for (int i=0; i<5; i++) {
        Bullet target = bulletArray[i];
        if (target.isHitOBJ(this)) {
          hp --;
          light = floor(255f / maxHP * hp);
          if (hp <= 0) {
            listener.enemyMoveOut(this, true);
          }
          target.setDisabled();
          break;
        }
      }
    }

    if (listener != null) {
      if (isOutOfBorder()) {
        listener.enemyMoveOut(this, false);
      }
    }
  }

  private void showAlarm() {
    // wait 100 times, show warning and speed 
    float temp = (- objWidth - x);
    if (temp < 100) {
      int tSize = floor(20 * (1 - (- objWidth - x) / 100f) + 5);
      textAlign(LEFT);
      textSize(16);
      // draw different color with different speed
      float speed = getSpeed();
      if (speed > 20 ) {
        drawStrokeText(String.format("%.1f",speed), color(255, 0, 0), #ffffff, 25, floor(y+ 8), 1);
      } else if (speed > 10) {
        // 10 - 20 yellow to red
        drawStrokeText(String.format("%.1f",speed), color(255, 255 - floor((speed-10)/10f * 255), 0), #ffffff, 25, floor(y+ 8), 1);
      } else {
        // 1 - 10 green to yellow
        drawStrokeText(String.format("%.1f",speed), color(floor((speed)/10f * 255), 255, 0), #ffffff, 25, floor(y+ 8), 1);
      }
      textSize(tSize);
      drawStrokeText("!", #ff0000, #ffffff, 10, floor(y + (tSize >> 1)), 1);
    }
  }

  private void randomEnemy(boolean isAvoidFighter) {
    x = -100 - objWidth;
    float speed = floor(random(1, 5));
    setSpeed(speed, 0);
    do {
      y = floor(random(0, height-40))+20;
      // if need avoid fighter and enemy is in fighter line then random again
    } while (isAvoidFighter && isInTargetLine(target));
  }

  private boolean isInTargetLine(Fighter obj) {
    int yOffset = objHeight >> 1 ;
    int yOffset1 = obj.objHeight >>1;
    int top =floor(y + yOffset), bottom =floor(y - yOffset);
    int tt =floor(obj.y + yOffset1), tb = floor(obj.y - yOffset1);
    if ((bottom < tt)&&(top > tb)) {
      return true;
    }
    return false;
  }
}
