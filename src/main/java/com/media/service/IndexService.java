package com.media.service;

import javax.websocket.Session;

import com.media.code.OneReadyResponseCode;
import com.media.storage.PersonalReadyStorage;
import com.media.storage.PersonalSessionStorage;

/**
 * 不同消息逻辑处理层
 * @author tanjun
 *
 */
public class IndexService{
	
	/**
	 * 搜索个人 是否可以对话
	 * @return 
	 */
	public static boolean queryId(String thisId,String id){
		if(!thisId.equals(id)){//不可以搜索自己
			Session session = PersonalSessionStorage.getSessionById(id);
			if(session == null){
				return false;
			}
			//查询它是否正在对话
			if(PersonalReadyStorage.isReady(id)){
				return false;
			}
			return true;
		}
		return false;
	}
	
	/**
	 * 发送一对一对话请求
	 * @param thisId
	 * @param id
	 * @return
	 */
	public static Session readyForOne(String thisId,String id){
		if(PersonalReadyStorage.isReady(thisId)){//自己已经准备过,取消准备
			PersonalReadyStorage.delCall(thisId);
		}else{
			if(IndexService.queryId(thisId,id)){//再次检测对方是否可以对话,结果为可发起对话
				Session answerSession = PersonalSessionStorage.getSessionById(id);
				PersonalReadyStorage.addCall(thisId, id);//添加发起准备的信息
				return answerSession;
			}
		}
		return null;
	}
	
	/**
	 * 一对一准备响应
	 * 返回需要发送的session
	 * 很可能会发回被呼叫方,因为呼叫方取消了准备
	 * @param thisId
	 * @param is
	 * @return
	 */
	public static OneReadyResponseCode readyForOneResponse(String thisId,boolean is){
		OneReadyResponseCode map = new OneReadyResponseCode();
		String callId = PersonalReadyStorage.answerOkReady(thisId);
		if(callId == null){//呼叫方取消了准备
			Session answerSession = PersonalSessionStorage.getSessionById(thisId);
			map.setMsg("呼叫方取消了准备");
			map.setStatus(false);
			map.setSession(answerSession);
			return map;
		}
		Session callSession = PersonalSessionStorage.getSessionById(callId);
		map.setMsg("对方"+(is ? "同意" : "拒绝")+"对话");
		map.setStatus(is);
		map.setSession(callSession);
		map.setAnswerId(thisId);
		return map;
	}
	
	/**
	 * 发送信令给对方,这里不管是应答者 还是 提供者
	 * @param thisId
	 * @return
	 */
	public static OneReadyResponseCode signallingOffer(String thisId){
		OneReadyResponseCode map = new OneReadyResponseCode();
		//先找到当前发送者与谁建立了对话关系
		String answerId = PersonalReadyStorage.findReadyAnswerBycallId(thisId);
		if(answerId == null){//非法发送信令,根本不存在通话准备信息
			map.setMsg("非法发送信令,根本不存在通话准备信息");
			map.setSession(PersonalSessionStorage.getSessionById(thisId));
			map.setStatus(false);
			return map;
		}else{//通话准备信息验证正确,转发信令
			map.setSession(PersonalSessionStorage.getSessionById(answerId));
			map.setStatus(true);
		}
		return map;
	}

	/**
	 * 关闭双方的对话准备,并且返回对方的session
	 * @param thisId
	 * @return
	 */
	public static Session oneChannelClose(String thisId){
		String answerId = PersonalReadyStorage.findReadyAnswerBycallId(thisId);
		if(answerId == null){
			return null;
		}
		//删掉双方的对话准备
		PersonalReadyStorage.readyClose(thisId, answerId);
		return PersonalSessionStorage.getSessionById(answerId);
	}
}
