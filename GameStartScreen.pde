
//================================================================================================================
//================================================================================================================

class GameStartScreen extends Screen implements MouseListener {

  private boolean isOnButton, isPressButton;
  private int alpha, alpha_offset ;

  public GameStartScreen(ScreenChangeListener listener) {
    super(resourcesManager.get(ResourcesManager.st2), listener);
    alpha_offset = 10;
    alpha = 0;
  }

  public void SpecialDraw() {
    if (isOnButton && (! isPressButton)) {
      image(img, x, y);
      tint(255, alpha);
      image(resourcesManager.get(ResourcesManager.st1), 0, 0);
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
  }

  public void doGameLogic() {
    setIsDrawSelf((!isOnButton) ||isPressButton);
  }


  public void mouseReleasedFun(int keyCode1) {
    if (keyCode1 == MOUSE_LEFT) {
      isPressButton = false;
      if (isOnButton && listener != null) {
        listener.startGame();
      }
    }
  }
  public void mousePressedFun(int keyCode1) {
    if (keyCode1 == MOUSE_LEFT) {
      isPressButton = true;
    }
  }
  public void mouseMovedFun(int x, int y) {
    boolean newBool = isPointHitArea(x, y, 210, 380, 450, 410);
    if (newBool!=isOnButton) {
      alpha_offset = 10;
      alpha = 0;
    }
    isOnButton =  newBool;
  }
}
