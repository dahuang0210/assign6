
//================================================================================================================
//================================================================================================================

class ResourcesManager extends HashMap<Integer, PImage> {

  public final static int hp = 1;
  public final static int end1 = 10, end2 = 11;
  public final static int bg1 = 20, bg2 = 21;
  public final static int st1 = 30, st2 = 31;
  public final static int enemy = 40, enemy1=41;
  public final static int fighter = 50, treasure = 51, bullet = 52;
  public final static int explode = 70;
  
  public  ResourcesManager() {
    super();
    loadResources();
  }


  private void addImage(int Key, String resName) {
    if (!this.containsKey(Key)) {
      PImage newRes = loadImage(resName);
      this.put(Key, newRes);
    }
  }
  /**
   * to load pictures
   */
  private void loadResources() {
    addImage(ResourcesManager.hp, "img/hp.png");
    addImage(ResourcesManager.end1, "img/end1.png");
    addImage(ResourcesManager.end2, "img/end2.png");
    addImage(ResourcesManager.bg1, "img/bg1.png");
    addImage(ResourcesManager.bg2, "img/bg2.png");
    addImage(ResourcesManager.st1, "img/start1.png");
    addImage(ResourcesManager.st2, "img/start2.png");
    addImage(ResourcesManager.enemy, "img/enemy.png");
    addImage(ResourcesManager.enemy1, "img/Moocs-element-enemy1.png");
    addImage(ResourcesManager.fighter, "img/fighter.png");
    addImage(ResourcesManager.treasure, "img/treasure.png");
    addImage(ResourcesManager.bullet, "img/shoot.png");
    for (int i=0; i<5; i++) {
      addImage(ResourcesManager.explode+i, "img/flame"+(i+1)+".png");
    }
  }
}
