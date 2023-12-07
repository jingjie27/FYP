
package com.aurora.API.Bean.Web;

/**
 *
 * @author jinjie
 */
public class UserMngUpdateBean extends UserMngCreateBean {

    private String lastVersion;

    public UserMngUpdateBean() {
        super();
    }

    public String getLastVersion() {
        return lastVersion;
    }

    public void setLastVersion(String lastVersion) {
        this.lastVersion = lastVersion;
    }

    @Override
    public String toString() {
        return "OdrchklstUpdateBean{" +  ", lastVersion=" + lastVersion + '}';
    }

}
