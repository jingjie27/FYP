/*
 * Here comes the text of your license
 * Each line should be prefixed with  * 
 */
package com.aurora.Servlet.API;

import com.aurora.API.Bean.EntityServiceBean;
import com.aurora.API.Bean.ResultServiceBean;
import com.aurora.API.Bean.Web.LoginResult;
import com.aurora.DataSource.JdbcHelper;
import com.aurora.Model.TokengtwySQL;
import com.aurora.Model.Util.SearchDataList;
import com.aurora.Servlet.API.Message.ResponseInfo;
import com.aurora.Servlet.API.Utils.Jackson;
import com.aurora.Servlet.API.Utils.StatusCode;
import com.aurora.Utility.HParam;
import com.aurora.Utility.MiscUtility;
import com.aurora.Utility.WebMisc;
import com.fasterxml.jackson.core.type.TypeReference;
import java.sql.Connection;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import com.aurora.DataSource.DBConnector;
import com.aurora.DataSource.SourceConnector;
import com.aurora.Model.AuroraparamSQL;
import java.sql.Date;
import java.text.SimpleDateFormat;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;

/**
 *
 * @author henry
 */
public class SvltCommonAPI extends APIServlet
{
    @Override
    public void init(ServletConfig servletConfig) throws ServletException
    {

        try
        {
            register(APIServlet.ActionBuilder.of(this)
                    .jackson(true)
                    .ofInstance(SourceConnector.PropKey.MASTER_MODE)
                    .post("/API/common/session/set", "set", APIServlet.WEB_CHANNEL, false)
                    .post("/API/common/session/login", "setLogin", APIServlet.WEB_CHANNEL, false)
                    .get("/API/common/session/retrieve", "retrieveAuth", APIServlet.WEB_CHANNEL, false)
                    .build());
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
    }

    public ResponseInfo<Object> set(ServletAction action) throws Exception
    {
        ResultServiceBean<Object> result = new ResultServiceBean<>();
        SearchDataList bean = fromBody(action, new TypeReference<SearchDataList>()
        {
        });

        try
        {
            String name = action.request().getNativeRequest().getHeader("X-Session-Store");

            if (!StringUtils.isBlank(name))
            {
                System.out.println("Setting Cookie");
                Cookie cookie = new Cookie(name, Jackson.toJson(bean).replaceAll(",", "%44").replaceAll("\"", "'").replaceAll(" ", "%32").replaceAll("=", "%61"));
                cookie.setMaxAge(60);
//                cookie.setHttpOnly(true);
//                cookie.setSecure(true);
//                cookie.setPath("/");
//                cookie.setDomain("/");

                action.response().getNativeResponse().addCookie(cookie);
                
//                HttpSession session = action.request().getNativeRequest().getSession();
//                session.setAttribute(name, Jackson.toJson(bean));
//                System.out.println("Session SET = " + action.request().getNativeRequest().getSession().getId());
            }
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }

        if (ArrayUtils.isNotEmpty(result.getMessages()))
        {
            return ResponseInfo.<Object>builder()
                    .statusCode(StatusCode.ERROR)
                    .version(String.valueOf(MiscUtility.todayMillis()))
                    .globals(result.getMessages())
                    .build();
        }

        return ResponseInfo.<Object>builder()
                .statusCode(StatusCode.OK)
                .version(String.valueOf(MiscUtility.todayMillis()))
                .entity(new Object())
                .build();
    }

    
    public ResponseInfo<Object> setLogin(ServletAction action) throws Exception
    {
        ResultServiceBean<Object> result = new ResultServiceBean<>();
        EntityServiceBean<LoginResult> bean = fromBody(action, new TypeReference<EntityServiceBean<LoginResult>>()
        {
        });

        HttpSession session = action.request().getNativeRequest().getSession();
        Connection conn = null;
        AuroraparamSQL auroraparamSQL = null;
        TokengtwySQL tokengtwySQL = null;

        try
        {

            if (StringUtils.isBlank(action.request().getHeader("X-Access-ID")))
            {
                result.setMessages(new String[]
                {
                    "Access ID cannot be blank"
                });
            }
            else
            {
                conn = SourceConnector.openTenantConn(getAuthStatus().getConnectionProp(), false);

                if (bean.getEntity().size() == 1)
                {
                    for (LoginResult resultBean : bean.getEntity())
                    {
                        auroraparamSQL = new AuroraparamSQL(conn);
                        tokengtwySQL = new TokengtwySQL(conn);

                        HParam loginInfo = new HParam();

                        loginInfo.put("USR_ID", resultBean.getUserId());
                        loginInfo.put("FIRST_NAME", StringUtils.defaultIfEmpty(resultBean.getFirstName(), ""));
                        loginInfo.put("LAST_NAME", StringUtils.defaultIfEmpty(resultBean.getLastName(), ""));
                        loginInfo.put("USR_EMAIL", StringUtils.defaultIfEmpty(resultBean.getUserEmail(), ""));
                        loginInfo.put("ALLOW_VOID", StringUtils.defaultIfEmpty(resultBean.getAllowVoid(), ""));
                        loginInfo.put("AUTH_LVL", StringUtils.defaultIfEmpty(resultBean.getAuthorization(), ""));

                        session.setAttribute("LOGIN_USER", loginInfo);
                        session.setAttribute("MENU_NAV", resultBean.getNavigationMenu());
                        HParam testUser = (HParam) session.getAttribute("LOGIN_USER");

                        auroraparamSQL.setPARAM_CODE("TokenValidityDuration");
                        auroraparamSQL.getByKey();

                        Date expiry = new Date(MiscUtility.todayMillis() + (Integer.parseInt(auroraparamSQL.PARAM_VALUE()) * 60 * 1000));

                       
                        tokengtwySQL.setSESSION_ID(action.request().getHeader("X-Access-ID"));
                        tokengtwySQL.setTOKEN(resultBean.getToken());
                        tokengtwySQL.setDATE_GENERATED(MiscUtility.today());
                        tokengtwySQL.setTIME_GENERATED(MiscUtility.todayTime());
                        tokengtwySQL.setDATE_EXPIRY(MiscUtility.parseDate(expiry));
                        tokengtwySQL.setTIME_EXPIRY(new SimpleDateFormat("HH:mm:ss").format(expiry));
                        tokengtwySQL.setEXPIRY_MS(expiry.getTime());
                        tokengtwySQL.setLAST_OPR(resultBean.getUserId());

                        if (tokengtwySQL.checkKeyExist() > 0)
                        {
                            tokengtwySQL.update();
                        }
                        else
                        {
                            tokengtwySQL.insert();
                        }

                        auroraparamSQL = null;
                        tokengtwySQL = null;
                    }
                }
                else
                {
                    result.setMessages(new String[]
                    {
                        "Only 1 Cookie is allowed"
                    });
                }
            }

        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
        finally
        {
            if(conn != null)
                conn.commit();
            JdbcHelper.close(conn);
        }

        if (ArrayUtils.isNotEmpty(result.getMessages()))
        {
            return ResponseInfo.<Object>builder()
                    .statusCode(StatusCode.ERROR)
                    .version(String.valueOf(MiscUtility.todayMillis()))
                    .globals(result.getMessages())
                    .build();
        }

        return ResponseInfo.<Object>builder()
                .statusCode(StatusCode.OK)
                .version(String.valueOf(MiscUtility.todayMillis()))
                .entity(new Object())
                .build();
    }

    public ResponseInfo<String> retrieveAuth(ServletAction action) throws Exception
    {
        ResultServiceBean<String> result = new ResultServiceBean<>();
        String token = "";
        boolean errorFlag = false;
        try
        {
            String sessionID = action.request().getNativeRequest().getParameter("SID");
            
            System.out.println("SESSION RET =" + action.request().getNativeRequest().getSession().getId());

            if (StringUtils.isBlank(sessionID))
            {
                result.setMessages(new String[]
                {
                    "Session ID cannot be empty"
                });
                errorFlag = true;
            }
            else
            {
                Connection conn = DBConnector.openCoreConnection(false);
                TokengtwySQL tokengtwySQL = new TokengtwySQL(conn);

                tokengtwySQL.setSESSION_ID(sessionID);

                if (tokengtwySQL.getByKey() == 0)
                {
                    result.setMessages(new String[]
                    {
                        "Session ID is not found please login again"
                    });
                    errorFlag = true;
                }
                else
                {
                    if (MiscUtility.todayMillis() < tokengtwySQL.EXPIRY_MS())
                    {
                        token = tokengtwySQL.TOKEN();
                    }
                }

            }
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }

        if (ArrayUtils.isNotEmpty(result.getMessages()))
        {
            return ResponseInfo.<String>builder()
                    .statusCode(StatusCode.ERROR)
                    .version(String.valueOf(MiscUtility.todayMillis()))
                    .globals(result.getMessages())
                    .build();
        }

        return ResponseInfo.<String>builder()
                .statusCode(StatusCode.OK)
                .version(String.valueOf(MiscUtility.todayMillis()))
                .entity(token)
                .build();
    }
}
