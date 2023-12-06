/*
 *         Copyright (C) 2021, AURORA Developers
 *                  All rights reserved.
 * 
 *            Code Owner : AURORA Developers
 * 
 *            @version LoginAPIImpl.java Jul 11, 2021 Zoey
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
import com.aurora.API.GenericAPI;
import com.aurora.DataSource.DBConnector;
import com.aurora.DataSource.JdbcHelper;
import com.aurora.DataSource.Params;
import com.aurora.DataSource.SourceConnector;
import com.aurora.Model.PosuserInfo;
import com.aurora.Model.PosuserSQL;
import com.aurora.Servlet.API.AuthStatus;
import com.aurora.Utility.EncryptorUtils;
import com.aurora.Utility.HParam;
import com.aurora.Utility.MessageHelper;
import com.aurora.Utility.Token.JWTHelper;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang.StringUtils;

/**
 *
 * @author Zoey
 */
public class LoginAPIImplement extends GenericAPI implements LoginAPI
{

    private ResultServiceBean<LoginResult> loginResult = null;
    private ResultServiceBean<List<ADLoginNav>> navResult = null;

    private PosuserSQL posuserSQL = null;

    private List<String> messages = null;
    private boolean errorFlag = false;
    
    @Override
    public ResultServiceBean<List<ADLoginNav>> GetNavMenu(String userID, AuthStatus authStatus)
    {
        messages = new ArrayList<>();
        List<ADLoginNav> navList = new ArrayList<>();
        navResult = new ResultServiceBean<>();
        try
        {
            ;
            
            if(StringUtils.isBlank(userID))
            {
                messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "User Id"));
                errorFlag = true;
            }
            
            if(!errorFlag)
            {
                System.out.println("User ID :" + userID);
                navList = getNavigationMenu(userID);

                navResult.setResultBean(navList);
            }
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
            messages.add(ex.getMessage() == null ? ex.toString() : ex.getMessage().toString());

            try
            {
                conn.rollback();
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }
        finally
        {
            closeConnection();
        }

        navResult.setMessages(this.messages.toArray(new String[this.messages.size()]));
        return navResult;
        
    }

    @Override
    public ResultServiceBean<LoginResult> Login(EntityServiceBean<LoginBean> bean, AuthStatus authStatus)
    {
        messages = new ArrayList<>();
        LoginResult resultBean = new LoginResult();
        loginResult = new ResultServiceBean<>();

        try
        {
            for (LoginBean beanItem : bean.getEntity())
            {
                conn = SourceConnector.openTenantConn(authStatus.getConnectionProp(), false);
                validateLogin(beanItem);

                if (errorFlag == false)
                {
                    if (!EncryptorUtils.decrypt(posuserSQL.USR_PSW()).equals(beanItem.getPassword()))
                    {
                        messages.add(MessageHelper.getMessage(conn, "WEB_INV_PSW"));
                        errorFlag = true;

                        posuserSQL.setERROR_LOGIN(posuserSQL.ERROR_LOGIN() + 1);
                        posuserSQL.update();
                    }
                    else
                    {
                        posuserSQL.setERROR_LOGIN(0);
                        posuserSQL.update();
                    }
                }

                if (errorFlag == false)
                {
                    resultBean.setUserId(posuserSQL.USR_ID());
                    resultBean.setAllowVoid(posuserSQL.ALLOW_VOID());
                    resultBean.setAuthorization(posuserSQL.AUTHORIZATION());
                    resultBean.setFirstName(posuserSQL.FIRST_NAME());
                    resultBean.setLastName(posuserSQL.LAST_NAME());
                    authStatus.setUserId(posuserSQL.USR_ID());
                    resultBean.setToken(JWTHelper.INSTANCE.generate(conn, authStatus));

                    resultBean.setNavigationMenu(getNavigationMenu(posuserSQL.USR_ID()));

                    loginResult.setResultBean(resultBean);
                }
                conn.commit();
            }
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
            messages.add(ex.getMessage() == null ? ex.toString() : ex.getMessage().toString());

            try
            {
                conn.rollback();
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }
        finally
        {
            closeConnection();
        }

        loginResult.setMessages(this.messages.toArray(new String[this.messages.size()]));
        return loginResult;
    }

    private void validateLogin(LoginBean beanItem) throws Exception
    {
        if (StringUtils.isBlank(beanItem.getUserId()))
        {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "User ID"));
            errorFlag = true;
        }
        else
        {
            if (getPosuser(beanItem.getUserId()) == 0)
            {
                messages.add(MessageHelper.getMessage(conn, "NE_FIELD", "User ID"));
                errorFlag = true;
            }
            else
            {
                if ("N".equalsIgnoreCase(posuserSQL.USR_ACTIVE_CD()))
                {
                    messages.add(MessageHelper.getMessage(conn, "INACTIVE_ACC", "User ID"));
                    errorFlag = true;
                }
                else if (posuserSQL.ERROR_LOGIN() >= 3)
                {
                    messages.add(MessageHelper.getMessage(conn, "LOCKED_ACC", "User ID"));
                    errorFlag = true;

                    posuserSQL.setUSR_ACTIVE_CD("N");
                    posuserSQL.update();
                }
            }

        }

        if (StringUtils.isBlank(beanItem.getPassword()))
        {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "Password"));
        }
    }

    private int getPosuser(String userId) throws Exception
    {
        if (posuserSQL == null)
        {
            posuserSQL = new PosuserSQL(conn);
        }
        else
        {
            posuserSQL.setVObject(new PosuserInfo().getVObject());
        }

        posuserSQL.setUSR_ID(userId);
        return posuserSQL.getByKey();
    }

    private List<ADLoginNav> getNavigationMenu(String userID) throws Exception
    {
        String query = "SELECT H.MENU_ID, H.MENU_TITLE, SUBMENU_ID, D.AUTHORIZATION,  "
                       + "MENU_TITLE, CHILD_TITLE,H.PROG_NAME AS MODULE_PAGE, "
                       + "H.POS_PROG_NAME AS POS_MODULE_PAGE,H.ICON_NAME, "
                       + "D.PROG_NAME, D.POS_PROG_NAME, D.IP_ADDR "
                       + "FROM POSMENUHDR H, POSMENUDET D, POSUSER P "
                       + "WHERE H.MENU_ID = D.MENU_ID "
                       + "AND D.AUTHORIZATION = P.AUTHORIZATION "
                       + "AND P.USR_ID = ? "
                       + "AND H.ENABLED = 'Y' "
                       + "AND WEB_MENU = 'Y' "
                       + "AND D.ENABLED = 'Y' "
                       + "ORDER BY H.SEQ";
        ResultSet rs = null;

        List<ADLoginNav> modules = new ArrayList<>();
        List<ADLoginNav> submodules = null;
        ADLoginNav navMenu = null;

        String prevMenu = "";

        try
        {
            rs = JdbcHelper.select(conn, query, Params.builder(1).set(userID).build());

            while (rs != null && rs.next())
            {
                if (!StringUtils.equals(rs.getString("MENU_ID"), prevMenu))
                {
                    if (submodules != null)
                    {
                        navMenu.setSubNavigation(submodules);
                    }

                    if (navMenu != null)
                    {
                        modules.add(navMenu);
                    }

                    navMenu = new ADLoginNav();
                    navMenu.setNavHeader(rs.getString("MENU_TITLE"));
                    navMenu.setNavIcon(rs.getString("ICON_NAME"));
                    
                    
                    if (!StringUtils.isEmpty(rs.getString("MODULE_PAGE")))
                    {
                        navMenu.setNavPage(rs.getString("MODULE_PAGE"));
                    }
                    else
                    {
                        submodules = new ArrayList<>();

                        ADLoginNav submodule = new ADLoginNav();
                        submodule.setNavHeader(rs.getString("CHILD_TITLE"));
                        submodule.setNavPage(rs.getString("PROG_NAME"));
                        submodule.setNavIP(rs.getString("IP_ADDR"));
                        submodules.add(submodule);

                        submodule = null;
                    }

                }
                else
                {
                    if (submodules == null)
                    {
                        submodules = new ArrayList<>();
                    }

                    ADLoginNav submodule = new ADLoginNav();
                    submodule.setNavHeader(rs.getString("CHILD_TITLE"));
                    submodule.setNavPage(rs.getString("PROG_NAME"));
                    submodule.setNavIP(rs.getString("IP_ADDR"));
                    submodules.add(submodule);

                    submodule = null;
                }

                prevMenu = rs.getString("MENU_ID");
            }

            if (submodules != null)
            {
                navMenu.setSubNavigation(submodules);
            }

            modules.add(navMenu);

        }
        catch (Exception ex)
        {
            ex.printStackTrace();
            throw ex;
        }

        finally
        {
            JdbcHelper.close(rs);
        }
        
        return modules;
    }

    private void closeCommonObject()
    {
        posuserSQL = null;
    }

    
}
