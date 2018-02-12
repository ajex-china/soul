package soul.service.websocket
{

import flash.utils.ByteArray;

public class WebSocketFrame 
{
  
  public var rsv:int = 0;
  public var opcode:int = -1;
  public var length:uint = 0;
  public var fin:Boolean = true;
  public var mask:Boolean = false;
  public var payload:ByteArray = null;
  
}

}
