/*
 *         Copyright (C) 2021, AURORA Developers
 *                  All rights reserved.
 * 
 *            Code Owner : AURORA Developers
 * 
 *            @version SvltLoginAPI.java Jul 4, 2021 Zoey
 *            @author  Zoey
 *            @since   Jul 4, 2021
 * 
 * 
 *            MODIFIED
 *            Zoey     Jul 4, 2021 - Creation
 */
package com.aurora.Servlet.API.Web;

import com.aurora.API.Bean.EntityServiceBean;
import com.aurora.API.Bean.ResultServiceBean;
import com.aurora.API.Bean.Web.AD.ADLoginNav;
import com.aurora.API.Bean.Web.LoginBean;
import com.aurora.API.Bean.Web.LoginResult;
import com.aurora.API.Web.LoginAPI;
import com.aurora.API.Web.LoginAPIImplement;
import com.aurora.DataSource.SourceConnector;
import com.aurora.Servlet.API.APIServlet;
import com.aurora.Servlet.API.Message.ResponseInfo;
import com.aurora.Servlet.API.ServletAction;
import com.aurora.Servlet.API.Utils.StatusCode;
import com.aurora.Utility.MiscUtility;
import com.fasterxml.jackson.core.type.TypeReference;
import java.util.List;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import org.apache.commons.lang3.ArrayUtils;

/**
 *
 * @author Zoey
 */
public class SvltLoginAPI extends APIServlet
{

    @Override
    public void init(ServletConfig servletConfig) throws ServletException
    {

        try
        {
            register(ActionBuilder.of(this)
                    .jackson(true)
                    .ofInstance(SourceConnector.PropKey.MASTER_MODE)
                    .get("/API/Web/nav-menu", "NavMenu", APIServlet.WEB_CHANNEL, true)
                    .post("/API/Web/login", "Login", APIServlet.WEB_CHANNEL, false)
                    .build());
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
    }
    
    public ResponseInfo<List<ADLoginNav>> NavMenu(ServletAction action) throws Exception
    {
        ResultServiceBean<List<ADLoginNav>> result = new ResultServiceBean<>();
        
        try
        {
            LoginAPI loginService = new LoginAPIImplement();
            result = loginService.GetNavMenu(action.request().getString("userID"),getAuthStatus());
            
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        
        if (ArrayUtils.isNotEmpty(result.getMessages()))
        {
            return ResponseInfo.<List<ADLoginNav>>builder()
                    .statusCode(StatusCode.ERROR)
                    .version(String.valueOf(MiscUtility.todayMillis()))
                    .globals(result.getMessages())
                    .build();
        }
        
        List<ADLoginNav> resultBean = result.getResult();
        return ResponseInfo.<List<ADLoginNav>>builder()
                .statusCode(StatusCode.OK)
                .version(String.valueOf(MiscUtility.todayMillis()))
                .entity(resultBean)
                .build();
    }

    public ResponseInfo<LoginResult> Login(ServletAction action) throws Exception
    {

        ResultServiceBean<LoginResult> result = new ResultServiceBean<>();
        EntityServiceBean<LoginBean> bean = fromBody(action, new TypeReference<EntityServiceBean<LoginBean>>()
        {
        });

        try
        {
            LoginAPI loginService = new LoginAPIImplement();
            result = loginService.Login(bean, getAuthStatus());

        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }

        if (ArrayUtils.isNotEmpty(result.getMessages()))
        {
            return ResponseInfo.<LoginResult>builder()
                    .statusCode(StatusCode.ERROR)
                    .version(String.valueOf(MiscUtility.todayMillis()))
                    .globals(result.getMessages())
                    .build();
        }

        LoginResult resultBean = result.getResult();
        return ResponseInfo.<LoginResult>builder()
                .statusCode(StatusCode.OK)
                .version(String.valueOf(MiscUtility.todayMillis()))
                .entity(resultBean)
                .build();
    }
}
