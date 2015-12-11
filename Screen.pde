
//================================================================================================================
//================================================================================================================

abstract class Screen extends DrawingOBJ {
  protected ScreenChangeListener listener;
  public Screen(PImage background, ScreenChangeListener listener) {
    super(0, 0, background, ObjType.BACKGROUND);
    this.listener = listener;
  }
}
