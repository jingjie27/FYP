/*
 *                       Copyright (C) 2021, AURORA System
 *                              All rights reserved.
 * 
 *                           Code Owner : DING YING HONG
 * 
 *  This Code is solely used for AURORA System Only. Any of the source code cannot be copied and/or 
 *      distributed without writen and/or verbal notice from the code owner as mentioned above.
 * 
 *                           Proprietory and Confidential  
 * 
 *            @version OdrchklstUpdateBeanjava 7 Nov 2023 yeehao
 *            @author  yeehao
 *            @since   7 Nov 2023
 * 
 */
package com.aurora.API.Bean.Web;

/**
 *
 * @author yeehao
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
