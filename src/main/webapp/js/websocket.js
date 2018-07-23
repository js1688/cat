/**
 * websocket定义
 */

/**
 * 处理websocket接收到的消息
 * 根据不同的消息类型执行不同的逻辑方法
 */
var socket_onmessage = function(event){
	var message = JSON.parse(event.data);
	if(message.key == "PERSONAL_ID"){//处理后台返回的身份编码
		PERSONAL_ID(message);
	}else if(message.key == "QUERY_ID"){//处理发来的搜索个人结果
		QUERY_ID(message);
	}else if(message.key == "READY_FOR_ONE"){//接收到其他人发送过来的准备请求
		READY_FOR_ONE(message);
	}else if(message.key == "READY_FOR_ONE_RESPONSE"){//接收到一对一对话结果响应
		READY_FOR_ONE_RESPONSE(message);
	}else if(message.key == 'SIGNALLING_ONE_ANSWER'){//处理一对一来到的响应信令
		SIGNALLING_ONE_ANSWER(message);
	}else if(message.key == 'ONE_CHANNEL_CLOSE'){//处理一对一远端发来的结束对话通知
		ONE_CHANNEL_CLOSE(message);
	}else if(message.key == 'CREATE_GROUP_FIVE'){//创建五人群组结果
		CREATE_GROUP_FIVE(message);
	}else if(message.key == 'QUERY_GROUP_FIVE'){//加入五人群组结果
		QUERY_GROUP_FIVE(message);
	}else if(message.key == 'SIGNALLING_FIVE_ANSWER'){//五人组应答者信令
		SIGNALLING_FIVE_ANSWER(message);
	}else if(message.key == 'GROUP_FIVE_ADD_USER'){//五人组有人进入房间
		GROUP_FIVE_ADD_USER(message);
	}else if(message.key == 'EXIT_GROUP_FIVE'){//五人组有人退出房间
		EXIT_GROUP_FIVE(message);
	}
}

var socket = new WebSocket("wss://www.tanjun.xyz/cat/index");
//var socket = new WebSocket("ws://127.0.0.1:8080/cat/index");
		
socket.onopen = function(){
	console.log("WebSocket,建立连接成功");
}; 
socket.onclose = function(event){
	console.log("WebSocket,已关闭");
}; 
socket.onerror = function(event){
	console.log("WebSocket,异常");
};

socket.onmessage = socket_onmessage;

socket["sendJson"] = function(param){
	socket.send(JSON.stringify(param));
}