

//================================================================================================================
//================================================================================================================

class HPDisplay extends DrawingOBJ {

  public int hp = 0, score = 0;
  private int  visionHP = 0,  visionScore = 0;

  public HPDisplay() {
    super(0, 0, resourcesManager.get(ResourcesManager.hp), ObjType.TITLE);
    x = 10;
    y = 10;
  }

  public void SpecialDraw() {
    textSize(15);
    textAlign(CENTER);
    drawStrokeText(visionHP + "", #ffffff, #000000, floor(x + 112), floor(y + 17), 1);
    drawScore();
  }

  public void doGameLogic() {
    if (hp< 0 ) {
      hp = 0;
    } else if (hp>100) {
      hp = 100;
    }
    color hpColor ;
    float hpVal = hp;
    int curhp = floor(194f * hp / 100f);
    int viewHP = floor(194f * visionHP / 100f);
    if (hp > 50) {
      int val = 255 - floor((hpVal - 50f) / 50f * 255f);
      hpColor = color(val, 255, 0);
    } else {
      int val = floor(hpVal / 50f * 255f);
      hpColor = color(255, val, 0);
    }
    drawHPBar(hpColor, curhp,viewHP);
    if (score > visionScore)
      visionScore ++;
    else if (score < visionScore)
      visionScore --;
    if (hp > visionHP) {
      visionHP ++;
    } else if (hp < visionHP) {
      visionHP --;
    }
  }

  private void drawHPBar(color barColor, int barWidth,int movingWidth) {
    int barCurWidth = barWidth;
    if (barWidth < movingWidth) {
      color bottomColor = color(250, 0, 0);
      stroke(bottomColor);
      fill(bottomColor);
      rect( x + 12, y + 4, movingWidth, 16);
    } else if (barWidth> movingWidth) {
      color bottomColor = color(250, 255, 255);
      stroke(bottomColor);
      fill(bottomColor);
      rect( x + 12, y + 4, barWidth, 16);
      barCurWidth = movingWidth;
    }
    stroke(barColor);
    fill(barColor);
    rect( x + 12, y + 4, barCurWidth, 16);
  }

  /**
   * to draw the value of level
   */
  private void drawScore() {
    textSize(15);
    textAlign(RIGHT);
    drawStrokeText("Score:" + visionScore, #ffffff, #000000, 70, 470, 1);
  }
}
