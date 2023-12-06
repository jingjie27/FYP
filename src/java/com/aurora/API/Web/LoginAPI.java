/*
 *         Copyright (C) 2021, AURORA Developers
 *                  All rights reserved.
 * 
 *            Code Owner : AURORA Developers
 * 
 *            @version LoginAPI.java Jul 11, 2021 Zoey
 *            @author  Zoey
 *            @since   Jul 11, 2021
 * 
 * 
 *            MODIFIED
 *            Zoey     Jul 11, 2021 - Creation
 */
package com.aurora.API.Web;
import com.aurora.API.Bean.EntityServiceBean;
import com.aurora.API.Bean.ResultServiceBean;
import com.aurora.API.Bean.Web.AD.ADLoginNav;
import com.aurora.API.Bean.Web.LoginBean;
import com.aurora.API.Bean.Web.LoginResult;
import com.aurora.Servlet.API.AuthStatus;
import com.aurora.Servlet.API.ServletAction;
import java.util.List;

/**
 *
 * @author Zoey
 */
public interface LoginAPI
{
   ResultServiceBean<LoginResult> Login(EntityServiceBean<LoginBean> bean, AuthStatus authStatus); 
   ResultServiceBean<List<ADLoginNav>> GetNavMenu(String userID, AuthStatus authStatus);
}
