package soul.service.websocket
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	
	import soul.debug.AS3Debugger;
	
	public class  WebSocketChannel extends EventDispatcher
	{
		private var handshaker:String = null;
		
		private var headerPackage:uint = 0;
		private var reallyPackageLength:int = 0;
		private var version:int = 0;
		private var protocol:int = 0;
		protected var packageLength:int = 0;
		protected var socket:Socket = null;
		protected var repeatCount:int = 0;
		private var timer:Timer = null;
		private var _serverIP:String = null;
		private var _serverPort:int = 0;
		private var _channelType:String = null;
		protected var isConnectioned:Boolean = false;
		public function WebSocketChannel()
		{
			var list:Array = [];
			list.push("HTTP/1.1 101 Switching Protocols");
			list.push("upgrade: websocket");
			list.push("connection: Upgrade");
			list.push("sec-websocket-accept: Pa5OFcppdMGQ3fnoEaYno7mJPno=");
			handshaker = list.join("\r\n") + "\r\n\r\n";
			
		}
		
		
		
		public function connect(serverIP:String, serverPort:int):void
		{
			this.serverIP = serverIP;
			this.serverPort = serverPort;
			//	release();
			if (!socket)
			{
				socket = new Socket();
				socket.endian = Endian.BIG_ENDIAN;
				socket.addEventListener(Event.CLOSE, onCloseEventHandler);
				socket.addEventListener(Event.CONNECT, onConnectEventHandler);
				socket.addEventListener(IOErrorEvent.IO_ERROR, onConnectErrorHandler);
				socket.addEventListener(ProgressEvent.SOCKET_DATA, onReceiveDataHandler);
				socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
				
				timer = new Timer(5000, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			}
			socket.connect(serverIP, serverPort);
		}
		
		protected function onTimerComplete(e:TimerEvent):void
		{
			repeatCount ++;
			this.dispatchEvent(new Event(WebSocketEvent.SOCKET_REPEAT_CONNECT));
			timer.stop();
		}
		
		public function get channelType():String
		{
			return _channelType;
		}
		
		public function set channelType(value:String):void
		{
			_channelType = value;
		}
		
		public function getConnected():Boolean
		{
			return false;
		}
		
		public function get serverPort():int
		{
			return _serverPort;
		}
		
		public function set serverPort(value:int):void
		{
			_serverPort = value;
		}
		
		public function get serverIP():String
		{
			return _serverIP;
		}
		
		public function set serverIP(value:String):void
		{
			_serverIP = value;
		}
		
		private function onCloseEventHandler(e:Event):void
		{
			this.dispatchEvent(new WebSocketEvent(WebSocketEvent.CLOSE))
			close();
			if (timer)
			{
				timer.reset();
				timer.start();
			}
		}
		
		private function onConnectErrorHandler(e:IOErrorEvent):void
		{
			this.dispatchEvent(new WebSocketEvent(WebSocketEvent.IO_ERROR))
			close();
			if (timer)
			{
				timer.reset();
				timer.start();
			}
			
		}
		
		public function close():void
		{
			isConnectioned = false;
			if (!socket)
			{
				return;
			}
			if (socket.connected)
			{
				socket.flush();
				socket.close();
			}
		}
		
		private function onSecurityErrorHandler(e:SecurityErrorEvent):void
		{
			this.dispatchEvent(new WebSocketEvent(WebSocketEvent.SECURITY_ERROR))
			close();
			if (timer)
			{
				timer.reset();
				timer.start();
			}
			//executeCommand(JTChannel.SOCKET_REPEAT_CONNECT, repeatCount);
			//JTScrollMessage.showMsg(JTScrollMessage.WARN, "[JTSocketConnect.onSecurityErrorHandler]:Network Security Sandbox Errors" + e.text);
		}
		
		protected function onConnectEventHandler(e:Event):void
		{
			var headers:Array = new Array(); 
			headers.push("GET /chat HTTP/1.1\r\n"); 
			headers.push("Upgrade: websocket\r\n"); 
			headers.push("Connection: Upgrade\r\n"); 
			headers.push("Host: " + this.serverIP + ":" + this.serverPort + "\r\n"); 
			headers.push("Origin: http://action.17m3.com\r\n"); 
			headers.push("Sec-WebSocket-Key: 6z4ezNfATjW5/FEMYpqRuw==\r\n"); 
			headers.push("Sec-WebSocket-Version: 13\r\n\r\n\r\n"); 
			this.socket.writeUTFBytes(headers.join('')); 
			this.socket.flush(); 
		}
		
		protected function onReceiveDataHandler(e:ProgressEvent):void 
		{
			if (!socket || socket.bytesAvailable == 0 || socket.connected == false)
			{
				AS3Debugger.Trace("没有可用数据");
			}
			while(socket.connected && socket.bytesAvailable)
			{
				if (!isConnectioned && socket.bytesAvailable >= handshaker.length)
				{
					var content:String = socket.readUTFBytes(socket.bytesAvailable);
//					if (content == handshaker)
//					{
//						isConnectioned = true;
//						onConnectionSueecced(e);  
//					}
					isConnectioned = true;
					onConnectionSueecced(e);  
				}
				if (!isConnectioned)	return;
				if (socket.bytesAvailable < 2) return;
				if (headerPackage == 0)
				{
					headerPackage = socket.readUnsignedByte(); 
					packageLength = socket.readUnsignedByte();
					
				}
				if (packageLength <= 125)
				{
					if (packageLength > socket.bytesAvailable)
					{
						return;
					}
					readBufferComplete(socket.readUTFBytes(packageLength)); 
				}
				else if (packageLength == 126)
				{
					if (reallyPackageLength == 0)
					{
						reallyPackageLength = socket.readUnsignedShort();
					}
					if(reallyPackageLength > socket.bytesAvailable) 
					{ 
						return;
					}
					readBufferComplete(socket.readUTFBytes(reallyPackageLength)); 
				}
			}
		}
		
		
		private function readBufferComplete(content:String):void 
		{ 
			/*	var receivePackage:JTReceivePackage = new JTReceivePackage();
			receivePackage.writeUTF(content);*/
			
			var evt:WebSocketEvent = new WebSocketEvent(WebSocketEvent.SOCKET_DATA);
			evt.receivPacakge = content;
			this.dispatchEvent(evt);
			//executeReceivePackage(receivePackage);
//			AS3Debugger.Trace(content);//收完一个完整包，要处理的逻辑...
			this.headerPackage = 0;
			this.packageLength = 0;
			this.reallyPackageLength = 0;
		} 
		
		private function onConnectionSueecced(e:Event):void
		{
			repeatCount = 0;
			isConnectioned = true;
//			JTLogger.info("[JTSocketConnect.onConnectEventHandler]:socket To The Server Success!");
			
			this.dispatchEvent(new WebSocketEvent(WebSocketEvent.CONNECT));
		}
		
		public function send(content:String):void
		{
			if (!socket || !socket.connected)
			{
				//	this.addSendPackageList(sendPackage);
//				JTLogger.warn("[JTSocketConnection.send]Socket DisConnect, Request Server Failed!");
				//	JTFunctionManager.executeFunction(JTChannel.SOCKET_DISCONNECT, "Socket DisConnect, Request Server Failed!");
				return;
			}
			var dataBytes:ByteArray = new ByteArray();
			dataBytes.writeUTFBytes(content);
			var socketFrame:WebSocketFrame = new WebSocketFrame();
			socketFrame.opcode = 0x01;
			socketFrame.payload = dataBytes;
			sendFrame(socketFrame);
			//logger(sendPackage);
		}
		
		private function sendFrame(frame:WebSocketFrame):Boolean
		{
			
			var plength:uint = frame.payload.length;
			var mask:ByteArray = new ByteArray();
			for (var i:int = 0; i < 4; i++) 
			{
				mask.writeByte(randomInt(0, 255));
			}
			var buffer:ByteArray = new ByteArray();
			buffer.writeByte((frame.fin ? 0x80 : 0x00) | (frame.rsv << 4) | frame.opcode);
			if (plength <= 125)
			{
				buffer.writeByte(0x80 | plength);  
			}
			else if (plength > 125 && plength < 65536)
			{
				buffer.writeByte(0x80 | 126);  
				buffer.writeShort(plength);
			} 
			else if (plength >= 65536 && plength < 4294967296)
			{
				buffer.writeByte(0x80 | 127);   
				buffer.writeUnsignedInt(0);   
				buffer.writeUnsignedInt(plength);
			}
			else
			{
				AS3Debugger.Trace("Send frame size too large");
			}
			buffer.writeBytes(mask);
			var maskedPayload:ByteArray = new ByteArray();
			maskedPayload.length = frame.payload.length;
			for (i = 0; i < frame.payload.length; i++) 
			{
				maskedPayload[i] = mask[i % 4] ^ frame.payload[i];
			}
			try 
			{
				socket.writeBytes(buffer);
				socket.writeBytes(maskedPayload);
				socket.flush();
			}
			catch (ex:Error) 
			{
				AS3Debugger.Trace("Error while sending frame: " + ex.message);
				return false;
			}
			return true;
		}
		
		private function randomInt(min:uint, max:uint):uint
		{
			return min + Math.floor(Math.random() * (Number(max) - min + 1));
		}
	}
}