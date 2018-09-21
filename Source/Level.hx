package;

import openfl.geom.Point;
import openfl.geom.Rectangle;

class Level {
  
  private var number:Int;
  private var platforms:List<Rectangle>;
  private var numPeople:Int;
  private var entrance:Point;
  private var exit:Point;

  public function new(n:Int)
  {
    number = n;

    platforms = new List();
    platformsPlease();
  }

  public function platformsPlease():Void
  {
    switch (number)
    {
      case 1:
        platforms.add(new Rectangle(0.4, 0.4, 0.4, 0.1));
        platforms.add(new Rectangle(0.65, 0.65, 0.4, 0.1));
    }
  }

  public function getPlatforms():List<Rectangle>
  {
    return platforms;
  }

  public static function getLevel(level:Int):Level
  {
    return new Level(level);
  }
}