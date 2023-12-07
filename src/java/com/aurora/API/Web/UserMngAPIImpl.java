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
import com.aurora.API.Bean.Web.UserMngDeleteBean;
//import com.aurora.API.Bean.Web.UserMngCreateBean;
//import com.aurora.API.Bean.Web.OdrchklstDeleteBean;
//import com.aurora.API.Bean.Web.OdrchklstDetailsBean;
//import com.aurora.API.Bean.Web.OdrchklstDetailsViewResult;
import com.aurora.API.Bean.Web.UserMngPagination;
import com.aurora.API.Bean.Web.UserMngResult;
//import com.aurora.API.Bean.Web.UserMngResult;
import com.aurora.API.Bean.Web.UserMngSearchBean;
import com.aurora.API.Bean.Web.UserMngSearchResult;
import com.aurora.API.Bean.Web.UserMngUpdateBean;
import com.aurora.API.Bean.Web.UserMngViewResult;
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
import com.aurora.Utility.EncryptorUtils;
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

    private PosuserSQL posuserSQL = null;
    private ResultServiceBean<UserMngResult> itemResult = null;

    private ResultServiceBean<UserMngResult> createResult = null;
    private ResultServiceBean<UserMngViewResult> viewResult = null;
    private ResultServiceBean<UserMngPagination> searchResult = null;
    private ResultServiceBean<UserMngResult> updateResult = null;
    private ResultServiceBean<UserMngResult> deleteResult = null;

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

            posuserSQL = new PosuserSQL(conn);

            posuserSQL.setUSR_ID(userCreateBean.getUserID());
            posuserSQL.setUSR_PSW(EncryptorUtils.encrypt(userCreateBean.getUserPsw()));
            posuserSQL.setUSR_PIN(userCreateBean.getUserPin());
            // Set other properties accordingly

            posuserSQL.insert();

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

    @Override
    public ResultServiceBean<UserMngResult> update(EntityServiceBean<UserMngUpdateBean> esb, AuthStatus as) {
       UserMngResult resultBean = new UserMngResult();
        messages = new ArrayList<>();
        itemResult = new ResultServiceBean<>();
        try {
             conn = SourceConnector.openTenantConn(as.getConnectionProp(), false);
            if (esb.getEntity().size() > 1) {
                messages.add(MessageHelper.getMessage(conn, "NALLOW_MULTI_RECORDS"));
                errorFlag = true;
            }

            if (errorFlag == false) {
                for (UserMngUpdateBean beanItem : esb.getEntity()) {
                    validateUpdate(beanItem);

                    if (errorFlag == false) {
                        updateItem(beanItem);
                        resultBean = setItemResultBean(posuserSQL);
                        itemResult.setResultBean(resultBean);

                        conn.commit();
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            messages.add(ex.getMessage() == null ? ex.toString() : ex.getMessage().toString());

            JdbcHelper.rollback(conn);
        } finally {
            closeConnection();
        }
        itemResult.setMessages(this.messages.toArray(new String[this.messages.size()]));
        return itemResult;
    }

        private void updateItem(UserMngUpdateBean beanItem) throws Exception {
        posuserSQL = new PosuserSQL(conn);
        posuserSQL.setUSR_ID(beanItem.getUserID());
        posuserSQL.setUSR_PSW(beanItem.getUserPsw());
        posuserSQL.setUSR_PIN(beanItem.getUserPin());
        posuserSQL.setFIRST_NAME(beanItem.getFirstName());
        posuserSQL.setLAST_NAME(beanItem.getLastName());
        posuserSQL.setUSR_EMAIL(beanItem.getEmail());
        posuserSQL.setCONTACT(beanItem.getContactNumber());
        posuserSQL.setALLOW_VOID(beanItem.getAllowVoid());
        posuserSQL.setTITLE(beanItem.getTitle());
        posuserSQL.setAUTHORIZATION(beanItem.getAuthorization());
        posuserSQL.setCREATED_BY(beanItem.getCreateBy());
        posuserSQL.setUSR_ACTIVE_CD(beanItem.getUserStatus());
//        posuserSQL.setLAST_VERSION(beanItem.getLastVersion());
        posuserSQL.setDATE_CREATED(MiscUtility.getSqlSysDate());
        posuserSQL.setLAST_OPR(beanItem.getUserID());
        posuserSQL.setLAST_OPR_FUNCT("UPDATE USER");
        posuserSQL.update();
    }
    
    private UserMngResult setItemResultBean(PosuserSQL itemmstSQL) throws Exception {
        UserMngResult resultBean = new UserMngResult();

        resultBean.setUserID(itemmstSQL.USR_ID());
        resultBean.setUserPsw(itemmstSQL.USR_PSW());
        resultBean.setUserPin(itemmstSQL.USR_PIN());
        resultBean.setFirstName(itemmstSQL.FIRST_NAME());
        resultBean.setLastName(itemmstSQL.LAST_NAME());
        resultBean.setEmail(itemmstSQL.USR_EMAIL());
        resultBean.setContactNumber(itemmstSQL.CONTACT());
        resultBean.setAllowVoid(itemmstSQL.ALLOW_VOID());
        resultBean.setTitle(itemmstSQL.TITLE());
        resultBean.setAuthorization(itemmstSQL.AUTHORIZATION());
        resultBean.setDateCreate(itemmstSQL.DATE_CREATED() == null ? "" : MiscUtility.parseDate(itemmstSQL.DATE_CREATED()));
        resultBean.setCreateBy(itemmstSQL.CREATED_BY());
        resultBean.setUserStatus(itemmstSQL.USR_ACTIVE_CD());
        resultBean.setLastVersion(String.valueOf(itemmstSQL.LAST_VERSION()));

        return resultBean;
    }

    
        private void validateUpdate(UserMngUpdateBean beanItem) throws Exception {
        if (org.apache.commons.lang.StringUtils.isBlank(beanItem.getUserID())) {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "User Id"));
            errorFlag = true;
        }

        if (org.apache.commons.lang.StringUtils.isBlank(beanItem.getFirstName())) {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "First Name"));
            errorFlag = true;
        } 
        verifyItem(beanItem.getUserID(), beanItem.getLastVersion());
    }

        
        private void verifyItem(String item, String lastVersion) throws Exception {
        if (org.apache.commons.lang.StringUtils.isBlank(item)) {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "User Id"));
            errorFlag = true;
        } 
    }

    
    @Override
    public ResultServiceBean<UserMngResult> delete(EntityServiceBean<UserMngDeleteBean> bean, AuthStatus authStatus) {
        UserMngResult resultItem = null;
        messages = new ArrayList<>();
        deleteResult = new ResultServiceBean<>();
        try {
            conn = SourceConnector.openTenantConn(authStatus.getConnectionProp(), false);

            for (UserMngDeleteBean beanItem : bean.getEntity()) {
                validateDelete(beanItem);

                if (!errorFlag) {
                    resultItem = new UserMngResult();

                    posuserSQL.setUSR_ACTIVE_CD("N");
                    posuserSQL.update();

                    posuserSQL.getByKey();

                    resultItem.setUserID(posuserSQL.USR_ID());
                    resultItem.setEmail(posuserSQL.USR_EMAIL());
                    resultItem.setLastVersion(String.valueOf(posuserSQL.LAST_VERSION()));

                    deleteResult.setResultBean(resultItem);

                    conn.commit();
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            messages.add(ex.getMessage() == null ? ex.toString() : ex.getMessage().toString());
            JdbcHelper.rollback(conn);

        } finally {
            JdbcHelper.close(conn);
            conn = null;
        }
        deleteResult.setMessages(this.messages.toArray(new String[this.messages.size()]));

        return deleteResult;
    }
    
    
    private void validateDelete(UserMngDeleteBean beanItem) throws Exception {
        long lastVersion = 0L;
        try {
            lastVersion = Long.parseLong(beanItem.getLastVersion());
        } catch (NumberFormatException ex) {
            messages.add("Last Version must be numbers only");
            errorFlag = true;
        }

        if (org.apache.commons.lang.StringUtils.isBlank(beanItem.getUserID())) {
            messages.add(MessageHelper.getMessage(conn, MessageHelper.EMPTY_FIELD, "User Id"));
            errorFlag = true;
        } else {
            if (posuserSQL == null) {
                posuserSQL = new PosuserSQL(conn);
            }

            posuserSQL.setUSR_ID(beanItem.getUserID());

            if (posuserSQL.getByKey() > 0) {
                if (org.apache.commons.lang.StringUtils.equals("N", posuserSQL.USR_ACTIVE_CD())) {
                    messages.add(MessageHelper.getMessage(conn, "INACTIVE", "Item"));
                    errorFlag = true;
                } else if (posuserSQL.LAST_VERSION() != lastVersion) {
                    messages.add(MessageHelper.getMessage(conn, "RECORD_MODIFIED"));
                    errorFlag = true;
                }
            }
        }
    }

    @Override
    public ResultServiceBean<UserMngViewResult> view(UserMngViewResult bean, AuthStatus authStatus) {
        UserMngResult resultBean = new UserMngResult();
        viewResult = new ResultServiceBean<>();
        messages = new ArrayList<>();
        try {
             conn = SourceConnector.openTenantConn(authStatus.getConnectionProp(), false);
            validateViewBean(bean);
            
            if (!errorFlag) {
                resultBean = setItemResultBean(posuserSQL);
                itemResult.setResultBean(resultBean);

                conn.commit();
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            messages.add(ex.getMessage() == null ? ex.toString() : ex.getMessage());
            JdbcHelper.rollback(conn);
        } finally {
            this.closeDBConnection();
        }

        viewResult.setMessages(this.messages.toArray(new String[this.messages.size()]));
        return viewResult;
    }
    

        private void validateViewBean(UserMngViewResult viewBean) throws Exception {
        if (StringUtils.isBlank(viewBean.getLastVersion())) {
            messages.add(MessageHelper.getMessage(gnrlConn, "EMPTY_FIELD", "Last Version"));
            errorFlag = true;
        }

        if (StringUtils.isBlank(viewBean.getUserID())) {
            messages.add(MessageHelper.getMessage(gnrlConn, "EMPTY_FIELD", "PO Checklist No"));
            errorFlag = true;
        }

        if (!errorFlag) {
            if (posuserSQL == null) {
                posuserSQL = new PosuserSQL(conn);
            }
            posuserSQL.setUSR_ID(viewBean.getUserID());
            if (posuserSQL.getByKey() > 0) {
                if (Long.parseLong(viewBean.getLastVersion()) != posuserSQL.LAST_VERSION()) {
                    messages.add(MessageHelper.getMessage(gnrlConn, "RECORD_MODIFIED"));
                    errorFlag = true;
                }
            }
        }
    }

}
