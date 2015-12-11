
//================================================================================================================
//================================================================================================================

class Treasure extends DrawingOBJ {

  private Fighter target = null;
  private GameDataChanged listener;

  public Treasure(Fighter target, GameDataChanged listener) {
    super(40, 40, resourcesManager.get(ResourcesManager.treasure), ObjType.TREASURE);
    this.listener = listener;
    this.target = target;
    randomTreasure();
  }

  public void SpecialDraw() {
  }

  public void doGameLogic() {
    if (target != null) {
      if (isHitOBJ(target)) {
        if (listener != null) {
          listener.addHP(10);
        }
        randomTreasure();
      }
    }
  }

  /**
   * to random an treasure
   */
  public void randomTreasure() {
    // x is from 20 to 620
    // y is from 20 to 460
    do {
      x = floor(random(width - 40)+20);
      y = floor(random(height - 40)+20);
    } while (isHitOBJ(target));
  }
}
