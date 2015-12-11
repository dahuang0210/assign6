
//================================================================================================================
//================================================================================================================

class GamePlayScene implements ScreenChangeListener {

  Screen screenOBJ = null;
  KeyPressListener keyListener = null;
  MouseListener mouseListener = null;

  public GamePlayScene() {
    restartGame();
  }

  public void drawFrame() {
    if (screenOBJ != null) {
      screenOBJ.drawFrame();
    }
  }

  public void mouseMovedFun(int x, int y) {
    if (mouseListener != null) {
      mouseListener.mouseMovedFun(x, y);
    }
  }

  public void mousePressedFun(int code) {
    if (mouseListener != null) {
      mouseListener.mousePressedFun(code);
    }
  }

  public void mouseReleasedFun(int code) {
    if (mouseListener != null) {
      mouseListener.mouseReleasedFun(code);
    }
  }

  /**
   * when key pressed
   */
  public void keyPressedFun(int code) {
    if  (keyListener != null ) {
      keyListener.keyPressedFun(code);
    }
  }

  /**
   * when key released
   */
  public void keyReleasedFun(int code) {
    if  (keyListener != null ) {
      keyListener.keyReleasedFun(code);
    }
  }

  //--------------------------- handled by listener ---------------------------

  public void endGame(int level) {
    onScreenChange();
    GameEndScreen newScreen = new GameEndScreen(this);
    newScreen.level = level;
    screenOBJ = newScreen;
    mouseListener = newScreen;
  }

  public void startGame() {
    onScreenChange();
    GamingScreen newScreen = new GamingScreen(this);
    screenOBJ = newScreen;
    keyListener = newScreen;
  }

  public void restartGame() {
    onScreenChange();
    GameStartScreen newScreen = new GameStartScreen(this);
    screenOBJ = newScreen;
    mouseListener = newScreen;
  }

  //--------------------------- private method ---------------------------

  private void onScreenChange() {
    screenOBJ = null;
    keyListener = null;
    mouseListener = null;
  }
}
