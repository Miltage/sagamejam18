package;

import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.events.Event;

import haxe.Timer;

class Popup extends SubScene {

  public static inline var TEXT_WIDTH:Float = 0.8;
  public static inline var MIN_WAIT:Float = 0.3;

  private var message:String;
  private var waitTill:Float;
  private var onDismiss:Void->Void;

  public function new(message:String, ?onDismiss:Void->Void)
  {
    super();

    this.message = message;
    this.onDismiss = onDismiss;

    waitTill = Timer.stamp() + MIN_WAIT;
  }

  override public function redraw():Void
  {
    super.redraw();

    var sw = SceneManager.getWidth();
    var sh = SceneManager.getHeight();
    var df = SceneManager.getDisplayFactor();

    var format = new TextFormat ("Arial", 30, 0xFFFFFF);
    var label = new TextField();    
    label.defaultTextFormat = format;
    label.embedFonts = true;
    label.selectable = false;
    
    label.x = sw/2 - label.width/2;
    label.autoSize = TextFieldAutoSize.LEFT;
    #if html5
      label.height = label.textHeight + 5;
    #end
    
    label.text = message;
    
    addChild(label);

    var action = new TextField();
    action.defaultTextFormat = format;
    action.embedFonts = true;
    action.selectable = false;
    action.text = "Click to continue";
    action.selectable = false;
    action.autoSize = TextFieldAutoSize.LEFT;
    action.x = sw/2 - action.width/2;
    addChild(action);

    var sp = df * 0.1;

    var th = label.height + sp + action.height;
    label.y = sh/2 - th/2;
    action.y = label.y + label.height + sp;
  }

  override public function onInput(event:Event = null):Void
  {
    if (Timer.stamp() <= waitTill)
      return;

    //SoundManager.playUiSfx(UI_GENERAL);

    SceneManager.popSubScene();

    if (onDismiss != null)
      onDismiss();
  }

}