
//================================================================================================================
//================================================================================================================

class GameEndScreen extends Screen implements MouseListener {

  public int level = 0;
  private boolean isOnButton, isPressButton;
  private int alpha, alpha_offset ;

  public GameEndScreen(ScreenChangeListener listener) {
    super(resourcesManager.get(ResourcesManager.end2), listener);
    isOnButton = false;
    isPressButton = false;
  }

  public void SpecialDraw() {
    if (isOnButton && (! isPressButton)) {
      tint(255, alpha);
      image(resourcesManager.get(ResourcesManager.end1), 0, 0);
      tint(255, 255);
      alpha += alpha_offset;
      if (alpha>255) {
        alpha = 255;
        alpha_offset = -alpha_offset;
      } else if (alpha<100) {
        alpha = 100;
        alpha_offset = -alpha_offset;
      }
    }
    textAlign(CENTER);
    textSize(30);
    drawStrokeText("Final Score:"+level, #ffffff, #ff0000, 320, 220, 2);
  }

  public void doGameLogic() {
    setIsDrawSelf((!isOnButton) ||isPressButton);
  }

  public void drawFrame() {
    doGameLogic();
    image(resourcesManager.get(ResourcesManager.end2), 0, 0);
    SpecialDraw();
  }

  public void mouseReleasedFun(int keyCode1) {
    if (keyCode1 == MOUSE_LEFT) {
      isPressButton = false;
      if (isOnButton && listener != null) {
        listener.restartGame();
      }
    }
  }
  public void mousePressedFun(int keyCode1) {
    if (keyCode1 == MOUSE_LEFT) {
      isPressButton = true;
    }
  }
  public void mouseMovedFun(int x, int y) {
    boolean newBool = isPointHitArea(x, y, 210, 310, 435, 345);
    if (newBool!=isOnButton) {
      alpha_offset = 10;
      alpha = 0;
    }
    isOnButton =  newBool;
  }
}
