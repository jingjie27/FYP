/*
 *         Copyright (C) 2021, AURORA Developers
 *                  All rights reserved.
 * 
 *            Code Owner : AURORA Developers
 * 
 *            @version LoginResult.java Jul 11, 2021 Zoey
 *            @author  Zoey
 *            @since   Jul 11, 2021
 * 
 * 
 *            MODIFIED
 *            Zoey     Jul 11, 2021 - Creation
 */
package com.aurora.API.Bean.Web;

import com.aurora.API.Bean.Web.AD.ADLoginNav;
import java.util.List;

/**
 *
 * @author Zoey
 */
public class LoginResult
{
    private String userId;
    private String firstName;
    private String lastName;;
    private String userEmail;
    private String allowVoid;
    private String authorization;
    private String token;
    
    private List<ADLoginNav> navigationMenu;
    
    public LoginResult()
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

    public String getFirstName()
    {
        return firstName;
    }

    public void setFirstName(String firstName)
    {
        this.firstName = firstName;
    }

    public String getLastName()
    {
        return lastName;
    }

    public void setLastName(String lastName)
    {
        this.lastName = lastName;
    }

    public String getUserEmail()
    {
        return userEmail;
    }

    public void setUserEmail(String userEmail)
    {
        this.userEmail = userEmail;
    }

    public String getAllowVoid()
    {
        return allowVoid;
    }

    public void setAllowVoid(String allowVoid)
    {
        this.allowVoid = allowVoid;
    }

    public String getAuthorization()
    {
        return authorization;
    }

    public void setAuthorization(String authorization)
    {
        this.authorization = authorization;
    }

    public String getToken()
    {
        return token;
    }

    public void setToken(String token)
    {
        this.token = token;
    }

    public List<ADLoginNav> getNavigationMenu()
    {
        return navigationMenu;
    }

    public void setNavigationMenu(List<ADLoginNav> navigationMenu)
    {
        this.navigationMenu = navigationMenu;
    }

    @Override
    public String toString()
    {
        return "LoginResult{" + "userId=" + userId + ", allowVoid=" + allowVoid + ", authorization=" + authorization + ", token=" + token + ", navigationMenu=" + navigationMenu + '}';
    }
    
    
    
}
