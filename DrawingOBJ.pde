
//================================================================================================================
//================================================================================================================

public class ObjType {
  final static int FIGHTER = 1, ENEMY = 2, TREASURE = 3, BULLET = 4;
  final static int BACKGROUND = 10, TITLE = 11;
  final static int NOTHING = -1, UNKNOWN = 0;
}

//================================================================================================================
//================================================================================================================

abstract class DrawingOBJ {
  public int classID = ObjType.NOTHING;
  public int objWidth, objHeight;
  public float x, y;
  public int zOrder;
  public int light, opacity;
  public float angle;
  private float xSpeed, ySpeed, totalSpeed;
  protected PImage img = null;
  protected boolean visible = true;

  public DrawingOBJ(int objWidth, int objHeight, PImage image, int classID) {
    this.objWidth = objWidth;
    this.objHeight = objHeight;
    this.classID = classID;
    img = image;
    x = 0;
    y = 0;
    xSpeed = 0;
    ySpeed = 0;
    light = 255;
    opacity = 255;
    zOrder = 0;
  }

  public void setImage(PImage img){
    this.img = img;
  }

  public void setIsDrawSelf(boolean visible) {
    this.visible = visible;
  }

  public void updateAngle() {
    if (xSpeed == 0) {
      if (ySpeed>0) {
        angle = PI/2;
      } else {
        angle = -PI/2;
      }
    } else if (ySpeed == 0) {
      angle = 0;
    } else {
      angle = atan(ySpeed/xSpeed);
    }
  }

  public void updateLocation() {
    x += xSpeed;
    y += ySpeed;
  }

  public void drawFrame() {
    updateLocation();
    doGameLogic();
    SpecialDraw();
    if (visible && (img != null)) {
      if ((light<255)||(opacity <255)) {
        tint(light, opacity);
      }
      int half_height = objHeight>>1;
      int half_width = objWidth>>1;
      if (angle!=0) {
        pushMatrix();
        translate(x, y);
        rotate(angle);
        image(img, -half_width, -half_height);
        popMatrix();
      } else {
        image(img, x-half_width, y-half_height);
      }
      if ((light<255)||(opacity <255)) {
        tint(255, 255);
      }
    }
  }

  boolean isPointHitArea(int px, int py, int x, int y, int r, int b) {
    return ((px > x) && (px < r) && (py > y) && (py < b));
  }

  public boolean isHitOBJ(DrawingOBJ obj) {
    return isHitOBJ(obj, 0, 0);
  }

  public boolean isHitOBJ(DrawingOBJ obj, int xxOffset, int yyOffset) {
    return isHit(floor(obj.x), floor(obj.y), obj.objWidth, obj.objHeight, floor(x), floor(y), objWidth-xxOffset, objHeight-yyOffset);
  }

  public boolean isHit(int ax, int ay, int aw, int ah, int bx, int by, int bw, int bh) {
    int xOffset = (bw >> 1), yOffset = (bh >> 1);
    int xOffset1 = aw >> 1, yOffset1 = ah >>1;
    int left = bx - xOffset, right = bx + xOffset;
    int top = by + yOffset, bottom = by - yOffset;
    int tl = ax - xOffset1, tr = ax + xOffset1;
    int tt = ay + yOffset1, tb = ay - yOffset1;
    if ((left< tr) && (right > tl)) {
      if ((bottom < tt)&&(top > tb)) {
        return true;
      }
    }
    return false;
  }

  public void drawStrokeText(String str, color textColor, color strokeColor, int textx, int texty, int strokeWidth) {
    fill(strokeColor);
    text(str, textx-strokeWidth, texty);
    text(str, textx+strokeWidth, texty);
    text(str, textx, texty-strokeWidth);
    text(str, textx, texty+strokeWidth);
    text(str, textx-strokeWidth, texty-strokeWidth);
    text(str, textx-strokeWidth, texty+strokeWidth);
    text(str, textx+strokeWidth, texty-strokeWidth);
    text(str, textx+strokeWidth, texty+strokeWidth);
    fill(textColor);
    text(str, textx, texty);
  }

  public void addYSpeed(float addValue) {
    ySpeed += addValue;
    if (ySpeed > totalSpeed ) {
      ySpeed = totalSpeed;
      xSpeed = 0;
    } else if (ySpeed < - totalSpeed) {
      ySpeed = - totalSpeed;
      xSpeed=0;
    } else if (ySpeed == 0) {
      xSpeed = totalSpeed;
    } else {
      xSpeed = sqrt(totalSpeed*totalSpeed-ySpeed*ySpeed);
    }
  }

  public void moveToOBJ(DrawingOBJ target) {
    moveToOBJ(target, 0.3);
  }

  public void moveToOBJ(DrawingOBJ target, float yAccelerated) {
    float yMove = (target.y - y);
    float xMove = (target.x - x);
    float targetYSpeed = 0;
    if (xMove!=0) {
      targetYSpeed = yMove / xMove * (xSpeed + target.xSpeed);
    }
    float speedErr = targetYSpeed - ySpeed;
    if (speedErr > yAccelerated) {
      addYSpeed(yAccelerated);
    } else if (speedErr < -yAccelerated) {
      addYSpeed(-yAccelerated);
    } else { 
      addYSpeed(speedErr);
    }
    updateAngle();
  }

  public void setSpeed(float xSpeed, float ySpeed) {
    this.xSpeed = xSpeed;
    this.ySpeed = ySpeed;
    if (ySpeed == 0)
      totalSpeed = abs(xSpeed);
    else if (xSpeed == 0)
      totalSpeed = abs(ySpeed);
    else
      totalSpeed = sqrt(xSpeed*xSpeed +ySpeed*ySpeed);
  }

  public float getSpeed() {
    return totalSpeed;
  }

  public float getXSpeed() {
    return xSpeed;
  }

  public float getYSpeed() {
    return ySpeed;
  }

  public float getDestanceBetweenOBJ(DrawingOBJ target) {
    return getDestanceBetweenOBJ(target.x, target.y);
  }

  public float getDestanceBetweenOBJ(float targetX, float targetY) {
    float xerr = targetX - x, yerr = targetY - y;
    return sqrt(xerr * xerr + yerr * yerr);
  }

  public boolean isOutOfBorder() {
    int halfWidth = objWidth >> 1;
    int halfHeight = objHeight >> 1;
    return (y > (height - halfHeight)) || (y < halfHeight) || (x > (width - halfWidth)) || (x < halfWidth);
  }

  abstract public void SpecialDraw();
  abstract public void doGameLogic();
}
