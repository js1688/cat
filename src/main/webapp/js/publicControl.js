/**
 * 公共页面控制
 * 不带具体业务的
 */
$('#query-tabs li:eq(0) a').tab('show');//个人 群组 切换事件

alert("请使用谷歌浏览器,并且电脑有麦克风,摄像头等设备,可以开两个浏览器模拟聊天。有兴趣的可以关注一下我github上的第二个项目,12306自动抢票,python语言");

//添加好友发送的内容到聊天面板 is_i的参数为 left 或者 right  left代表别人说的话,right代表自己说的话 showId代表添加到哪个聊天框框去
var showMessage = function(showId,message,is_i){
	var li = $('<li class="bubbleItem clearfix">');
	var img = $('<img src="https://tse4-mm.cn.bing.net/th?id=OIP.hfxD_t92dafBqI_1EADiHAHaFG&p=0&o=5&pid=1.1" height="35px;" style="float: '+is_i+';">');
	var span = $('<span class="bubble '+is_i+'Bubble">');
	var you_msg = $('<span>');
	you_msg.html(message.data);
	span.append(you_msg);
	var bottomLevel = $('<span class="bottomLevel">');
	span.append(bottomLevel);
	var bottomLevel = $('<span class="topLevel">');
	span.append(bottomLevel);
	li.append(img);
	var div = $("<div style='float:"+is_i+";max-width: 60%;'>");
	var name = $('<label style="font-size:12px;float:'+is_i+';margin-'+is_i+':10px;">昵称［'+message.id+'］</label>');
	div.append(name);
	div.append($('<br/>'));
	div.append(span);
	li.append(div);
	$("#"+showId+" ul[name='bubbleDiv']").append(li);
}

//发送消息事件
var sendMessage = function(localChannels,messageTextId){
	var message = $("#"+messageTextId+" textarea[name='message']");
	if(!message.val()){
		return;
	}
	var param = {'type':'text','data':message.val(),'id':$("#identity").html()};
	showMessage(messageTextId,param,"right");
	for(var i = 0 ; i < localChannels.length ; i++){
		localChannels[i].send(JSON.stringify(param));
	}
	message.val("");
}

//重置启动视频,音频 按钮
var resetVideoButton = function(){
	var openVideo = $("button[name='openVideo']");
	var openAudio = $("button[name='openAudio']");
	openVideo.find(" > span").html("开始视频");
	openAudio.show();
	openAudio.find(" > span").html("开始语音");
	openVideo.show();
	openVideo.removeClass("active");
	openAudio.removeClass("active");
}
//通用触发发送文字
var pubSendMessage = function(){
	sendMessageFive();
	sendMessageOne();
}
//回车
$(document).keyup(function(event){
	  if(event.keyCode ==13){
		  pubSendMessage();
	  }
});

//------------------websocket 消息类型处理逻辑
var PERSONAL_ID = function(message){
	$("#identity").html(message.value);
}
