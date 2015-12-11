
//================================================================================================================
//================================================================================================================

interface MouseListener {
  public void mouseReleasedFun(int keyCode1) ;
  public void mousePressedFun(int keyCode1) ;
  public void mouseMovedFun(int x, int y);
}

//================================================================================================================
//================================================================================================================

interface KeyPressListener {
  public void keyReleasedFun(int keyCode1) ;
  public void keyPressedFun(int keyCode1) ;
}

//================================================================================================================
//================================================================================================================

interface ScreenChangeListener {
  public void startGame() ;
  public void endGame(int level) ;
  public void restartGame() ;
}

//================================================================================================================
//================================================================================================================

interface GameDataChanged {
  public void addHP(int val);
  public void subHP(int val, DrawingOBJ obj);
  public void enemyMoveOut(Enemy target, boolean isShowFrameAnimation);
  public void FrameAnimationFinished(FrameAnimation target);
}
