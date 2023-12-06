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
 *            @version OdrchklstAPI.java 3 Nov 2023 yeehao
 *            @author  yeehao
 *            @since   3 Nov 2023
 * 
 */
package com.aurora.API.Web;

import com.aurora.API.Bean.EntityServiceBean;
import com.aurora.API.Bean.ResultServiceBean;
import com.aurora.API.Bean.Web.UserMngCreateBean;
//import com.aurora.API.Bean.Web.UserMngCreateBean;
//import com.aurora.API.Bean.Web.OdrchklstDeleteBean;
//import com.aurora.API.Bean.Web.OdrchklstDetailsBean;
//import com.aurora.API.Bean.Web.OdrchklstDetailsViewResult;
import com.aurora.API.Bean.Web.UserMngPagination;
import com.aurora.API.Bean.Web.UserMngResult;
//import com.aurora.API.Bean.Web.UserMngResult;
import com.aurora.API.Bean.Web.UserMngSearchBean;
import com.aurora.API.Bean.Web.UserMngSearchResult;
//import com.aurora.API.Bean.Web.OdrchklstUpdateBean;
//import com.aurora.API.Bean.Web.OdrchklstViewBean;
//import com.aurora.API.Bean.Web.OdrchklstViewResult;
import com.aurora.API.GenericAPI;
import com.aurora.DataSource.JdbcHelper;
import com.aurora.DataSource.Params;
import com.aurora.DataSource.SourceConnector;
import com.aurora.Model.AuroraparamSQL;
import com.aurora.Model.ItemmstSQL;
import com.aurora.Model.PochklstdetSQL;
import com.aurora.Model.PochklsthdrInfo;
import com.aurora.Model.PochklsthdrSQL;
import com.aurora.Model.PosuserInfo;
import com.aurora.Model.PosuserSQL;
import com.aurora.Model.StoremstSQL;
import com.aurora.Model.SupplcontractSQL;
import com.aurora.Model.SupplmstSQL;
import com.aurora.Servlet.API.AuthStatus;
import com.aurora.Utility.HParam;
import com.aurora.Utility.MessageHelper;
import com.aurora.Utility.MiscUtility;
import java.sql.Connection;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.sql.Date;
import java.util.Enumeration;
import java.util.List;
import org.apache.commons.lang3.StringUtils;

/**
 *
 * @author yeehao
 */
public class UserMngAPIImpl extends GenericAPI implements UserMngAPI {

    private List<String> messages = null;
    private boolean errorFlag = false;

    private PosuserSQL posuserSQLSQL = null;

    private ResultServiceBean<UserMngResult> createResult = null;
//    private ResultServiceBean<OdrchklstViewResult> viewResult = null;
    private ResultServiceBean<UserMngPagination> searchResult = null;
//    private ResultServiceBean<UserMngPagination> searchPochklstResult = null;
//    private ResultServiceBean<UserMngResult> deleteResult = null;
//    private ResultServiceBean<UserMngResult> updateResult = null;

    private Connection gnrlConn = null;

    
    @Override
public ResultServiceBean<UserMngResult> create(EntityServiceBean<UserMngCreateBean> bean, AuthStatus authStatus) {
    createResult = new ResultServiceBean<>();
    messages = new ArrayList<>();

    try {
        conn = SourceConnector.openTenantConn(authStatus.getConnectionProp(), false);

        if (bean.getEntity().size() > 1) {
            messages.add(MessageHelper.getMessage(conn, "NALLOW_MULTI_RECORDS"));
            errorFlag = true;
        } else {
            // Assuming UserMngCreateBean has appropriate getters for the data
            UserMngCreateBean userCreateBean = bean.getEntity().get(0);

            posuserSQLSQL = new PosuserSQL(conn);

            posuserSQLSQL.setUSR_ID(userCreateBean.getUserID());
            posuserSQLSQL.setUSR_PSW(userCreateBean.getUserPsw());
            posuserSQLSQL.setUSR_PIN(userCreateBean.getUserPin());
            // Set other properties accordingly

            posuserSQLSQL.insert();

            conn.commit();
        }

    } catch (Exception ex) {
        ex.printStackTrace();
        messages.add(ex.getMessage() == null ? ex.toString() : ex.getMessage());
        JdbcHelper.rollback(conn);
    } finally {
        this.closeDBConnection();
    }

    createResult.setMessages(this.messages.toArray(new String[this.messages.size()]));
    return createResult;
}


    private void openDBConnection(HParam prop, String uId, boolean openMst, boolean openGnrl) throws Exception {
        // Buying DB Connection refer back to the ofInstance() in the SvltOdrchklstAPI
        conn = SourceConnector.openTenantConn(prop, false);

        gnrlConn = SourceConnector.openTenantConn(uId, SourceConnector.PropKey.GENERAL_MODE, false);
    }
    
    @Override
    public ResultServiceBean<UserMngPagination> search(UserMngSearchBean bean, AuthStatus authStatus) {

        messages = new ArrayList<>();
        searchResult = new ResultServiceBean<>();

        try {
            conn = SourceConnector.openTenantConn(authStatus.getConnectionProp(), false);
            searchResult.setResultBean(searchUserMng(bean));
        } catch (Exception ex) {
            ex.printStackTrace();
            messages.add(ex.getMessage() == null ? ex.toString() : ex.getMessage().toString());
            JdbcHelper.rollback(conn);

        } finally {
            JdbcHelper.close(conn);
            conn = null;
        }
        searchResult.setMessages(this.messages.toArray(new String[this.messages.size()]));
        return searchResult;
    }

    private UserMngPagination searchUserMng(UserMngSearchBean beanItem) throws Exception {

        String query = "SELECT \n"
                + " COUNT(1) OVER() AS TOTAL_ROWS, \n"
                + " USR_ID, \n"
                + " FIRST_NAME, \n"
                + " LAST_NAME, \n"
                + " USR_EMAIL, \n"
                + " TITLE, \n"
                + " AUTHORIZATION, \n"
                + " DATE_CREATED, \n"
                + " LAST_VERSION\n"
                + "FROM POSUSER";
        String criteria = "";
        String orderBy = " ORDER BY USR_ID";

        int currentPage = beanItem.getCurrentPage();
        int pageSize = 10;
        int totalRows = -1;

        HParam params = new HParam();
        Params.Builder sqlParams = null;
        ResultSet rs;
        List<UserMngSearchResult> resultList = null;

        if (currentPage <= 0) {
            currentPage = 1;
        }
        if (pageSize <= 0) {
            pageSize = Integer.parseInt(getAuroraparam("SYSSearchRecordPerPage"));
        }

        beanItem.setCurrentPage(currentPage);
        beanItem.setPageSize(pageSize);
        String pagination = " LIMIT " + pageSize + " OFFSET " + ((currentPage - 1) * pageSize) + " ";

        if (StringUtils.isNotBlank(beanItem.getUserID())) {
            params.put("USR_ID", beanItem.getUserID());
        }

        if (StringUtils.isNotBlank(beanItem.getFirstName())) {
            params.put("FIRST_NAME", beanItem.getFirstName());
        }

        if (StringUtils.isNotBlank(beanItem.getLastName())) {
            params.put("LAST_NAME", beanItem.getLastName());
        }

        if (StringUtils.isNotBlank(beanItem.getEmail())) {
            params.put("USR_EMAIL", beanItem.getEmail());
        }

        if (StringUtils.isNotBlank(beanItem.getTitle())) {
            params.put("TITLE", beanItem.getTitle());
        }

        if (StringUtils.isNotBlank(beanItem.getAuthorization())) {
            params.put("AUTHORIZATION", beanItem.getAuthorization());
        }
        if (StringUtils.isNotBlank(beanItem.getCreateDate())) {
            params.put("DATE_CREATED", beanItem.getCreateDate());
        }

        if (params.size() > 0) {
            Enumeration<String> enumerator = params.keys();
            sqlParams = Params.builder(params.size());

            while (enumerator.hasMoreElements()) {
                String key = enumerator.nextElement();

                if (StringUtils.isNotBlank(criteria)) {
                    criteria += " AND ";
                }

                if (StringUtils.contains(params.getString(key), "LIKE")) {
                    criteria += key + " LIKE ?";
                } else {
                    criteria += key + " = ?";
                }

                sqlParams.set(StringUtils.replace(params.getString(key), "LIKE", "").trim());
            }

            criteria = " WHERE " + criteria;
        }

        query += criteria + orderBy + pagination;

        if (params.size() > 0) {
            rs = JdbcHelper.select(conn, query, sqlParams.build());
        } else {
            rs = JdbcHelper.select(conn, query);
        }

        while (rs != null && rs.next()) {
            if (resultList == null) {
                resultList = new ArrayList<>();
            }

            if (totalRows == -1) {
                totalRows = rs.getInt("TOTAL_ROWS");
            }
            UserMngSearchResult result = new UserMngSearchResult();

            result.setUserID(rs.getString("USR_ID"));
            result.setFirstName(rs.getString("FIRST_NAME"));
            result.setLastName(rs.getString("LAST_NAME"));
            result.setEmail(rs.getString("USR_EMAIL"));
            result.setTitle(rs.getString("TITLE"));
            result.setAuthorization(rs.getString("AUTHORIZATION"));
              result.setCreateDate(rs.getString("DATE_CREATED"));
            result.setLastVersion(rs.getString("LAST_VERSION"));

            resultList.add(result);
        }

        UserMngPagination userMngResult = new UserMngPagination(currentPage, pageSize, totalRows);
        userMngResult.setUserMng(resultList);

        return userMngResult;
    }

    
    private String getAuroraparam(String paramCode) throws Exception {
        String paramValue = "";

        if (this.auroraparamSQL == null) {
            this.auroraparamSQL = new AuroraparamSQL(conn);
        }

        this.auroraparamSQL.setPARAM_CODE(paramCode);
        if (this.auroraparamSQL.getByKey() > 0) {
            paramValue = this.auroraparamSQL.PARAM_VALUE();
        }

        return paramValue;
    }

    private void closeDBConnection() {
        if (conn != null) {
            JdbcHelper.close(conn);
            conn = null;
        }
        if (gnrlConn != null) {
            JdbcHelper.close(gnrlConn);
            gnrlConn = null;
        }
    }
}
