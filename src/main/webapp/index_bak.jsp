<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css">
    
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.slim.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <title>前端源码</title>
    <style>
    	html,body{
    		height: 100%; 
    		width:100%;
    		padding: 0px;
    		margin: 0px;
    		background-color: #000000;
    	}
    	span{
    		cursor:pointer;
    	}
    	/*默认滚动条样式*/
		::-webkit-scrollbar {
		    width: 8px;
		    height: 8px;
		}
		::-webkit-scrollbar-track {
		    border: 1px #d3d3d3 solid;
		    box-shadow: 0px 0px 3px #dfdfdf inset;
		    border-radius: 10px;
		    background: #eee;
		}
		::-webkit-scrollbar-thumb {
		    border: 1px #808080 solid;
		    border-radius: 10px;
		    background: #999;
		}
		::-webkit-scrollbar-thumb:hover {
		    background: #7d7d7d;
		}
		/* 圆角尖角聊天框样式*/
    	.bubbleDiv{  
		    width: 100%;
		    height: auto;
		    margin: 0px;
		    padding: 0px;
		}  
		.bubbleItem{  
		    width: 100%;  
		    list-style:none;
		    margin: 0px;
		    padding: 5px;
		}  
		.bubble{  
		    max-width: 60%;  
		    position: relative;  
		    line-height: 30px;  
		    border-radius: 7px;  
		    display: inline-block;  
		    padding-left: 10px;
		    padding-right: 10px;
		}  
		.leftBubble{  
		    position: relative;  
		    margin-left: 15px;  
		    float:left;
		    border: 1px solid #00b6b6;  
		    background-color: #f8fdfc;  
		}  
		.leftBubble .bottomLevel{  
		    position: absolute;  
		    top: 10px;  
		    left: -10px;  
		    border-top: 10px solid #00b6b6;  
		    border-left: 10px solid transparent;  
		}  
		.leftBubble .topLevel{  
		    position: absolute;  
		    top: 11px;  
		    left: -8px;  
		    border-top: 10px solid #f8fdfc;  
		    border-left: 10px solid transparent;  
		    z-index: 100;  
		}
		.rightBubble{  
		    position: relative;  
		    margin-right: 25px;  
		    float:right;
		    border: 1px solid #00b6b6;  
		    background-color: #f8fdfc;  
		}  
		.rightBubble .bottomLevel{  
		    position: absolute;  
		    top: 10px;  
		    right: -10px;  
		    border-top: 10px solid #00b6b6;  
		    border-right: 10px solid transparent;  
		}  
		.rightBubble .topLevel{  
		    position: absolute;  
		    top: 11px;  
		    right: -8px;  
		    border-top: 10px solid #f8fdfc;  
		    border-right: 10px solid transparent;  
		    z-index: 100;  
		}
		.clearfix:after {  
		    visibility: hidden;  
		    display: block;  
		    font-size: 0;  
		    content: " ";  
		    clear: both;  
		    height: 0;  
		}
    </style>
</head>
<body style="overflow-y:auto;">
		 <label style="color: #FFFFFF;">个人编号［<label id="identity"></label>］</label>
		 <div style="position:absolute;top: 160px;left: 345px;width: 650px;">
		    <ul id="query-tabs" class="nav nav-tabs">
			 	<li><a href="#friend" data-toggle="tab"><i class="glyphicon glyphicon-user"></i> 个人</a></li>
				<li><a href="#home" data-toggle="tab"><i class="glyphicon glyphicon-home"></i> 群组</a></li>
			</ul>
			<div class="tab-content" style="margin-top: 1px;">
				<div class="tab-pane fade" id="friend" style="position:relative;height: 100%;width: 100%;">
					<div class="input-group">
			            <input type="text" class="form-control" id="personalId" placeholder="请输入需要搜索的个人编号">
			            <span class="input-group-addon" id="findPersonalId"><img src="/cat/img/ok.png" width="20px;"></span>
			        </div>
				</div>
				<div class="tab-pane fade" id="home" style="position:relative;height: 100%;width: 100%;">
					<div class="input-group">
			            <input type="text" class="form-control" placeholder="请输入需要搜索的群组编号">
			            <span class="input-group-addon"><img src="/cat/img/ok.png" width="20px;"></span>
			        </div>
				</div>
			</div>
		</div>
		
		<!-- 搜索信息弹出 -->
		<div class="modal fade" id="queryShow" data-backdrop="false" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
		        <div class="modal-content">
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <h4 class="modal-title" >搜索结果</h4>
		            </div>
		            <div class="modal-body" align="center">
		            	<label name="show"></label>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" name="close" data-dismiss="modal">关闭</button>
		                <button type="button" class="btn btn-success btn-sm" name="ready" data-ready="false">对话准备</button>
		            </div>
		        </div>
		    </div>
		</div>
		<!-- 响应对话请求弹出 -->
		<div class="modal fade" id="answerShow" data-backdrop="false" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
		        <div class="modal-content">
		            <div class="modal-header">
		                <h4 class="modal-title" >请求提示</h4>
		            </div>
		            <div class="modal-body" align="center">
		            	<label name="show"></label>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" name="close">拒绝</button>
		                <button type="button" class="btn btn-success btn-sm" name="ready" data-ready="false">对话准备</button>
		            </div>
		        </div>
		    </div>
		</div>
		<!-- 一对一对话框 -->
		<div class="modal fade" id="dialogForOne" data-backdrop="false" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog" style="width: 904px;">
		        <div class="modal-content">
		            <div class="modal-header">
		                <h4 class="modal-title">你正在与［<label name="name"></label>］对话</h4>
		            </div>
		            <!-- 聊天框 -->
		            <div class="modal-body" style="margin: 0px;padding: 0px;">
		            	<div style="height: 647px;">
		    				<!-- 聊天信息展示 -->
		    				<div style="width: 600px;height: 647px;float: left;">
			    				<div style="overflow-y:auto;height: 500px;">
			    					<!-- 每一条聊天记录都加在 li里面 -->
			    					<ul class="bubbleDiv" name="bubbleDiv"></ul>
			    				</div>
			    				<!-- 聊天输入 -->
			    				<div style="height: 166px;">
			    					<!-- 功能框 -->
			    					<div style="height: 16px;">
			    						<!-- 发送附件功能 -->
			    						<div style="margin-left: 5px;">
				    						<label for="fileMsg">
				    							<span><i class="glyphicon glyphicon-link"></i></span>
				    						</label>
				    						<form><input type="file" id="fileMsg" style="position:absolute;clip:rect(0 0 0 0);"></form>
			    						</div>
			    					</div>
			    					<!-- 输入框 -->
			    					<div style="height: 131px;width: 100%;">
			    						<textarea id = "message" style="width: 100%;height: 100%;resize:none;border: 0px;background-color: #EEEEEE;" placeholder="请输入需要发送的内容"></textarea>
			    					</div>
			    				</div>
		    				</div>
		    				<!-- 右侧视频语音聊天展示 -->
				    		<div style="width: 300px;height: 647px;float: left;">
				    			<!-- 本地视频框 -->
				    			<div class="panel panel-default" style="margin: 0px;padding: 0px;">
								    <div class="panel-body">
								       <video style="height:250px;width:250px;margin: 0px;padding: 0px;" id="video" autoplay></video>
								    </div>
								    <div class="panel-footer" align="center">
								    	<button type="button" class="btn btn-default btn-lg btn-xs" id="openVideo" data-use="false"><i class="glyphicon glyphicon-facetime-video"></i> <span>开始视频</span></button>
								    	<button type="button" class="btn btn-default btn-lg btn-xs" id="openAudio" data-use="false"><i class="glyphicon glyphicon-earphone"></i> <span>开始语音</span></button>
								    </div>
								</div>
								<!-- 远端视频框 -->
				    			<div class="panel panel-default" style="margin: 0px;padding: 0px;">
								    <div class="panel-body">
								        <video style="height:250px;width:250px;" id="remote" autoplay></video>
								    </div>
								    <div class="panel-footer" align="center">
								    	好友视频展示
								    </div>
								</div>
				    		</div>
				    	</div>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" name="close">关闭对话</button>
		                <button type="button" class="btn btn-success" onclick="sendMsg()">发送消息</button>
		            </div>
		        </div>
		    </div>
		</div>
	<!-- 前端控制处理 -->
    <script type="text/javascript">
    	$('#query-tabs li:eq(0) a').tab('show');//个人 群组 切换事件
    	//接收到服务端发送过来的消息,做相应的逻辑处理
    	var socket_onmessage = function(event){
			var message = JSON.parse(event.data);
			if(message.key == "PERSONAL_ID"){//处理发来的身份编码
				$("#identity").html(message.value);
			}else if(message.key == "QUERY_ID"){//处理发来的搜索个人结果
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
			}else if(message.key == "READY_FOR_ONE"){//接收到其他人发送过来的准备请求
				$("#answerShow label[name='show']").html("接收到［" + message.value + "］发来的对话请求");
				$("#dialogForOne label[name='name']").html(message.value);
				$("#answerShow").modal('show');
			}else if(message.key == "READY_FOR_ONE_RESPONSE"){//接收到一对一对话结果响应
				var value = JSON.parse(message.value);
				$("#queryShow").modal('hide');
				if(value.status){//开始调用webrtc打开一对一对话
					$("#dialogForOne label[name='name']").html(value.answerId);
					$("#dialogForOne").modal('show');
					createPcAndDataChannel();//创建webrtc对象
					//发送offer信令
		            pc.createOffer(sendOfferFn, function (error) {
		                console.log("发送信令offer失败:" + error);
		            });
				}else{
					$("#dialogForOne").modal('hide');
					alert(value.msg);
				}
				$("#queryShow button[name='ready']").html("对话准备");
				$("#queryShow button[name='ready']").data("ready",false);
				$("#queryShow button[name='ready']").toggleClass("active");
			}else if(message.key == 'SIGNALLING_ANSWER'){//处理来到的信令
				answer(message.value);
			}else if(message.key == 'ONE_CHANNEL_CLOSE'){//远端发来的结束对话通知
				if(message.value){
					closeChannel();
					$("#dialogForOne ul[name='bubbleDiv']").html("");
					$("#dialogForOne").modal('hide');
				}
			}
		}
    	$("#findPersonalId").on("click",function(){//搜索个人
    		var id = $("#personalId").val();
    		if(id.length != 0){
    			var param = {key:'QUERY_ID',value:id};
    			socket.sendJson(param);
    		}
    	});
    	$("#queryShow button[name='ready']").on("click",function(){//发起准备
    		var id = $("#personalId").val();
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
    	$("#answerShow button[name='ready']").on("click",function(){//响应准备
    		var param = {key:'READY_FOR_ONE_RESPONSE',value:true};
			socket.sendJson(param);
			$("#answerShow").modal('hide');
			$("#dialogForOne").modal('show');
			createPcAndDataChannel();//创建webrtc对象
    	});
    	$("#answerShow button[name='close']").on("click",function(){//响应拒绝对话
    		var param = {key:'READY_FOR_ONE_RESPONSE',value:false};
			socket.sendJson(param);
			$("#answerShow").modal('hide');
    	});
    	
    	$("#dialogForOne button[name='close']").on("click",function(){//关闭对话,并且通知对方关闭对话
    		closeChannel();
    		var param = {key:'ONE_CHANNEL_CLOSE',value:true};
			socket.sendJson(param);
			$("#dialogForOne ul[name='bubbleDiv']").html("");
    		$("#dialogForOne").modal('hide');
    	});
    	
    	//彻底关闭通道
    	var closeChannel = function(){
    		receiveChannel.close();
    		localChannel.close();
    		pc.close();
    		receiveChannel = null;
    		localChannel = null;
    		pc = null;
    		if(stream != null){
    			stream.getVideoTracks()[0].stop();
    			stream.getAudioTracks()[0].stop();
    			stream = null;
    		}
    	}
    	
    	//发送消息事件
    	var sendMsg = function(){
    		var param = {'type':'text','data':$("#message").val()};
    		localChannel.send(JSON.stringify(param));
    		addYouMsg(param.data,"right");
    		$("#message").val("");
    	}
    	
    	//添加好友发送的内容到聊天面板 is_i的参数为 left 或者 right  left代表别人说的话,right代表自己说的话
    	var addYouMsg = function(message,is_i){
    		var li = $('<li class="bubbleItem clearfix">');
    		var img = $('<img src="https://img.qq1234.org/uploads/allimg/141110/3_141110174904_1.jpg" height="35px;" style="float: '+is_i+';">');
    		var span = $('<span class="bubble '+is_i+'Bubble">');
    		var you_msg = $('<span>');
    		you_msg.html(message);
    		span.append(you_msg);
    		var bottomLevel = $('<span class="bottomLevel">');
    		span.append(bottomLevel);
    		var bottomLevel = $('<span class="topLevel">');
    		span.append(bottomLevel);
    		li.append(img);
    		li.append(span);
    		$(".bubbleDiv").append(li);
    	}
    	
    	//开启媒体对象
     	var stream = null;
      	var openVideoAudio = function(is_video,is_audio){//第一个参数是否启动视频,第二个参数是否启动音频
            getUserMedia.call(navigator, {
                video: is_video,//启动视频
                audio: is_audio//启动音频
            },function(localMediaStream) {//获取流成功的回调函数
            	stream = localMediaStream;
                var video = document.getElementById('video'); //获取到展现视频的标签
                video.src = window.URL.createObjectURL(localMediaStream);//写入
              	//向PeerConnection中加入需要发送的流
                pc.addStream(stream);
                //发送offer信令
                pc.createOffer(sendOfferFn, function (error) {
                    console.log("发送信令offer失败:" + error);
                });
           	},function(error){
                //处理媒体流创建失败错误
                console.log("创建媒体对象失败:" + error);
            });
      	}
    	
    	//点击开启视频触发事件
    	$("#openVideo").on("click",function(){
    		$(this).toggleClass("active");
    		$(this).data("use",$(this).data("use") ? false : true);
    		if($(this).data("use")){//开启视频语音聊天
    			openVideoAudio(true,true);
    			$(this).find(" > span").html("结束视频");
    			$("#openAudio").hide();
    		}else{//关闭视频语音聊天
    			stream.getVideoTracks()[0].stop();
    			stream.getAudioTracks()[0].stop();
    			pc.removeStream(stream);
    			stream = null;
    			$(this).find(" > span").html("开始视频");
    			$("#openAudio").show();
    		}
    	});
    	
    	//点击开启语音触发事件
    	$("#openAudio").on("click",function(){
    		$(this).toggleClass("active");
    		$(this).data("use",$(this).data("use") ? false : true);
    		if($(this).data("use")){//开启语音聊天
    			openVideoAudio(false,true);
    			$(this).find(" > span").html("结束语音");
    			$("#openVideo").hide();
    		}else{//关闭语音聊天
    			stream.getAudioTracks()[0].stop();
    			pc.removeStream(stream);
    			stream = null;
    			$(this).find(" > span").html("开始语音");
    			$("#openVideo").show();
    		}
    	});
    	
    	//发送文件
    	$("#fileMsg").on("change",function(){
    		var fileData = this.files[0];
    		var fileSize = fileData.size;
    		var fileName = fileData.name;
    		var sendMaxSize = 1000;//设定每次发送的最大字节
    		var param = {'type':'file','data':{'fileSize':fileSize,'fileName':fileName}};
    		localChannel.send(JSON.stringify(param));//给远方发送即将要发送的文件信息
    		var fileReader = new FileReader();
    		fileReader.onload = function(){//每次加载数据后则发送过去
				localChannel.send(fileReader.result);//给远方传送文件数据
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
    </script>
    
    <!-- websocket 处理 -->
	<script type="text/javascript">
		//var socket = new WebSocket("wss://www.tanjun.xyz/cat/index");
		var socket = new WebSocket("ws://127.0.0.1:1688/cat/index");
		
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
	</script>
	
	<!-- webrtc 处理 -->
	<script type="text/javascript">
		//兼容不同浏览器客户端之间的连接
	    var PeerConnection = (window.PeerConnection || window.webkitPeerConnection00 || window.webkitRTCPeerConnection || window.mozRTCPeerConnection);
		
	    //兼容不同浏览器获取到用户媒体对象
        var getUserMedia = (navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia);
	    
        //创建数据传输通道配置
        var localChannelOptions = {
    		  ordered: false,
    		  maxRetransmitTime: 3000,
    	};
        
        var receiveChannel = null;//远程数据通道
        var localChannel = null;//本地数据通道
        var pc = null;//客户端之间的连接
        var createPcAndDataChannel = function(){
        	//创建PeerConnection实例
            pc = new PeerConnection();
            localChannel = pc.createDataChannel('localChannel',localChannelOptions);//本地通道,本地通道接收由远程通道发送过来的数据
            localChannel.onerror = datachannel_error;
            localChannel.onopen = datachannel_open;
            localChannel.onclose = datachannel_close;
            localChannel.onmessage = datachannel_message;
            pc.ondatachannel = pc_datachannel;
            pc.onaddstream = pc_addstream;
            pc.onicecandidate = pc_icecandidate;
        }
        
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
            		 addYouMsg(msg.data,"left");
            	}else if(msg != null && msg.type == 'file'){//接收到了对方发来的即将要传送的文件信息
	       			 downloadFileData.maxsize = msg.data.fileSize;
	      			 downloadFileData.filename = msg.data.fileName;
         	    }
            }
        };
        
        var pc_addstream = function(event){//如果检测到媒体流连接到本地，将其绑定到一个video标签上输出
            document.getElementById('remote').src = URL.createObjectURL(event.stream);
        };
        
        var pc_icecandidate = function(event){//发送ICE候选到其他客户端
            if (event.candidate !== null) {
            	var param = {key:'SIGNALLING_OFFER',value:{
                    "event": "_ice_candidate",
                    "data": {
                        "candidate": event.candidate
                    }
                }};
                socket.sendJson(param);
            }
        };
        
        // 发送offer和answer的函数，发送本地session描述
        var sendOfferFn = function(desc){
            pc.setLocalDescription(desc);
            var param = {key:'SIGNALLING_OFFER',value:{ 
                "event": "_offer",
                "data": {
                    "sdp": desc
                }
            }};
            socket.sendJson(param);
        },sendAnswerFn = function(desc){
            pc.setLocalDescription(desc);
            var param = {key:'SIGNALLING_OFFER',value:{ 
                "event": "_answer",
                "data": {
                    "sdp": desc
                }
            }};
            socket.sendJson(param);
        };
       //处理发送过来的信令
       var answer = function(value){
    	   var json = JSON.parse(value);
           //如果是一个ICE的候选，则将其加入到PeerConnection中，否则设定对方的session描述为传递过来的描述
           if(json.event === "_ice_candidate" ){
               pc.addIceCandidate(new RTCIceCandidate(json.data.candidate));
           }else{
           	pc.setRemoteDescription( new RTCSessionDescription(json.data.sdp),
               	function(){
               		// 如果是一个offer，那么需要回复一个answer
                       if(json.event === "_offer") {
                           pc.createAnswer(sendAnswerFn, function (error) {
                               console.log("回复信令answer失败:" + error);
                           });
                       }
               	}
               );
           }
       }
	</script>
</body>
</html>