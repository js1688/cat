		/**
		 * 五人群组控制
		 */
		var fiveWebRtc = {};//五人群组创建的webRtc对象
		$("#createGroup").on("click",function(){//点击创建五人群组
    		var param = {key:'CREATE_GROUP_FIVE'};
			socket.sendJson(param);
    	});
    	$("#dialogForFive button[name='close']").on("click",function(){//关闭对话,并且通知对方关闭对话
    		var pcs = [];
    		for(var key in fiveWebRtc){//关闭与每个远端的通道
    			pcs.push(fiveWebRtc[key]);
    			delete fiveWebRtc[key];
    		}
    		closeChannel(pcs);
    		closeLocalStream();
    		var param = {key:'EXIT_GROUP_FIVE'};
			socket.sendJson(param);
			$("#dialogForFive ul[name='bubbleDiv']").html("");
    		$("#dialogForFive").modal('hide');
    		resetVideoButton();
    	});
    	$("#findFiveId").on("click",function(){//搜索五人群组
    		var id = $("#fiveId").val();
    		if(id.length != 0){
    			var param = {key:'QUERY_GROUP_FIVE',value:id};
    			socket.sendJson(param);
    		}
    	});
    	
    	//五人群组接收发送过来的文字消息处理回调
    	var callbackMessageFiveImpl = function(msg){
    		showMessage("dialogForFive",msg,"left");
    	}
    	//五人群组接收到媒体流,处理回调实现
    	var callbackRemoteVideoFiveImpl = function(event){
    		var remotes = $("#dialogForFive video[name='remote']");
    		for(var i = 0 ; i < remotes.length ; i++){
    			if($(remotes[i]).data("remoteId") == event.target.remoteUserId){//找到占用的视频位置
    				$(remotes[i]).get(0).src = URL.createObjectURL(event.stream);
    				break;
    			}
    		}
    	}
    	//五人群组本地媒体流展示,实现回调
    	var callbackLocalVideoFiveImpl = function(stream){
    		var video = $("#dialogForFive video[name='video']").get(0); //获取到展现视频的标签
    	    video.src = window.URL.createObjectURL(stream);//写入
    	}
    	
    	//发送文件
    	$("#fileMsgForFive").on("change",function(){
    		var fileData = this.files[0];
    		var fileSize = fileData.size;
    		var fileName = fileData.name;
    		var sendMaxSize = 1000;//设定每次发送的最大字节
    		var param = {'type':'file','data':{'fileSize':fileSize,'fileName':fileName}};
    		for(var key in fiveWebRtc){
    			fiveWebRtc[key].localChannel.send(JSON.stringify(param));//给远方发送即将要发送的文件信息
    		}
    		for(var i = 0; i < fiveWebRtc.length; i++){
    			
    		}
    		var fileReader = new FileReader();
    		fileReader.onload = function(){//每次加载数据后则发送过去
    			for(var key in fiveWebRtc){
    				fiveWebRtc[key].localChannel.send(fileReader.result);//给每个远方传送文件数据
    			}
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
    	var sendMessageFive = function(){
    		var localChannels = [];
    		for(var key in fiveWebRtc){
    			localChannels.push(fiveWebRtc[key].localChannel);
    		}
    		sendMessage(localChannels,"dialogForFive");
    	}
    	
    	//点击开启视频触发事件
    	$("#dialogForFive button[name='openVideo']").on("click",function(){
    		$(this).toggleClass("active");
    		$(this).data("use",$(this).data("use") ? false : true);
    		var pcs = [];
    		for(var key in fiveWebRtc){//给每个远端发送本地视频流
    			pcs.push(fiveWebRtc[key]);
    		}
    		if($(this).data("use")){//开启视频语音聊天
    			callbackLocalVideo = callbackLocalVideoFiveImpl;
    			openVideoAudioRemote(pcs,true,true);
        		openVideoAudioLocal();
    			$(this).find(" > span").html("结束视频");
    			$("#dialogForFive button[name='openAudio']").hide();
    		}else{//关闭视频语音聊天
    			closeRemoteChannelStream(pcs);
    			closeLocalStream()
    			resetVideoButton();
    		}
    	});

    	//点击开启语音触发事件
    	$("#dialogForFive button[name='openAudio']").on("click",function(){
    		$(this).toggleClass("active");
    		$(this).data("use",$(this).data("use") ? false : true);
    		var pcs = [];
    		for(var key in fiveWebRtc){//给每个远端发送本地视频流
    			pcs.push(fiveWebRtc[key]);
    		}
    		if($(this).data("use")){//开启语音聊天
    			openVideoAudioRemote(pcs,false,true);
    			$(this).find(" > span").html("结束语音");
    			$("#dialogForFive button[name='openVideo']").hide();
    		}else{//关闭语音聊天
    			closeRemoteChannelStream(pcs);
    			closeLocalStream()
    			resetVideoButton();
    		}
    	});
    	//----------------- websocket 消息类型处理逻辑-------------------------
    	var CREATE_GROUP_FIVE = function(message){
    		$("#dialogForFive label[name='name']").html(message.value);
			$("#dialogForFive").modal('show');
    	}
    	var QUERY_GROUP_FIVE = function(message){
    		if(message.value != null){
    			var value = JSON.parse(message.value);
				$("#dialogForFive label[name='name']").html(value.homeId);
				$("#dialogForFive").modal('show');
				//创建房间内其他几个人的pc
				for(var i = 0 ; i < value.userIds.length ; i++){
					var webrtc = createPcAndDataChannel(callbackMessageFiveImpl,callbackRemoteVideoFiveImpl);//创建webrtc对象
					fiveWebRtc[value.userIds[i]] = webrtc;
					fiveWebRtc[value.userIds[i]].pc["remoteUserId"] = value.userIds[i];//这个比较重要,设置一个pc 它将会与哪个用户建立连接
					sendSignallingHandle(fiveWebRtc[value.userIds[i]].pc,"_offer");//给对方发送信令
					//并且给他们占用视频位置
	    			var remotes = $("#dialogForFive video[name='remote']");
	        		for(var i = 0 ; i < remotes.length ; i++){
	        			if($(remotes[i]).data("remoteId") != value.userIds[i] && !$(remotes[i]).data("remoteId")){//原来没有绑定过 并且 还未绑定视频流
	        				$(remotes[i]).data("remoteId",value.userIds[i]);
	        				var name = $(remotes[i]).data("name");
	        				$("#dialogForFive label[name='"+name+"']").html(value.userIds[i]);
	        				break;
	        			}
	        		}
				}
			}else{
				alert("搜索的群组人员已满或不存在");
			}
    	}
    	var SIGNALLING_FIVE_ANSWER = function(message){
    		//接收到其他人发送过来的信令
    		var value = JSON.parse(message.value);
    		fiveWebRtc[value.sendUserId].pc["remoteUserId"] = value.sendUserId;//这个比较重要,设置一个pc 它将会与哪个用户建立连接
    		signallingHandle(fiveWebRtc[value.sendUserId],value.msg);
    	}
    	var GROUP_FIVE_ADD_USER = function(message){
    		//有人加入了所在房间,创建与它的pc
    		if(!fiveWebRtc[message.value]){
    			var webrtc = createPcAndDataChannel(callbackMessageFiveImpl,callbackRemoteVideoFiveImpl);//创建webrtc对象
    			fiveWebRtc[message.value] = webrtc;
    			//并且给他占个视频位置
    			var remotes = $("#dialogForFive video[name='remote']");
        		for(var i = 0 ; i < remotes.length ; i++){
        			if($(remotes[i]).data("remoteId") != message.value && !$(remotes[i]).data("remoteId")){//原来没有绑定过 并且 还未绑定视频流
        				$(remotes[i]).data("remoteId",message.value);
        				var name = $(remotes[i]).data("name");
        				$("#dialogForFive label[name='"+name+"']").html(message.value);
        				break;
        			}
        		}
    		}
    	}
    	var EXIT_GROUP_FIVE = function(message){
    		var remotes = $("#dialogForFive video[name='remote']");
    		for(var i = 0 ; i < remotes.length ; i++){
    			if(!fiveWebRtc[message.value]){
    				continue;
    			}
    			closeChannel([fiveWebRtc[message.value]]);
    			delete fiveWebRtc[message.value];
    			if($(remotes[i]).data("remoteId") == message.value){
    				$(remotes[i]).data("remoteId","");
    				var name = $(remotes[i]).data("name");
    				$("#dialogForFive label[name='"+name+"']").html("空闲");
    				break;
    			}
    		}
    	}