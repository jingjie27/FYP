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
 *            @version OdrchklstSearchResult.java 6 Nov 2023 yeehao
 *            @author  jingjie
 *            @since   17 Nov 2023
 * 
 */
package com.aurora.API.Bean.Web;

/**
 *
 * @author jingjie
 */
public class UserMngSearchResult {

    private String userID;
    private String firstName;
    private String lastName;
    private String email;
    private String title;
    private String authorization;
    private String createDate;
    private String lastVersion;

    public UserMngSearchResult() {
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthorization() {
        return authorization;
    }

    public void setAuthorization(String authorization) {
        this.authorization = authorization;
    }

    public String getCreateDate() {
        return createDate;
    }

    public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }
    

    public String getLastVersion() {
        return lastVersion;
    }

    public void setLastVersion(String lastVersion) {
        this.lastVersion = lastVersion;
    }

}
