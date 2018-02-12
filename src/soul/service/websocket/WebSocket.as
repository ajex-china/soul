package soul.service.websocket { 
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	
	import soul.debug.AS3Debugger;

	public class WebSocket extends Sprite { 
		private var debugEnabled:Boolean; 
		private var movieName:String; 
		private var handlers:String; 
		private var server:String; 
		private var port:Number; 
		private var isDebug:Number; 
		private var socket:Socket; 
		private var socketBuffer:ByteArray = new ByteArray(); 
		public function WebSocket(movieName:String,handlers:String,server:String,port:Number,isDebug:Number = 0) { 
//			Security.allowDomain("*"); 
//			var counter:Number = 0; 
//			root.addEventListener(Event.ENTER_FRAME, function ():void { if (++counter > 100) counter = 0; }); 
//			this.movieName = root.loaderInfo.parameters.movieName; 
//			this.handlers = root.loaderInfo.parameters.handlers; 
//			this.server = root.loaderInfo.parameters.server; 
//			this.port = root.loaderInfo.parameters.port; 
//			this.isDebug = root.loaderInfo.parameters.debug; 
			this.movieName = movieName; 
			this.handlers = handlers; 
			this.server = server; 
			this.port = port; 
			this.isDebug = isDebug; 
			this.debug(this.port+''+this.server); 
//			try { 
//				this.debugEnabled = root.loaderInfo.parameters.debugEnabled == "true" ? true : false; 
//			} catch (ex:Object) { 
//				this.debugEnabled = false; 
//			} 
			this.connectServer(); 
//			ExternalInterface.addCallback("sendData", this.sendData); 
		} 
		public function connectServer():void { 
			socket = new Socket(); 
			socket.endian = Endian.BIG_ENDIAN; 
			socket.addEventListener(Event.CONNECT, onConnect); 
			socket.addEventListener(Event.CLOSE, onClose); 
			socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError); 
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError); 
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData); 
			socket.connect(this.server, this.port); 
			this.socket = socket; 
		} 
		public function onConnect(e:Event):void { 
			//握手 
			var headers:Array = new Array(); 
			headers.push("GET /chat HTTP/1.1\r\n"); 
			headers.push("Upgrade: websocket\r\n"); 
			headers.push("Connection: Upgrade\r\n"); 
			headers.push("Host: "+this.server+":"+this.port+"\r\n"); 
			headers.push("Origin: null\r\n"); 
			headers.push("Sec-WebSocket-Key: 6z4ezNfATjW5/FEMYpqRuw==\r\n"); 
			headers.push("Sec-WebSocket-Version: 13\r\n\r\n\r\n"); 
			this.socket.writeUTFBytes(headers.join('')); 
			this.socket.flush(); 
		} 
		public function onTrueConnect():void { 
//			ExternalInterface.call(this.handlers+".onConnect",this.movieName); 
			this.dispatchEvent(new WebSocketEvent(WebSocketEvent.CONNECT));
//			AS3Debugger.Trace("TrueConnect");
		} 
		public function onClose(e:Event):void {
			this.dispatchEvent(e);
//			ExternalInterface.call(this.handlers+".onClose",this.movieName,'1'); 
//			AS3Debugger.Trace("Close");
		} 
		public function onIOError(e:IOErrorEvent):void { 
			this.dispatchEvent(e);
//			ExternalInterface.call(this.handlers+".onClose",this.movieName,'2'); 
//			AS3Debugger.Trace("IOError");
		} 
		public function onSecurityError(e:SecurityErrorEvent):void { 
			this.dispatchEvent(e);
//			ExternalInterface.call(this.handlers+".onClose",this.movieName,'3'); 
//			AS3Debugger.Trace("SecurityError");
		} 
		public var step:String = "head"; 
		public var position:Number = 0; 
		public function readOnData():void { 
			var tmpPos:Number = this.position; 
			this.socketBuffer.position = this.position; 
			//read 一个 0x81 
			if(this.socketBuffer.bytesAvailable>=1) { 
				var h:Number = this.socketBuffer.readUnsignedByte(); 
				this.debug("头:"+h); 
				this.position += 1; 
				if(this.socketBuffer.bytesAvailable>=1) { 
					var len:Number = this.socketBuffer.readUnsignedByte(); 
					this.debug("长度:"+len); 
					this.position += 1; 
					if(len<=125) { 
						if(this.socketBuffer.bytesAvailable>=len) { 
							this.onText(this.socketBuffer.readUTFBytes(len)); 
							this.position += len; 
							this.readOnData(); 
						} else { 
							this.position = tmpPos; 
							return; 
						} 
					} else if(len==126) { 
						if(this.socketBuffer.bytesAvailable>=2) { 
							var trueLen:Number = this.socketBuffer.readUnsignedShort(); 
							if(this.socketBuffer.bytesAvailable>=trueLen) { 
								this.onText(this.socketBuffer.readUTFBytes(trueLen)); 
								this.position += trueLen + 2; 
								this.readOnData(); 
							} 
						} else { 
							this.position = tmpPos; 
							return; 
						} 
					} 
				} else { 
					this.position = tmpPos; 
					return; 
				} 
			} else { 
				this.position = tmpPos; 
				return; 
			} 
		} 
		public function onText(text:String):void { 
//			ExternalInterface.call(this.handlers+".onData",this.movieName,text); 
			var event:WebSocketEvent = new WebSocketEvent(WebSocketEvent.SOCKET_DATA);
			event.data = text;
			this.dispatchEvent(event);
//			AS3Debugger.Trace(text);
		} 
		public function writeBytes(bytes:ByteArray):void { 
			this.socketBuffer.position = this.socketBuffer.length; 
			this.socketBuffer.writeBytes(bytes,0,bytes.length); 
			this.debug("buffer数据:"+this.socketBuffer.length); 
			this.readOnData(); 
		} 
		public var is_head:Boolean = true; 
		public var header:ByteArray = new ByteArray(); 
		public var headers:Array = new Array(); 
		public function onSocketData(e:Event):void { 
			this.socketBuffer.clear();
			this.position = 0;
			var bytes:ByteArray = new ByteArray(); 
			if(this.is_head) { 
				while(this.socket.bytesAvailable) { 
					var x:Number = this.socket.readUnsignedByte(); 
					if(x==0x81) { 
						this.is_head = true; 
						bytes.writeByte(0x81); 
						this.debug(this.headers); 
						break; 
					} else { 
						this.header.writeByte(x); 
						if(x==10) { 
							this.header.position = 0; 
							this.headers.push(this.header.readUTFBytes(this.header.length)); 
							if(this.header.length==2) { 
								this.onTrueConnect(); 
							} 
							this.header = new ByteArray(); 
						} 
						continue; 
					} 
				} 
				if(this.socket.bytesAvailable) { 
					this.socket.readBytes(bytes,1,this.socket.bytesAvailable); 
				} 
			} else { 
				this.socket.readBytes(bytes,0,this.socket.bytesAvailable); 
			} 
			bytes.position = 0; 
			this.writeBytes(bytes); 
		} 
		public function sendData(text:String):void { 
//			AS3Debugger.Trace("send:" + text)
			var head:ByteArray = new ByteArray(); 
			head.writeByte(0x81); 
			var body:ByteArray = new ByteArray(); 
			body.writeUTFBytes(text); 
			var len:Number = body.length; 
			if(len<=125) { 
				head.writeByte(len); 
			} else if(len<65536){ 
				head.writeByte(126); 
				head.writeShort(len); 
			} else { 
				head.writeByte(127); 
				head.writeUnsignedInt(len); 
			} 
			body.position = 0; 
			head.position = 0; 
			this.socket.writeBytes(head); 
			this.socket.writeBytes(body); 
			this.socket.flush(); 
		} 
		public function debug(str:*):void { 
//			AS3Debugger.Trace(str);
			if(this.isDebug) { 
//				ExternalInterface.call(this.handlers+".debug",this.movieName,str); 
//				AS3Debugger.Trace(str);
				this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,str));
			} 
		} 
		public function send(encData:String):int {
//			var data:String;
//			try {
//				data = decodeURIComponent(encData);
//			} catch (ex:URIError) {
//				AS3Debugger.Trace("SYNTAX_ERR: URIError in send()");
//				return 0;
//			}
			var data:String = encData;
//			AS3Debugger.Trace("send: " + data);
			var dataBytes:ByteArray = new ByteArray();
			dataBytes.writeUTFBytes(data);
			var frame:WebSocketFrame = new WebSocketFrame();
			frame.opcode = 0x01;
			frame.payload = dataBytes;
			sendFrame(frame)
			return 0;
		}
		
		private function sendFrame(frame:WebSocketFrame):Boolean {
			
			var plength:uint = frame.payload.length;
			
			// Generates a mask.
			var mask:ByteArray = new ByteArray();
			for (var i:int = 0; i < 4; i++) {
				mask.writeByte(randomInt(0, 255));
			}
			
			var header:ByteArray = new ByteArray();
			// FIN + RSV + opcode
			header.writeByte((frame.fin ? 0x80 : 0x00) | (frame.rsv << 4) | frame.opcode);
			if (plength <= 125) {
				header.writeByte(0x80 | plength);  // Masked + length
			} else if (plength > 125 && plength < 65536) {
				header.writeByte(0x80 | 126);  // Masked + 126
				header.writeShort(plength);
			} else if (plength >= 65536 && plength < 4294967296) {
				header.writeByte(0x80 | 127);  // Masked + 127
				header.writeUnsignedInt(0);  // zero high order bits
				header.writeUnsignedInt(plength);
			} else {
				AS3Debugger.Trace("Send frame size too large");
			}
			header.writeBytes(mask);
			
			var maskedPayload:ByteArray = new ByteArray();
			maskedPayload.length = frame.payload.length;
			for (i = 0; i < frame.payload.length; i++) {
				maskedPayload[i] = mask[i % 4] ^ frame.payload[i];
			}
			
			try {
				socket.writeBytes(header);
				socket.writeBytes(maskedPayload);
				socket.flush();
			} catch (ex:Error) {
				AS3Debugger.Trace("Error while sending frame: " + ex.message);
				return false;
			}
			return true;
			
		}
		private function randomInt(min:uint, max:uint):uint {
			return min + Math.floor(Math.random() * (Number(max) - min + 1));
		}
	} 
} 