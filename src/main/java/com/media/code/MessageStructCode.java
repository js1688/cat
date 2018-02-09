package com.media.code;

/**
 * 消息传递结构
 * @author tanjun
 *
 */
public class MessageStructCode {
	private MessageTypeCode key;
	
	private Object value;

	public MessageTypeCode getKey() {
		return key;
	}

	public void setKey(MessageTypeCode key) {
		this.key = key;
	}

	public Object getValue() {
		return value;
	}

	public void setValue(Object value) {
		this.value = value;
	}

	
}
