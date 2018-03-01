package com.media.config;

/**
 * 一对一准备配置
 * @author tanjun
 *
 */
public class OneReadyConfig {
	private String remoteId;// 远端的ID
	
	private boolean status;//  远端是否已经准备好

	public String getRemoteId() {
		return remoteId;
	}

	public void setRemoteId(String remoteId) {
		this.remoteId = remoteId;
	}

	public boolean isStatus() {
		return status;
	}

	public void setStatus(boolean status) {
		this.status = status;
	}

	
}
