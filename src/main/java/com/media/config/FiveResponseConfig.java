package com.media.config;

/**
 * 五人群组响应配置
 * @author tanjun
 *
 */
public class FiveResponseConfig {
	
	private String sendUserId;//发送此消息个人编号
	
	private String msg;
	
	private String [] userIds;//这个房间内其他人的id
	
	private String homeId;//房号
	
	
	public String getHomeId() {
		return homeId;
	}

	public void setHomeId(String homeId) {
		this.homeId = homeId;
	}

	public String[] getUserIds() {
		return userIds;
	}

	public void setUserIds(String[] userIds) {
		this.userIds = userIds;
	}

	public String getSendUserId() {
		return sendUserId;
	}

	public void setSendUserId(String sendUserId) {
		this.sendUserId = sendUserId;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	
}
