
package com.aurora.API.Bean.Web;

/**
 *
 * @author jinjie
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
