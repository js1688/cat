		/**
		 * webrtc 定义
		 */
		//接收远端发送过来的消息内容回调方法,具体实现由各类型定义具体内容
		var callbackMessage = null;
		//接收远端发送过来的媒体资源回调,具体实现由各类型定义具体内容
		var callbackRemoteVideo = null;
		//本地视频流回调,具体实现由各类型对话定义
		var callbackLocalVideo = null;
		var localStream = null;//本地流存储对象
		//兼容不同浏览器客户端之间的连接
	    var PeerConnection = (window.PeerConnection || window.webkitPeerConnection00 || window.webkitRTCPeerConnection || window.mozRTCPeerConnection);
		
	    //兼容不同浏览器获取到用户媒体对象
        var getUserMedia = (navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia || navigator.mediaDevices.getUserMedia);
	    
	    //兼容不同浏览器
        var SessionDescription = (window.RTCSessionDescription || window.mozRTCSessionDescription || window.webkitRTCSessionDescription);
        //创建数据传输通道配置
        var localChannelOptions = {
    		  ordered: false,
    		  maxRetransmitTime: 3000,
    	};
        //数据通道回调方法
    	var datachannel_error = function (error) {
      	  console.log("数据传输通道建立异常:", error);
      	};
      	var datachannel_open = function () {
      	  console.log("本地数据通道建立成功");
      	};
      	var datachannel_close = function () {
        	console.log("关闭数据传输通道");
        };
      	var datachannel_message = function(event){
      		console.log(event.data);
        }
      	
      	/**
      	 * 创建webrtc
      	 * 参数1接收到文字消息处理回调实现
      	 * 参数2接收到媒体流处理回调实现
      	 */
        var createPcAndDataChannel = function(callbackMessageImpl,callbackRemoteVideoImpl){
        	var nowChannel = {"pc":null,"localChannel":null,"stream":null};
        	//创建PeerConnection实例
        	nowChannel.pc = new PeerConnection();
        	nowChannel.localChannel = nowChannel.pc.createDataChannel(localChannelOptions);//本地通道,本地通道接收由远程通道发送过来的数据
        	nowChannel.localChannel.onerror = datachannel_error;
        	nowChannel.localChannel.onopen = datachannel_open;
        	nowChannel.localChannel.onclose = datachannel_close;
        	nowChannel.localChannel.onmessage = datachannel_message;
        	nowChannel.pc.ondatachannel = pc_datachannel;
        	nowChannel.pc.onaddstream = pc_addstream;
        	nowChannel.pc.onicecandidate = pc_icecandidate;
        	callbackMessage = callbackMessageImpl;
        	callbackRemoteVideo = callbackRemoteVideoImpl;
        	nowChannel["isVideoAudio"] = false;//是否把本地视频或音频发送到了远方,关闭音频视频到时候会重新设置为false
        	return nowChannel;
        }
      	
        //客户端连接回调方法
        var downloadFileData = {'maxsize':0,'filename':null,'data':[]};//下载文件数据预存
      	var pc_datachannel = function(event) {
      		receiveChannel = event.channel;//远端的数据通道,注意,这个通道也是可以直接使用的,不过由于它是远端的数据通道,响应的消息会出现在 localChannel.onmessage里面,而不是 receiveChannel.onmessage
            receiveChannel.onmessage = function(event){
            	var msg = null
            	try{
            		msg = JSON.parse(event.data);
            	}catch(e){
            		if(downloadFileData.filename != null){
            			downloadFileData.data.push(event.data);
            			 var doneSize = 0;
            			 for(var i = 0 ; i < downloadFileData.data.length ; i++){
            				 doneSize += downloadFileData.data[i].byteLength;
            			 }
            			 if(downloadFileData.maxsize <= doneSize){//如果已完成长度 <= 最大长度,则代表传输结束
            				var fileBlob = new Blob(downloadFileData.data);
            				var anchor = document.createElement("a");
            				anchor.href = URL.createObjectURL(fileBlob);
            				anchor.download = downloadFileData.filename;
            				anchor.click();
            				downloadFileData = {'maxsize':0,'filename':null,'data':[]};//初始化
            			 }
            		}
            		return;
            	}
            	if(msg.type == 'text'){//接收的是文字传送,当作是聊天文字
            		callbackMessage(msg);
            	}else if(msg != null && msg.type == 'file'){//接收到了对方发来的即将要传送的文件信息
	       			 downloadFileData.maxsize = msg.data.fileSize;
	      			 downloadFileData.filename = msg.data.fileName;
         	    }
            }
        };
        
        var pc_addstream = function(event){//如果检测到媒体流连接到本地，将其绑定到一个video标签上输出
        	callbackRemoteVideo(event);
        };
        
        var signallingParam = {"key":"SIGNALLING_OFFER","value":{
            "event": null,
            "data": null
        },"temp":null};
        
        var pc_icecandidate = function(event){//发送ICE候选到其他客户端
            if (event.candidate !== null) {
            	signallingParam.value.data = {"candidate": event.candidate};
            	signallingParam.value.event = "_ice_candidate";
            	signallingParam.temp = event.target["remoteUserId"];//获取创建时指定它将会与哪个用户连接,如果没有 就没有
                socket.sendJson(signallingParam);
            }
        };
        
        /**
         * 发送信令 _offer _answer 类型 信令
         */
        var sendSignallingHandle = function(pc,type){
        	if(type == "_offer"){
        		pc.createOffer(function(desc){
            		pc.setLocalDescription(desc);
            		signallingParam.temp = pc["remoteUserId"];//获取创建时指定它将会与哪个用户连接,如果没有 就没有
                	signallingParam.value.data = {"sdp": desc};
            		signallingParam.value.event = type;
                    socket.sendJson(signallingParam);
            	}, function (error) {
                    console.log("发送信令失败:" + error);
                });
        	}else if(type == "_answer"){
        		pc.createAnswer(function(desc){
            		pc.setLocalDescription(desc);
            		signallingParam.temp = pc["remoteUserId"];//获取创建时指定它将会与哪个用户连接,如果没有 就没有
                	signallingParam.value.data = {"sdp": desc};
            		signallingParam.value.event = type;
                    socket.sendJson(signallingParam);
            	}, function (error) {
                    console.log("响应信令失败:" + error);
                });
        	}
        	
        }
        
        //处理发送过来的信令  temp 在群组的时候代表 回复给指定的人
        var signallingHandle = function(webRtc,value,temp){
     	   var json = JSON.parse(value);
            //如果是一个ICE的候选，则将其加入到PeerConnection中，否则设定对方的session描述为传递过来的描述
            if(json.event === "_ice_candidate" ){
            	webRtc.pc.addIceCandidate(new RTCIceCandidate(json.data.candidate));
            }else{
            	webRtc.pc.setRemoteDescription(new SessionDescription(json.data.sdp),
                	function(){
                		// 如果是一个offer，那么需要回复一个answer
                        if(json.event === "_offer") {
                        	sendSignallingHandle(webRtc.pc,"_answer",temp);
                        	//如果本地开启了视频流,并且没有向远方发送过,则向对方发送
                        	if(localStream != null && webRtc.isVideoAudio == false){
                        		openVideoAudioRemote([webRtc],true,true);
                        		webRtc.isVideoAudio = true;
                        	}
                        }
                	}
                );
            }
        }
        
        /**
         * 创建一个只有视频没有音频的流绑定到本地控件上
         * 为了防止自己能听到自己发出的声音
         */
        var openVideoAudioLocal = function(){
        	getUserMedia.call(navigator, {
                video: true,//启动视频
                audio: false//启动音频
            },function(localMediaStream) {//获取流成功的回调函数
            	localStream = localMediaStream;
            	callbackLocalVideo(localStream);
           	},function(error){
                //处理媒体流创建失败错误
                console.log("创建本地媒体对象失败:" + error);
            });
        }
        
        /**
         * 打开媒体,并发送信令
         * 可以对多个pc一起发送
         */
        var openVideoAudioRemote = function(webRtcs,is_video,is_audio){//第一个参数是否启动视频,第二个参数是否启动音频 
        	if(webRtcs.length == 0){
        		return;
        	}
            getUserMedia.call(navigator, {
                video: is_video,//启动视频
                audio: is_audio//启动音频
            },function(localMediaStream) {//获取流成功的回调函数
            	for(var i = 0 ; i < webRtcs.length ; i++){
            		webRtcs[i].stream = localMediaStream;
            		//向PeerConnection中加入需要发送的流
            		webRtcs[i].pc.addStream(webRtcs[i].stream);
                    //发送offer信令
                    sendSignallingHandle(webRtcs[i].pc,"_offer",null);
            	}
           	},function(error){
                //处理媒体流创建失败错误
                console.log("创建远程媒体对象失败:" + error);
            });
      	}
        //关闭通道
        var closeChannel = function(webRtcs){
        	closeRemoteChannelStream(webRtcs);
        	for(var i = 0 ; i < webRtcs.length ; i++){
    			webRtcs[i].localChannel.close();
    			webRtcs[i].pc.close();
    			webRtcs[i].localChannel = null;
    			webRtcs[i].pc = null;
    		}
        }
        
        //关闭远端流
        var closeRemoteChannelStream = function(webRtcs){
        	for(var i = 0 ; i < webRtcs.length ; i++){
    			if(webRtcs[i].stream != null){
        			if(webRtcs[i].stream.getVideoTracks()[0]){
        				webRtcs[i].stream.getVideoTracks()[0].stop();
        			}
        			if(webRtcs[i].stream.getAudioTracks()[0]){
        				webRtcs[i].stream.getAudioTracks()[0].stop();
        			}
        			if(webRtcs[i].stream.getTracks()[0]){
        				webRtcs[i].stream.getTracks()[0].stop();
        			}
        			webRtcs[i].pc.removeStream(webRtcs[i].stream);
        			webRtcs[i].stream = null;
        			webRtcs[i].isVideoAudio = true;
        		}
    		}
        }
        
        //关闭本地视频流
        var closeLocalStream = function(){
        	if(localStream != null){
    			if(localStream.getVideoTracks()[0]){
    				localStream.getVideoTracks()[0].stop();
    			}
    			if(localStream.getAudioTracks()[0]){
    				localStream.getAudioTracks()[0].stop();
    			}
    			if(localStream.getTracks()[0]){
    				localStream.getTracks()[0].stop();
    			}
    			localStream = null;
    		}
        }