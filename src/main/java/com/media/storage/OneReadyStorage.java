package com.media.storage;

import java.util.concurrent.ConcurrentHashMap;

import com.media.config.OneReadyConfig;

/**
 * 个人对话准备存储
 * @author tanjun
 *
 */
public class OneReadyStorage {
	private static final ConcurrentHashMap<String/*发起呼叫方id*/,OneReadyConfig> call = new ConcurrentHashMap<String,OneReadyConfig>();
	private static final ConcurrentHashMap<String/*应答方id*/,OneReadyConfig> answer = new ConcurrentHashMap<String,OneReadyConfig>();
	
	/**
	 * 返回一个id是否正在对话
	 * @param id
	 * @return
	 */
	public static boolean isReady(String id){
		if(call.get(id) == null){
			if(answer.get(id) == null){
				return false;//既不是呼叫方,也不是应答方,没有在对话
			}
		}
		return true;
	}
	
	/**
	 * 发起准备
	 * @param callId
	 * @param answerId
	 */
	public static void addCall(String callId,String answerId){
		OneReadyConfig oc1 = new OneReadyConfig();
		oc1.setRemoteId(answerId);
		oc1.setStatus(false);
		call.put(callId, oc1);
		OneReadyConfig oc2 = new OneReadyConfig();
		oc2.setRemoteId(callId);
		oc2.setStatus(false);
		answer.put(answerId,oc2);
	}
	
	/**
	 * 呼叫方取消准备
	 * @param callId
	 */
	public static void delCall(String callId){
		OneReadyConfig answerId = call.get(callId);
		if(answerId == null){
			return;
		}
		call.remove(callId);
		answer.remove(answerId.getRemoteId());
	}
	
	/**
	 * 被呼叫方拒绝准备
	 * @param callId
	 */
	public static void delAnswer(String answerId){
		OneReadyConfig callId = answer.get(answerId);
		if(callId == null){
			return;
		}
		call.remove(callId.getRemoteId());
		answer.remove(answerId);
	}
	
	/**
	 * 被呼叫方 同意准备
	 * 并返回 呼叫方的 id
	 * @param answerId
	 * @return
	 */
	public static String answerOkReady(String answerId){
		//设置双方都为准备状态
		OneReadyConfig callOc = answer.get(answerId);
		if(callOc == null){//呼叫方已经取消准备
			return null;
		}
		callOc.setStatus(true);
		OneReadyConfig answerOc = call.get(callOc.getRemoteId());
		answerOc.setStatus(true);
		return callOc.getRemoteId();
	}
	
	/**
	 * 通过一个id 找到与它建立远程的 id
	 * @param call
	 * @return
	 */
	public static String findReadyAnswerBycallId(String thisId){
		OneReadyConfig callOc = call.get(thisId);
		if(callOc == null){
			OneReadyConfig answerOc = answer.get(thisId);
			if(answerOc == null){
				return null;
			}
			if(answerOc.isStatus()){//对方已准备
				return answerOc.getRemoteId();
			}
		}
		if(callOc.isStatus()){//对方已准备
			return callOc.getRemoteId();
		}
		return null;
	}
	
	/**
	 * 关闭掉双方的准备,不确定两个id谁是呼叫方,应答方
	 * @param thisId
	 */
	public static void readyClose(String id1,String id2){
		call.remove(id1);
		call.remove(id2);
		answer.remove(id2);
		answer.remove(id1);
	}
}
