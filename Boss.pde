class Boss extends Enemy {
  public Boss(Bullet[] bulletArray, Fighter target, GameDataChanged listener, int level) {
    super(bulletArray, target, listener, level);
    setHpAndDamage(5, 50);
    setSpeed(2,0);
  }
}

class FreeBoss extends Enemy {
  public FreeBoss(Bullet[] bulletArray, Fighter target, GameDataChanged listener, int level) {
    super(bulletArray, target, listener, level);
    setHpAndDamage(7, 50);
  }
}
