package com.media.config;

import javax.websocket.Session;

/**
 * 一对一响应配置
 * @author tanjun
 *
 */
public class OneReadyResponseConfig {
	private boolean status;
	
	private String msg;
	
	private String answerId;
	
	private String offerId;

	
	
	public String getOfferId() {
		return offerId;
	}

	public void setOfferId(String offerId) {
		this.offerId = offerId;
	}

	public String getAnswerId() {
		return answerId;
	}

	public void setAnswerId(String answerId) {
		this.answerId = answerId;
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
