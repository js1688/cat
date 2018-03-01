<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="/cat/css/index.css">
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.slim.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <title>前端源码</title>
</head>
<body>
	<div style="bottom: 50px;top: 0px;left: 0px;right: 0px;position: absolute;">
		 <label style="color: #FFFFFF;">个人编号［<label id="identity"></label>］</label>
		 <label style="margin-left: 20px;"><span style="color: #FFFFFF;" id="createGroup">［创建群组］</span></label>
		 <div style="position:absolute;top: 160px;left: 345px;width: 650px;">
		    <ul id="query-tabs" class="nav nav-tabs">
			 	<li><a href="#friend" data-toggle="tab"><i class="glyphicon glyphicon-user"></i> 个人</a></li>
				<li><a href="#home" data-toggle="tab"><i class="glyphicon glyphicon-home"></i> 群组</a></li>
			</ul>
			<div class="tab-content" style="margin-top: 1px;">
				<div class="tab-pane fade" id="friend" style="position:relative;height: 100%;width: 100%;">
					<div class="input-group">
			            <input type="text" class="form-control" id="oneId" placeholder="请输入需要搜索的个人编号">
			            <span class="input-group-addon" id="findOneId"><img src="/cat/img/ok.png" width="20px;"></span>
			        </div>
				</div>
				<div class="tab-pane fade" id="home" style="position:relative;height: 100%;width: 100%;">
					<div class="input-group">
			            <input type="text" class="form-control" id="fiveId" placeholder="请输入需要搜索的群组编号">
			            <span class="input-group-addon" id="findFiveId"><img src="/cat/img/ok.png" width="20px;"></span>
			        </div>
				</div>
			</div>
		</div>
		
		<!-- 一对一搜索信息弹出 -->
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
		<!-- 一对一响应对话请求弹出 -->
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
		<div class="modal fade" id="dialogForOne" data-backdrop="false" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="overflow:auto;">
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
				    						<label for="fileMsgForOne">
				    							<span><i class="glyphicon glyphicon-link"></i></span>
				    						</label>
				    						<form><input type="file" id="fileMsgForOne" style="position:absolute;clip:rect(0 0 0 0);"></form>
			    						</div>
			    					</div>
			    					<!-- 输入框 -->
			    					<div style="height: 131px;width: 100%;">
			    						<textarea name = "message" style="width: 100%;height: 100%;resize:none;border: 0px;background-color: #EEEEEE;" placeholder="请输入需要发送的内容"></textarea>
			    					</div>
			    				</div>
		    				</div>
		    				<!-- 右侧视频语音聊天展示 -->
				    		<div style="width: 300px;height: 647px;float: left;">
				    			<!-- 本地视频框 -->
				    			<div class="panel panel-default" style="margin: 0px;padding: 0px;">
								    <div class="panel-body">
								       <video style="height:250px;width:250px;margin: 0px;padding: 0px;" name="video" autoplay></video>
								    </div>
								    <div class="panel-footer" align="center">
								    	<button type="button" class="btn btn-default btn-lg btn-xs" name="openVideo" data-use="false"><i class="glyphicon glyphicon-facetime-video"></i> <span>开始视频</span></button>
								    	<button type="button" class="btn btn-default btn-lg btn-xs" name="openAudio" data-use="false"><i class="glyphicon glyphicon-earphone"></i> <span>开始语音</span></button>
								    </div>
								</div>
								<!-- 远端视频框 -->
				    			<div class="panel panel-default" style="margin: 0px;padding: 0px;">
								    <div class="panel-body">
								        <video style="height:250px;width:250px;" name="remote" autoplay></video>
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
		                <button type="button" class="btn btn-success" onclick="sendMessageOne()">发送消息</button>
		            </div>
		        </div>
		    </div>
		</div>
		<!-- 多对多,最多五人对话框 -->
		<div class="modal fade" id="dialogForFive" data-backdrop="false" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="overflow:auto;">
			<div class="modal-dialog" style="width: 1300px;">
		        <div class="modal-content">
		            <div class="modal-header">
		                <h4 class="modal-title">群号［<label name="name"></label>］</h4>
		            </div>
		            <!-- 聊天框 -->
		            <div class="modal-body" style="margin: 0px;padding: 0px;">
		            	<!-- 视频展示框 -->
				    	<div class="panel panel-default" style="margin: 0px;padding: 0px;">
							 <div class="panel-body">
								 <div style="width:250px;float: left;margin-left: 2px;">
								 	<div class="panel panel-default" style="margin: 0px;padding: 0px;">
								    <div class="panel-body" style="margin: 0px;padding: 0xp;">
								       <video style="width:100%;height:187px;margin: 0px;padding: 0px;" name="video" autoplay></video>
								    </div>
								    <div class="panel-footer" align="center">
								    	<label>本地视频</label>
								    </div>
									</div>
								 </div>
								<div style="width:250px;float: left;margin-left: 2px;">
								 	<div class="panel panel-default" style="margin: 0px;padding: 0px;">
								    <div class="panel-body" style="margin: 0px;padding: 0xp;">
								       <video style="width:100%;height:187px;margin: 0px;padding: 0px;" name="remote" data-remoteId="" data-name="remote1" autoplay></video>
								    </div>
								    <div class="panel-footer" align="center">
								    	<label name="remote1">空闲</label>
								    </div>
									</div>
								 </div>
								 <div style="width:250px;float: left;margin-left: 2px;">
								 	<div class="panel panel-default" style="margin: 0px;padding: 0px;">
								    <div class="panel-body" style="margin: 0px;padding: 0xp;">
								       <video style="width:100%;height:187px;margin: 0px;padding: 0px;" name="remote" data-remoteId="" data-name="remote2" autoplay></video>
								    </div>
								    <div class="panel-footer" align="center">
								    	<label name="remote2">空闲</label>
								    </div>
									</div>
								 </div>
								 <div style="width:250px;float: left;margin-left: 2px;">
								 	<div class="panel panel-default" style="margin: 0px;padding: 0px;">
								    <div class="panel-body" style="margin: 0px;padding: 0xp;">
								       <video style="width:100%;height:187px;margin: 0px;padding: 0px;" name="remote" data-remoteId="" data-name="remote3" autoplay></video>
								    </div>
								    <div class="panel-footer" align="center">
								    	<label name="remote3">空闲</label>
								    </div>
									</div>
								 </div>
								 <div style="width:250px;float: left;margin-left: 2px;">
								 	<div class="panel panel-default" style="margin: 0px;padding: 0px;">
								    <div class="panel-body" style="margin: 0px;padding: 0xp;">
								       <video style="width:100%;height:187px;margin: 0px;padding: 0px;" name="remote" data-remoteId="" data-name="remote4" autoplay></video>
								    </div>
								    <div class="panel-footer" align="center">
								    	<label name="remote4">空闲</label>
								    </div>
									</div>
								 </div>
							 </div>
							 <div class="panel-footer" align="center">
							 	<button type="button" class="btn btn-default btn-lg btn-xs" name="openVideo" data-use="false"><i class="glyphicon glyphicon-facetime-video"></i> <span>开始视频</span></button>
							 	<button type="button" class="btn btn-default btn-lg btn-xs" name="openAudio" data-use="false"><i class="glyphicon glyphicon-earphone"></i> <span>开始语音</span></button>
							 </div>
						</div>
						<!-- 聊天框框 -->
						<div style="width: 1298px;height: 300px;">
			    				<div style="overflow-y:auto;height: 200px;">
			    					<!-- 每一条聊天记录都加在 li里面 -->
			    					<ul class="bubbleDiv" name="bubbleDiv"></ul>
			    				</div>
			    				<!-- 聊天输入 -->
			    				<div style="height: 100px;">
			    					<!-- 功能框 -->
			    					<div style="height: 16px;">
			    						<!-- 发送附件功能 -->
			    						<div style="margin-left: 5px;">
				    						<label for="fileMsgForFive">
				    							<span><i class="glyphicon glyphicon-link"></i></span>
				    						</label>
				    						<form><input type="file" id="fileMsgForFive" style="position:absolute;clip:rect(0 0 0 0);"></form>
			    						</div>
			    					</div>
			    					<!-- 输入框 -->
			    					<div style="height: 84px;width: 100%;">
			    						<textarea name = "message" style="width: 100%;height: 100%;resize:none;border: 0px;background-color: #EEEEEE;" placeholder="请输入需要发送的内容"></textarea>
			    					</div>
			    				</div>
		    			</div>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" name="close">关闭对话</button>
		                <button type="button" class="btn btn-success" onclick="sendMessageFive()">发送消息</button>
		            </div>
		        </div>
		    </div>
		</div>
	</div>
	<div style="position: absolute;bottom: 0px;left: 0px;right: 0px;color: #FFFFFF;height: 50px;line-height: 50px;" align="center">
		<a href="https://github.com/js1688/cat" target="_blank">点击下载源码</a>
	</div>
	<script src="/cat/js/websocket.js"></script>
    <script src="/cat/js/webrtc.js"></script>
    <script src="/cat/js/publicControl.js"></script>
    <script src="/cat/js/oneControl.js"></script>
    <script src="/cat/js/fiveControl.js"></script>
</body>
</html>