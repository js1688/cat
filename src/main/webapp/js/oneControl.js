/**
 * 一对一对话页面控制
 */
var oneWebRtc = null;//一对一创建的webRtc对象
$("#findOneId").on("click",function(){//搜索个人
    		var id = $("#oneId").val();
    		if(id.length != 0){
    			var param = {key:'QUERY_ID',value:id};
    			socket.sendJson(param);
    		}
});
$("#queryShow button[name='ready']").on("click",function(){//发起准备
	var id = $("#oneId").val();
	if(id.length != 0){
		var param = {key:'READY_FOR_ONE',value:id};
		socket.sendJson(param);
		$(this).toggleClass("active");
		if($(this).data("ready")){
			$("#queryShow button[name='close']").show();
			$(this).html("对话准备");
			$(this).data("ready",false);
		}else{
			$(this).html("取消准备");
			$(this).data("ready",true);
			$("#queryShow button[name='close']").hide();
		}
	}
});

//一对一接收发送过来的文字消息处理回调
var callbackMessageOneImpl = function(msg){
	showMessage("dialogForOne",msg,"left");
}
//一对一接收到媒体流,处理回调实现
var callbackRemoteVideoOneImpl = function(event){
	//$("#dialogForOne video[name='remote']").get(0).src = URL.createObjectURL(event.stream);
    var video = $("#dialogForOne video[name='remote']").get(0);
    video.srcObject = event.stream;
    video.onloadedmetadata = function(e) {
        video.play();
    };
}
//一对一本地媒体流展示,实现回调
var callbackLocalVideoOneImpl = function(stream){
	//var video = $("#dialogForOne video[name='video']").get(0); //获取到展现视频的标签
    //video.src = window.URL.createObjectURL(stream);//写入
    var video = $("#dialogForOne video[name='video']")[0]; //获取到展现视频的标签
    video.srcObject=stream;
    video.onloadedmetadata = function(e) {
        video.play();
    };
}
$("#answerShow button[name='ready']").on("click",function(){//响应准备
	var param = {key:'READY_FOR_ONE_RESPONSE',value:true};
	socket.sendJson(param);
	$("#answerShow").modal('hide');
	$("#dialogForOne").modal('show');
	$("#dialogForOne button[name='openVideo']").data("use",false);
	$("#dialogForOne button[name='openAudio']").data("use",false);
	oneWebRtc = createPcAndDataChannel(callbackMessageOneImpl,callbackRemoteVideoOneImpl);//创建webrtc对象
});
$("#answerShow button[name='close']").on("click",function(){//响应拒绝对话
	var param = {key:'READY_FOR_ONE_RESPONSE',value:false};
	socket.sendJson(param);
	$("#answerShow").modal('hide');
});

$("#dialogForOne button[name='close']").on("click",function(){//关闭对话,并且通知对方关闭对话
	closeChannel([oneWebRtc]);
	closeLocalStream();
	resetVideoButton();
	var param = {key:'ONE_CHANNEL_CLOSE',value:true};
	socket.sendJson(param);
	$("#dialogForOne ul[name='bubbleDiv']").html("");
	$("#dialogForOne").modal('hide');
	oneWebRtc = null;
});

//发送文件
$("#fileMsgForOne").on("change",function(){
	var fileData = this.files[0];
	var fileSize = fileData.size;
	var fileName = fileData.name;
	var sendMaxSize = 1000;//设定每次发送的最大字节
	var param = {'type':'file','data':{'fileSize':fileSize,'fileName':fileName}};
	oneWebRtc.localChannel.send(JSON.stringify(param));//给远方发送即将要发送的文件信息
	var fileReader = new FileReader();
	fileReader.onload = function(){//每次加载数据后则发送过去
		oneWebRtc.localChannel.send(fileReader.result);//给远方传送文件数据
		if(done < fileSize){
			tempLoad();
		}
	}
	var done = 0;
	var tempLoad = function(){
		fileReader.readAsArrayBuffer(fileData.slice(done,sendMaxSize + done));
		done = done + sendMaxSize;
	}
	tempLoad();
	$(this).val("");
});

//发送文字消息
var sendMessageOne = function(){
	if(oneWebRtc != null){
		sendMessage([oneWebRtc.localChannel],"dialogForOne");
	}
}

//点击开启视频触发事件
$("#dialogForOne button[name='openVideo']").on("click",function(){
	$(this).toggleClass("active");
	$(this).data("use",$(this).data("use") ? false : true);
	if($(this).data("use")){//开启视频语音聊天
		callbackLocalVideo = callbackLocalVideoOneImpl;
		openVideoAudioRemote([oneWebRtc],true,true);
		openVideoAudioLocal();
		$(this).find(" > span").html("结束视频");
		$("#dialogForOne button[name='openAudio']").hide();
	}else{//关闭视频语音聊天
		closeRemoteChannelStream([oneWebRtc]);
		closeLocalStream();
		resetVideoButton();
	}
});

//点击开启语音触发事件
$("#dialogForOne button[name='openAudio']").on("click",function(){
	$(this).toggleClass("active");
	$(this).data("use",$(this).data("use") ? false : true);
	if($(this).data("use")){//开启语音聊天
		openVideoAudioRemote([oneWebRtc],false,true);
		$(this).find(" > span").html("结束语音");
		$("#dialogForOne button[name='openVideo']").hide();
	}else{//关闭语音聊天
		closeRemoteChannelStream([oneWebRtc]);
		closeLocalStream();
		resetVideoButton();
	}
});
//----------------- websocket 消息类型处理逻辑-------------------------
var QUERY_ID = function(message){
	var label = $("#queryShow label[name='show']");
	var value = message.value ? '可发起对话' : '不可发起对话';
	var color = message.value ? 'green' : 'red';
	label.css({'color':color});
	label.html(value);
	var ready = $("#queryShow button[name='ready']");
	if(message.value){
		ready.show();
	}else{
		ready.hide();
	}
	$("#queryShow").modal('show');
}
var READY_FOR_ONE = function(message){
	$("#answerShow label[name='show']").html("接收到［" + message.value + "］发来的对话请求");
	$("#dialogForOne label[name='name']").html(message.value);
	$("#answerShow").modal('show');
}
var READY_FOR_ONE_RESPONSE = function(message){
	var value = JSON.parse(message.value);
	$("#queryShow").modal('hide');
	if(value.status){//开始调用webrtc打开一对一对话
		$("#dialogForOne label[name='name']").html(value.answerId);
		$("#dialogForOne").modal('show');
		$("#dialogForOne button[name='openVideo']").data("use",false);
		$("#dialogForOne button[name='openAudio']").data("use",false);
		oneWebRtc = createPcAndDataChannel(callbackMessageOneImpl,callbackRemoteVideoOneImpl);//创建webrtc对象
		//发送offer信令
		sendSignallingHandle(oneWebRtc.pc,"_offer");
	}else{
		$("#dialogForOne").modal('hide');
		alert(value.msg);
	}
	$("#queryShow button[name='ready']").html("对话准备");
	$("#queryShow button[name='ready']").data("ready",false);
	$("#queryShow button[name='ready']").toggleClass("active");
}
var SIGNALLING_ONE_ANSWER = function(message){
	signallingHandle(oneWebRtc,message.value);
}
var ONE_CHANNEL_CLOSE = function(message){
	if(message.value){
		closeChannel([oneWebRtc]);
		closeLocalStream();
		resetVideoButton();
		$("#dialogForOne ul[name='bubbleDiv']").html("");
		$("#dialogForOne").modal('hide');
		oneWebRtc = null;
	}
}