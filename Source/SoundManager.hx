package;

import motion.easing.Quad;
import motion.Actuate;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.Assets;

enum AudioId
{
  MUSIC_1;
  MUSIC_2;
  SNARE;
}

class SoundManager {

  private var channel:SoundChannel;
  private var playing:Bool;
  private var position:Float;
  private var sound:Sound;


  private static var musicChannel:SoundChannel;
  private static var musicTransform:SoundTransform;

  private static var soundMap:Map<AudioId, Sound>;

  public static function init():Void
  {
    soundMap = new Map();
    musicTransform = new SoundTransform();

    // load sounds
    for (id in Type.allEnums(AudioId))
    {
      soundMap.set(id, loadSound(getFileName(id)));
    }
  }

  public static function startMusic():Void
  {
    playMusic(MUSIC_1);
  }

  public static function playMusic(track:AudioId):Void
  {
    if (musicChannel != null)
    {
      Actuate.transform(musicChannel, 1.5).sound(0, 0).onComplete(function()
        {
          stopMusic();
          musicChannel = soundMap.get(track).play(0, 0, musicTransform);
        });
    }
    else
    {
      musicChannel = soundMap.get(track).play(0, 0, musicTransform);
    }
  }

  public static function stopMusic():Void
  {
    if (musicChannel != null)
      musicChannel.stop(); // Also prevents "soundComplete" event from firing
    musicChannel = null;
  }

  private static function loadSound(filename:String):Sound
  {
    #if flash
      return Assets.getSound("assets/" + filename + ".mp3");
    #else
      return Assets.getSound("assets/" + filename + ".ogg");
    #end
  }

  private static function getFileName(id:AudioId):String
  {
    return switch (id)
    {
      case MUSIC_1: "NyanCatJazz";
      case MUSIC_2: "poulenc";
      case SNARE: "snd_compass";
    }
  }

  public static function playSound(id:AudioId):Void
  {
    if (soundMap.exists(id))
    {
      soundMap.get(id).play();
    }
  }
  
  /*public function new () {
    
    Actuate.defaultEase = Quad.easeOut;
    
    #if flash
    sound = Assets.getSound ("assets/NyanCatJazz.mp3");
    #else
    sound = Assets.getSound ("assets/NyanCatJazz.ogg");
    #end
    
    position = 0;
    
    play();
    
  }
  
  
  private function pause (fadeOut:Float = 1.2):Void {
    
    if (playing) {
      
      playing = false;
      
      Actuate.transform (channel, fadeOut).sound (0, 0).onComplete (stop);
      
    }
    
  }
  
  
  private function play (fadeIn:Float = 3):Void {
    
    stop ();
    
    playing = true;
    
    if (fadeIn <= 0) {
      
      channel = sound.play (position);
      
    } else {
      
      channel = sound.play (position, 0, new SoundTransform (0, 0));
      Actuate.transform (channel, fadeIn).sound (1, 0);
      
    }
    
    channel.addEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
    
  }
  
  
  private function stop ():Void {
    
    playing = false;
    
    Actuate.stop (channel);
    
    if (channel != null) {
      
      position = channel.position;
      channel.removeEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
      channel.stop ();
      channel = null;
      
    }
    
  }
  
  
  
  
  // Event Handlers
  
  
  
  
  private function channel_onSoundComplete (event:Event):Void {
    
    pause ();
    position = 0;
    
  }*/  
  
}