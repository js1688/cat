package com.media.controller;

import java.io.IOException;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.alibaba.fastjson.JSON;
import com.media.code.MessageStructCode;
import com.media.code.MessageTypeCode;
import com.media.code.OneReadyResponseCode;
import com.media.service.IndexService;
import com.media.storage.PersonalSessionStorage;

@ServerEndpoint(value="/index")  
public class IndexController {
	
	@OnOpen  
    public void open(Session session){  
		String id = session.getId();
		try{
			PersonalSessionStorage.addSessionById(id, session);
			String ret = getRet(MessageTypeCode.PERSONAL_ID, id);
	    	session.getBasicRemote().sendText(ret);
		}catch(Throwable e){
			PersonalSessionStorage.delSessionById(id);
			try {
				session.close();
			} catch (IOException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
    }  
    @OnMessage
    public void OnMessage(String message, Session session){
    	try{
	    	MessageStructCode struct = JSON.parseObject(message,MessageStructCode.class);
	    	switch (struct.getKey()) {
			case QUERY_ID://搜索个人
				session.getBasicRemote().sendText(getRet(MessageTypeCode.QUERY_ID,IndexService.queryId(session.getId(),struct.getValue().toString())));
				break;
			case READY_FOR_ONE://一对一准备
				Session answerSession = IndexService.readyForOne(session.getId(), struct.getValue().toString());
				if(answerSession != null){
					answerSession.getBasicRemote().sendText(getRet(MessageTypeCode.READY_FOR_ONE,session.getId()));//给对方发送准备请求
				}
				break;
			case READY_FOR_ONE_RESPONSE://一对一准备响应
				OneReadyResponseCode ret = IndexService.readyForOneResponse(session.getId(),Boolean.parseBoolean(struct.getValue().toString()));
				Session readySession = ret.getSession();
				ret.setSession(null);
				readySession.getBasicRemote().sendText(getRet(MessageTypeCode.READY_FOR_ONE_RESPONSE,JSON.toJSONString(ret)));
				break;
			case SIGNALLING_OFFER://接收发送到服务端的信令
				OneReadyResponseCode offerRet = IndexService.signallingOffer(session.getId());
				if(offerRet.isStatus()){//转发信令
					offerRet.getSession().getBasicRemote().sendText(getRet(MessageTypeCode.SIGNALLING_ANSWER,JSON.toJSONString(struct.getValue())));
				}else{//非法发送,响应回去
					Session tempSession = offerRet.getSession();
					offerRet.setSession(null);
					tempSession.getBasicRemote().sendText(getRet(MessageTypeCode.READY_FOR_ONE_RESPONSE,JSON.toJSONString(offerRet)));
				}
				break;
			case ONE_CHANNEL_CLOSE://发送了一对一通道关闭
				Session closeSession = IndexService.oneChannelClose(session.getId());
				if(closeSession != null){
					closeSession.getBasicRemote().sendText(getRet(MessageTypeCode.ONE_CHANNEL_CLOSE,true));
				}
				break;
			default:
				break;
			}
    	}catch(Throwable e){
    		e.printStackTrace();
    	}
    	
    }  

    @OnError
    public void onError(Throwable t) {
    	System.out.println(t.getMessage());
    }
    
    @OnClose  
    public void close(Session session){//当关闭浏览器后,则删除session记录和对话准备
    	try{
	    	//并且给对方 发送关闭对话的通知,如果有在对话
    		Session closeSession = IndexService.oneChannelClose(session.getId());
			if(closeSession != null){
				closeSession.getBasicRemote().sendText(getRet(MessageTypeCode.ONE_CHANNEL_CLOSE,true));
			}
	    	PersonalSessionStorage.delSessionById(session.getId());
    	}catch(Throwable e){
    		e.printStackTrace();
    	}
    }  
    
    /**
     * 发送消息结构
     * @param key
     * @param msg
     * @return
     */
    private String getRet(MessageTypeCode key,Object msg){
    	MessageStructCode struct = new MessageStructCode();
    	struct.setValue(msg);
    	struct.setKey(key);
		return JSON.toJSONString(struct);
    }
}
