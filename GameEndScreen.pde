//================================================================================================================
//================================================================================================================

class FrameAnimation extends DrawingOBJ {

  public int delay = 100;

  private PImage[] expArray;
  private int timer, shownID, frameCnt;
  private GameDataChanged listener;
  private DrawingOBJ targetOBJ;

  private void initSystem(GameDataChanged listener, int startID, int frameCnt) {
    this.listener = listener;
    this.frameCnt = frameCnt;
    setIsDrawSelf(false);
    expArray = new PImage[frameCnt];
    for (int i = 0; i<frameCnt; i++) {
      expArray[i] = resourcesManager.get(startID + i);
    }
    timer = 0;
    shownID = -1;
  }

  public FrameAnimation(GameDataChanged listener, int startID) {
    super(64, 64, null, ObjType.TITLE);
    initSystem(listener, startID, 5);
  }

  public FrameAnimation(GameDataChanged listener, int startID, int frameWidth, int frameHeight) {
    super(frameWidth, frameHeight, null, ObjType.TITLE);
    initSystem(listener, startID, 5);
  }

  public FrameAnimation(GameDataChanged listener, int startID, int frameWidth, int frameHeight, int frameCnt) {
    super(frameWidth, frameHeight, null, ObjType.TITLE);
    initSystem(listener, startID, frameCnt);
  }

  public void bindingOBJ(DrawingOBJ target) {
    targetOBJ = target;
    x = target.x;
    y = target.y;
    setSpeed(target.getXSpeed(),target.getYSpeed());
  }

  public void SpecialDraw() {
    if (shownID<frameCnt) {
      image(expArray[shownID], x-(objWidth>>1), y-(objHeight>>1));
    } else if (listener != null) {
      listener.FrameAnimationFinished(this);
    } else {
      image(expArray[0], x-(objWidth>>1), y-(objHeight>>1));
      timer = millis();
    }
  }

  public void doGameLogic() {
    if (timer == 0 ) {
      timer = millis();
    }
    shownID = floor((millis() - timer)/delay);
    if (targetOBJ != null) {
      if (targetOBJ.classID == ObjType.FIGHTER) {
        x = targetOBJ.x;
        y = targetOBJ.y;
      }
    }
  }
}
