package com.media.storage;

import java.io.IOException;
import java.util.HashMap;

import javax.websocket.Session;

/**
 * 个人session缓存类
 * @author tanjun
 *
 */
public class PersonalSessionStorage {
	private static final HashMap<String,Session> storage = new HashMap<String,Session>();
	
	/**
	 * 通过一个id获得这个session
	 * @param id
	 * @return
	 */
	public static Session getSessionById(String id){
		return storage.get(id);
	}
	
	/**
	 * 存储一个session 到指定的id
	 * @param id
	 * @param sio
	 */
	public static void addSessionById(String id,Session sio){
		synchronized(storage){
			storage.put(id, sio);
		}
	}
	
	/**
	 * 删除指定的session
	 * @param id
	 */
	public static void delSessionById(String id){
		synchronized(storage){
			try {
				storage.get(id).close();
				storage.remove(id);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
