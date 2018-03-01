package com.media.code;

/**
 * 消息类型code定义
 * @author tanjun
 *
 */
public enum MessageTypeCode {
	 PERSONAL_ID("个人身份id", "0"), 
	 SIGNALLING_OFFER("提供者信令", "1"),
	 SIGNALLING_ONE_ANSWER("一对一应答者信令", "2"),
	 READY_FOR_ONE("一对一准备", "3"), 
	 READY_FOR_GROUP("群组准备", "4"),
	 QUERY_ID("搜索个人身份", "5"),
	 READY_FOR_ONE_RESPONSE("一对一准备响应", "6"),
	 ONE_CHANNEL_CLOSE("一对一通道关闭","7"),
	 CREATE_GROUP_FIVE("创建五人群组房间", "8"),
	 EXIT_GROUP_FIVE("退出五人群组房间", "9"),
	 QUERY_GROUP_FIVE("搜索五人群组房间", "10"),
	 SIGNALLING_FIVE_ANSWER("五人组应答者信令","11"),
	 GROUP_FIVE_ADD_USER("五人组有人进入房间了","12");
	
    private String name ;
    private String code ;
    
    private MessageTypeCode( String name , String code ){
        this.name = name ;
        this.code = code ;
    }
     
    public String getName() {
        return name;
    }
    public String getCode() {
        return code;
    }
}
