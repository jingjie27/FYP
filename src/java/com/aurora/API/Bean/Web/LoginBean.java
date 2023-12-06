/*
 *         Copyright (C) 2021, AURORA Developers
 *                  All rights reserved.
 * 
 *            Code Owner : AURORA Developers
 * 
 *            @version LoginBean.java Jul 11, 2021 Zoey
 *            @author  Zoey
 *            @since   Jul 11, 2021
 * 
 * 
 *            MODIFIED
 *            Zoey     Jul 11, 2021 - Creation
 */
package com.aurora.API.Bean.Web;

/**
 *
 * @author Zoey
 */
public class LoginBean
{
    private String userId;
    private String password;
    
    public LoginBean()
    {
        super();
    }

    public String getUserId()
    {
        return userId;
    }

    public void setUserId(String userId)
    {
        this.userId = userId;
    }

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
    }
    
}
