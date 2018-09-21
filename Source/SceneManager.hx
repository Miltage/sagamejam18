package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.Lib;

import haxe.Timer;

enum SceneNames
{
  SPLASH;
  GAME;
  EMPTY; // this is for the initial fullscreen prompt and anywhere else it might be needed
}

class SceneManager extends Sprite {

  public static inline var BACKGROUND_COLOR:Int = 0xC0D2E8;
  public static inline var ASPECT_RATIO_MIN:Float = 0;
  public static inline var ASPECT_RATIO_MAX:Float = 100;
  public static inline var DISPLAY_FACTOR_RATIO_MAX:Float = 1;

  private static var instance:SceneManager;

  private var container:DisplayObjectContainer;
  private var scenes:Map<String, Scene>;
  private var stack:List<SceneNames>;
  private var currentSceneName:SceneNames;
  private var currentScene:Scene;

  private var currentSubScenes:List<SubScene>;
  private var subScenes:Sprite;

  private var managerWidth:Float;
  private var managerHeight:Float;
  private var displayFactor:Float;

  private var lastUpdate:Float;
  private var frameIndex:Int;

  private var perfDebug:PerfDebug;

	public function new()
  {
    super();
    instance = this;

    container = new DisplayObjectContainer();
    addChild(container);

    scenes = new Map();
    stack = new List();
    currentSceneName = null;
    currentScene = null;

    currentSubScenes = new List();
    subScenes = null;

    managerWidth = 0;
    managerHeight = 0;
    displayFactor = 0;

    // in case needed in scene init
    frameIndex = 0;
    lastUpdate = 0;

    perfDebug = new PerfDebug();
    #if debug
    addChild(perfDebug);
    #end

    redraw();

    var stage = Lib.current.stage;
    stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    stage.addEventListener(Event.EXIT_FRAME, onExitFrame);
    stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    stage.addEventListener(Event.RESIZE, onResize);
    stage.addEventListener(Event.DEACTIVATE, onDeactivate);

    addScene(SPLASH, new SplashScene());
    addScene(GAME, new CatScene());

    setCurrentScene(SPLASH);
  }

  public static function getInstance():SceneManager
  {
    return instance;
  }

  public static function getWidth():Float
  {
    return instance.managerWidth;
  }

  public static function getHeight():Float
  {
    return instance.managerHeight;
  }

  public static function getDisplayFactor():Float
  {
    return instance.displayFactor;
  }

  public static function getFrameIndex():Int
  {
    return instance.frameIndex;
  }

  public function addScene(name:SceneNames, scene:Scene):Void
  {
    scenes.set("" + name, scene);
  }

  public function getScene(name:SceneNames):Scene
  {
    return scenes.get("" + name);
  }

  public static function getCurrentScene():Scene
  {
    return instance.currentScene;
  }

  private function setInstanceScene(name:SceneNames, ?ignoreBusy:Bool = false, fadeOutTime:Float = null):Void
  {
    if (currentScene != null)
    {
      getCurrentScene().onSceneLeave();
      container.removeChild(getCurrentScene());
    }

    if (subScenes != null)
    {
      for (ss in currentSubScenes)
        ss.onSceneLeave();
      container.removeChild(subScenes);
    }

    subScenes = new Sprite();
    currentSubScenes = new List();

    currentSceneName = name;
    currentScene = getScene(name);
    container.addChild(getCurrentScene());
    container.addChild(subScenes);
    getCurrentScene().onSceneEnter();
  }

  public static function setCurrentScene(name:SceneNames, fadeOutTime:Float = null):Void
  {
    instance.setInstanceScene(name, fadeOutTime);
  }

  public static function popCurrentScene():Void
  {
    instance.stack.pop();
    var target = instance.stack.pop();
    if (target != null)
      setCurrentScene(target);
  }

  public static function pushSubScene(ss:SubScene, fadeIn:Bool = true):Void
  {
    instance.currentSubScenes.push(ss);
    instance.subScenes.addChild(ss);
    ss.onSceneEnter();
  }

  public static function emptySubScenes():Bool
  {
    return instance.currentSubScenes.isEmpty();
  }

  public static function getSubSceneIndex(needle:SubScene):Int
  {
    var i = 0;
    for (ss in instance.currentSubScenes)
    {
      if (ss == needle)
        return i;
      i++;
    }
    return -1;
  }

  public static function popSubScene(fadeOut:Bool = true):SubScene
  {
    var ss = instance.currentSubScenes.pop();
    if (ss != null)
    {
      ss.onSceneLeave();
      instance.subScenes.removeChild(ss);
    }
    return ss;
  }

  private function onResize(event:Event):Void
  {
    redraw();
  }

  private function redraw(force:Bool = false):Void
  {
    var stage = Lib.current.stage;

    // stage width, height and aspect ratio
    var sw = stage.stageWidth;
    var sh = stage.stageHeight;
    var sar = sw / sh;

    // target aspect ratio
    var tar = sar;
    if (tar < ASPECT_RATIO_MIN)
      tar = ASPECT_RATIO_MIN;
    else if (tar > ASPECT_RATIO_MAX)
      tar = ASPECT_RATIO_MAX;

    var nmw:Float;
    var nmh:Float;
    if (sw <= (tar * sh)) // limited by width?
    {
      nmw = Math.round(sw);
      nmh = Math.floor(sw / tar);
    }
    else
    {
      nmh = Math.round(sh);
      nmw = Math.floor(sh * tar);
    }

    var change = false;
    if (managerWidth != nmw || managerHeight != nmh)
    {
      managerWidth = nmw;
      managerHeight = nmh;
      change = true;
    }

    // set x and y
    x = Math.round((sw - managerWidth) / 2);
    y = Math.round((sh - managerHeight) / 2);

    updateDisplayFactor();

    if (change || force)
    {
      graphics.clear();
      graphics.beginFill(BACKGROUND_COLOR);
      graphics.drawRect(0, 0, managerWidth, managerHeight);

      for (scene in scenes)
        scene.onSceneResize();
      for (ss in currentSubScenes)
        ss.onSceneResize();

      #if (!flash)
      stage.onMouseMove(stage.window, 0, 0); // workaround for OpenFL hover crash
      #end
    }

    perfDebug.x = displayFactor * 0.02;
    perfDebug.y = managerHeight - perfDebug.height - displayFactor * 0.02;
  }

  private function updateDisplayFactor():Void
  {
    displayFactor = computeDisplayFactor(managerWidth, managerHeight);
  }

  public static function computeDisplayFactor(w:Float, h:Float):Float
  {
    var ar = w / h;
    if (ar <= DISPLAY_FACTOR_RATIO_MAX) // narrow enough
    {
      return w;
    }
    else // very wide
    {
      return DISPLAY_FACTOR_RATIO_MAX * h;
    }
  }

  public function onEnterFrame(event:Event):Void
  {
    var now = Timer.stamp();
    var timeDelta = now - lastUpdate;
    lastUpdate = now;
    frameIndex++;

    if (currentSubScenes.first() != null)
    {
      currentSubScenes.first().onEnterFrame(event, timeDelta);
      if (currentScene != null && getCurrentScene().handleFramesWithSubScene())
        getCurrentScene().onEnterFrame(event, timeDelta);
    }
    else if (currentScene != null)
      getCurrentScene().onEnterFrame(event, timeDelta);
  }

  public function onExitFrame(event:Event):Void
  {
    if (currentSubScenes.first() != null)
    {
      currentSubScenes.first().onExitFrame(event);
      if (currentScene != null && getCurrentScene().handleFramesWithSubScene())
        getCurrentScene().onExitFrame(event);
    }
    else if (currentScene != null)
      getCurrentScene().onExitFrame(event);
  }

  public function onDeactivate(event:MouseEvent):Void
  {
    if (currentSubScenes.first() != null)
      currentSubScenes.first().onDeactivate(event);
    else if (currentScene != null)
      getCurrentScene().onDeactivate(event);
  }

  public function onKeyDown(event:KeyboardEvent):Void
  {
    if (currentSubScenes.first() != null)
      currentSubScenes.first().onKeyDown(event);
    else if (currentScene != null)
      getCurrentScene().onKeyDown(event);
  }

  public function onKeyUp(event:KeyboardEvent):Void
  {
    if (currentSubScenes.first() != null)
      currentSubScenes.first().onKeyUp(event);
    else if (currentScene != null)
      getCurrentScene().onKeyUp(event);

    #if html5
      event.preventDefault(); // don't trigger normal events like scrolling
    #end
  }

  public function onMouseUp(event:MouseEvent):Void
  {
    if (currentSubScenes.first() != null)
      currentSubScenes.first().onMouseUp(event);
    else if (currentScene != null)
      getCurrentScene().onMouseUp(event);
  }

  public function onMouseDown(event:MouseEvent):Void
  {
    if (currentSubScenes.first() != null)
      currentSubScenes.first().onMouseDown(event);
    else if (currentScene != null)
      getCurrentScene().onMouseDown(event);
  }

  public function onMouseMove(event:MouseEvent):Void
  {
    if (currentSubScenes.first() != null)
      currentSubScenes.first().onMouseMove(event);
    else if (currentScene != null)
      getCurrentScene().onMouseMove(event);
  }
}