package com.media.storage;

import java.util.HashMap;

import com.media.code.OneReadyCode;

/**
 * 个人对话准备存储
 * @author tanjun
 *
 */
public class PersonalReadyStorage {
	private static final HashMap<String/*发起呼叫方id*/,OneReadyCode> call = new HashMap<String,OneReadyCode>();
	private static final HashMap<String/*应答方id*/,OneReadyCode> answer = new HashMap<String,OneReadyCode>();
	
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
		synchronized (call) {
			OneReadyCode oc = new OneReadyCode();
			oc.setRemoteId(answerId);
			oc.setStatus(false);
			call.put(callId, oc);
		}
		synchronized (answer) {
			OneReadyCode oc = new OneReadyCode();
			oc.setRemoteId(callId);
			oc.setStatus(false);
			answer.put(answerId,oc);
		}
	}
	
	/**
	 * 呼叫方取消准备
	 * @param callId
	 */
	public static void delCall(String callId){
		OneReadyCode answerId = call.get(callId);
		if(answerId == null){
			return;
		}
		synchronized (call) {
			call.remove(callId);
		}
		synchronized (answer) {
			answer.remove(answerId.getRemoteId());
		}
	}
	
	/**
	 * 被呼叫方拒绝准备
	 * @param callId
	 */
	public static void delAnswer(String answerId){
		OneReadyCode callId = answer.get(answerId);
		if(callId == null){
			return;
		}
		synchronized (call) {
			call.remove(callId.getRemoteId());
		}
		synchronized (answer) {
			answer.remove(answerId);
		}
	}
	
	/**
	 * 被呼叫方 同意准备
	 * 并返回 呼叫方的 id
	 * @param answerId
	 * @return
	 */
	public static String answerOkReady(String answerId){
		//设置双方都为准备状态
		OneReadyCode callOc = answer.get(answerId);
		if(callOc == null){//呼叫方已经取消准备
			return null;
		}
		callOc.setStatus(true);
		OneReadyCode answerOc = call.get(callOc.getRemoteId());
		answerOc.setStatus(true);
		return callOc.getRemoteId();
	}
	
	/**
	 * 通过一个id 找到与它建立远程的 id
	 * @param call
	 * @return
	 */
	public static String findReadyAnswerBycallId(String thisId){
		OneReadyCode callOc = call.get(thisId);
		if(callOc == null){
			OneReadyCode answerOc = answer.get(thisId);
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
		synchronized (call) {
			call.remove(id1);
			call.remove(id2);
		}
		synchronized (answer) {
			answer.remove(id2);
			answer.remove(id1);
		}
	}
}
