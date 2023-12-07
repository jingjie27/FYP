/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.aurora.API.Bean.Web;

/**
 *
 * @author Projects
 */
public class UserMngDeleteBean {
    
    private String userID;
    private String lastVersion;

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getLastVersion() {
        return lastVersion;
    }

    public void setLastVersion(String lastVersion) {
        this.lastVersion = lastVersion;
    }

    @Override
    public String toString() {
        return "UserMngDeleteBean{" + "userID=" + userID + ", lastVersion=" + lastVersion + '}';
    }
    
}
