package com.media.storage;

import java.util.ArrayList;
import java.util.concurrent.ConcurrentHashMap;

import com.media.config.FiveHomeConfig;

/**
 * 五人群组房间存储
 * @author tanjun
 *
 */
public class FiveHomeStorage {
	private static int homeSize = 0;//已经创建过多少房间 计数器
	private static final ConcurrentHashMap<String/*个人id*/,String/*所在房号*/> userAndHome = new ConcurrentHashMap<String,String/*所在房号*/>();
	private static final ConcurrentHashMap<String/*房号ID*/,FiveHomeConfig> homeAndUser = new ConcurrentHashMap<String,FiveHomeConfig>();
	
	/**
	 * 返回一个id是否正在对话
	 * @param id
	 * @return
	 */
	public static boolean isReady(String id){
		return userAndHome.containsKey(id);
	}
	
	/**
	 * 创建一个房间
	 * 并且返回当前房间号
	 */
	public static String createHome(){
		FiveHomeConfig homeConfig = new FiveHomeConfig();
		String homeId = Integer.toString(homeSize);
		homeConfig.setHomeId(homeId);
		homeAndUser.put(homeId, homeConfig);
		homeSize++;
		return Integer.toString(homeSize-1);
	}
	
	/**
	 * 用户加入房间
	 */
	public static boolean addHome(String userId,String homeId){
		if(homeAndUser.get(homeId) == null){//房间是否存在
			return false;
		}
		//检查房间是否已满
		if(homeAndUser.get(homeId).getUserIds().size() < homeAndUser.get(homeId).getMaxSize()){
			userAndHome.put(userId, homeId);
			homeAndUser.get(homeId).getUserIds().add(userId);
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * 用户退出房间
	 * 如果退出后房间里面没有人了,则删除房间
	 * @param userId
	 */
	public static void exitHome(String userId){
		if(!userAndHome.containsKey(userId)){
			return;
		}
		String homeId = userAndHome.get(userId);
		userAndHome.remove(userId);
		homeAndUser.get(homeId).getUserIds().remove(userId);
		if(homeAndUser.get(homeId).getUserIds().size() == 0){
			homeAndUser.remove(homeId);
		}
	}
	
	/**
	 * 获取房间内所有人的id
	 * @param homeId
	 * @return
	 */
	public static ArrayList<String> getHomeUsers(String homeId){
		if(homeAndUser.containsKey(homeId)){
			ArrayList<String> users = homeAndUser.get(homeId).getUserIds();
			ArrayList<String> nowUsers = new ArrayList<String>(users.size());//拷贝到另外一个list,防止地址引用的问题被外部改变了真实数据
			for (String id : users) {
				nowUsers.add(id);
			}
			return nowUsers;
		}else{
			return null;
		}
	}
	
	/**
	 * 获取房间内所有其他人的id,排除自己
	 * @param homeId
	 * @param thisUserId
	 * @return
	 */
	public static ArrayList<String> getHomeUsersNotThis(String homeId,String thisUserId){
		ArrayList<String> users = getHomeUsers(homeId);
		if(users == null){
			return null;
		}
		for (String userId : users) {
			if(userId.equals(thisUserId)){
				users.remove(thisUserId);
				break;
			}
		}
		return users;
	}
	
	/**
	 * 获取用户所在哪个房间
	 * @param userId
	 * @return
	 */
	public static String getHomeIdByUserId(String userId){
		return userAndHome.get(userId);
	}
}
