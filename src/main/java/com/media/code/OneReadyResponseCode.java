package com.media.code;

import javax.websocket.Session;

/**
 * 一对一响应配置
 * @author tanjun
 *
 */
public class OneReadyResponseCode {
	private Session session;
	
	private boolean status;
	
	private String msg;
	
	private String answerId;
	
	

	

	public String getAnswerId() {
		return answerId;
	}

	public void setAnswerId(String answerId) {
		this.answerId = answerId;
	}

	public Session getSession() {
		return session;
	}

	public void setSession(Session session) {
		this.session = session;
	}

	public boolean isStatus() {
		return status;
	}

	public void setStatus(boolean status) {
		this.status = status;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}
	
	
}
