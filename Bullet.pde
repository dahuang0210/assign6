
//================================================================================================================
//================================================================================================================

class Bullet extends DrawingOBJ {

  private boolean isEnabled;
  private DrawingOBJ target;

  public Bullet(DrawingOBJ target) {
    super(31, 27, resourcesManager.get(ResourcesManager.bullet), ObjType.BULLET);
    this.target = target;
    isEnabled = false;
    setSpeed(10, 0);
  }

  public boolean shoot() {
    if (isEnabled) {
      return false;
    } else {
      isEnabled = true;
      x = target.x;
      y = target.y;
      setSpeed(10, 0);
    }
    return true;
  }
  //*
  public void SpecialDraw() {
  }//*/

  public void doGameLogic() {
    isEnabled = (x>-objWidth);
    setIsDrawSelf(isEnabled);
  }

  public void setDisabled() {
    isEnabled = false;
    x = -1-objWidth;
  }

  public void updateLocation() {
    if (isEnabled) {
      x -= getXSpeed();
      y -= getYSpeed();
    }
  }

  public boolean isBulletEnabled() {
    return isEnabled;
  }

  public boolean isHitOBJ(DrawingOBJ obj) {
    return (isEnabled && (super.isHitOBJ(obj, 0, 10)));
  }
}
