
package com.aurora.API.Web;

import com.aurora.API.Bean.EntityServiceBean;
import com.aurora.API.Bean.ResultServiceBean;
import com.aurora.API.Bean.Web.UserMngCreateBean;
import com.aurora.API.Bean.Web.UserMngDeleteBean;
import com.aurora.API.Bean.Web.UserMngPagination;
import com.aurora.API.Bean.Web.UserMngResult;
import com.aurora.API.Bean.Web.UserMngSearchBean;
import com.aurora.API.Bean.Web.UserMngSearchResult;
import com.aurora.API.Bean.Web.UserMngUpdateBean;
import com.aurora.API.GenericAPI;
import com.aurora.DataSource.JdbcHelper;
import com.aurora.DataSource.Params;
import com.aurora.DataSource.SourceConnector;
import com.aurora.Model.AuroraparamSQL;
import com.aurora.Model.PosuserSQL;
import com.aurora.Servlet.API.AuthStatus;
import com.aurora.Utility.EncryptorUtils;
import com.aurora.Utility.HParam;
import com.aurora.Utility.MessageHelper;
import com.aurora.Utility.MiscUtility;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import org.apache.commons.lang3.StringUtils;

/**
 *
 * @author jinjie
 */
public class UserMngAPIImpl extends GenericAPI implements UserMngAPI {

    private List<String> messages = null;
    private boolean errorFlag = false;

    private PosuserSQL posuserSQL = null;
    private ResultServiceBean<UserMngResult> userMngResult = null;
    private ResultServiceBean<UserMngResult> createResult = null;
    private ResultServiceBean<UserMngResult> viewResult = null;
    private ResultServiceBean<UserMngPagination> searchResult = null;
    private ResultServiceBean<UserMngResult> deleteResult = null;

    private Connection gnrlConn = null;

    @Override
    public ResultServiceBean<UserMngResult> create(EntityServiceBean<UserMngCreateBean> bean, AuthStatus authStatus) {
        createResult = new ResultServiceBean<>();
        messages = new ArrayList<>();
        UserMngResult resultBean;
        try {
            conn = SourceConnector.openTenantConn(authStatus.getConnectionProp(), false);

            if (bean.getEntity().size() > 1) {
                messages.add(MessageHelper.getMessage(conn, "NALLOW_MULTI_RECORDS"));
                errorFlag = true;
            }

            if (errorFlag == false) {
                for (UserMngCreateBean beanUserMng : bean.getEntity()) {
                     validateCreate(beanUserMng);

                    if (errorFlag == false) {
                        createUserMng(beanUserMng);
                        resultBean = setUserMngResultBean(posuserSQL);
                        createResult.setResultBean(resultBean);

                        conn.commit();
                    }
                }
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

    private void validateCreate(UserMngCreateBean beanUserMng) throws Exception {
        if (org.apache.commons.lang.StringUtils.isBlank(beanUserMng.getUserID())) {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "User Id"));
            errorFlag = true;
        }

        if (org.apache.commons.lang.StringUtils.isBlank(beanUserMng.getFirstName())) {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "First Name"));
            errorFlag = true;
        }

        if (org.apache.commons.lang.StringUtils.isBlank(beanUserMng.getLastName())) {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "Last Name"));
            errorFlag = true;
        }

        if (org.apache.commons.lang.StringUtils.isBlank(beanUserMng.getEmail())) {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "Email"));
            errorFlag = true;
        }
    }

    private void createUserMng(UserMngCreateBean beanUserMng) throws Exception {

        if (posuserSQL == null) {
            posuserSQL = new PosuserSQL(conn);
        }

        posuserSQL.setUSR_ID(beanUserMng.getUserID());
        posuserSQL.setUSR_PSW(EncryptorUtils.encrypt(beanUserMng.getUserPsw()));
        posuserSQL.setUSR_PIN(beanUserMng.getUserPin());
        posuserSQL.setFIRST_NAME(beanUserMng.getFirstName());
        posuserSQL.setLAST_NAME(beanUserMng.getLastName());
        posuserSQL.setUSR_EMAIL(beanUserMng.getEmail());
        posuserSQL.setCONTACT(beanUserMng.getContactNumber());
        posuserSQL.setALLOW_VOID(beanUserMng.getAllowVoid());
        posuserSQL.setTITLE(beanUserMng.getTitle());
        posuserSQL.setAUTHORIZATION(beanUserMng.getAuthorization());
        posuserSQL.setCREATED_BY(beanUserMng.getCreateBy());
        posuserSQL.setUSR_ACTIVE_CD(beanUserMng.getUserStatus());
        posuserSQL.setDATE_CREATED(MiscUtility.getSqlSysDate());
        posuserSQL.setLAST_OPR(beanUserMng.getUserID());
        posuserSQL.setLAST_OPR_FUNCT("ADD-USER");
        posuserSQL.insert();
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

    private UserMngPagination searchUserMng(UserMngSearchBean beanUserMng) throws Exception {

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

        int currentPage = beanUserMng.getCurrentPage();
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

        beanUserMng.setCurrentPage(currentPage);
        beanUserMng.setPageSize(pageSize);
        String pagination = " LIMIT " + pageSize + " OFFSET " + ((currentPage - 1) * pageSize) + " ";

        if (StringUtils.isNotBlank(beanUserMng.getUserID())) {
            params.put("USR_ID", beanUserMng.getUserID());
        }

        if (StringUtils.isNotBlank(beanUserMng.getFirstName())) {
            params.put("FIRST_NAME", beanUserMng.getFirstName());
        }

        if (StringUtils.isNotBlank(beanUserMng.getLastName())) {
            params.put("LAST_NAME", beanUserMng.getLastName());
        }

        if (StringUtils.isNotBlank(beanUserMng.getEmail())) {
            params.put("USR_EMAIL", beanUserMng.getEmail());
        }

        if (StringUtils.isNotBlank(beanUserMng.getTitle())) {
            params.put("TITLE", beanUserMng.getTitle());
        }

        if (StringUtils.isNotBlank(beanUserMng.getAuthorization())) {
            params.put("AUTHORIZATION", beanUserMng.getAuthorization());
        }
        if (StringUtils.isNotBlank(beanUserMng.getCreateDate())) {
            params.put("DATE_CREATED", beanUserMng.getCreateDate());
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
        userMngResult = new ResultServiceBean<>();
        try {
            conn = SourceConnector.openTenantConn(as.getConnectionProp(), false);
            if (esb.getEntity().size() > 1) {
                messages.add(MessageHelper.getMessage(conn, "NALLOW_MULTI_RECORDS"));
                errorFlag = true;
            }

            if (errorFlag == false) {
                for (UserMngUpdateBean beanUserMng : esb.getEntity()) {
                    validateUpdate(beanUserMng);

                    if (errorFlag == false) {
                        updateUserMng(beanUserMng);
                        resultBean = setUserMngResultBean(posuserSQL);
                        userMngResult.setResultBean(resultBean);

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
        userMngResult.setMessages(this.messages.toArray(new String[this.messages.size()]));
        return userMngResult;
    }

    private void updateUserMng(UserMngUpdateBean beanUserMng) throws Exception {
        posuserSQL = new PosuserSQL(conn);
        posuserSQL.setUSR_ID(beanUserMng.getUserID());
        posuserSQL.setUSR_PSW(EncryptorUtils.encrypt(beanUserMng.getUserPsw()));
        posuserSQL.setUSR_PIN(beanUserMng.getUserPin());
        posuserSQL.setFIRST_NAME(beanUserMng.getFirstName());
        posuserSQL.setLAST_NAME(beanUserMng.getLastName());
        posuserSQL.setUSR_EMAIL(beanUserMng.getEmail());
        posuserSQL.setCONTACT(beanUserMng.getContactNumber());
        posuserSQL.setALLOW_VOID(beanUserMng.getAllowVoid());
        posuserSQL.setTITLE(beanUserMng.getTitle());
        posuserSQL.setAUTHORIZATION(beanUserMng.getAuthorization());
        posuserSQL.setCREATED_BY(beanUserMng.getCreateBy());
        posuserSQL.setUSR_ACTIVE_CD(beanUserMng.getUserStatus());
        posuserSQL.setDATE_CREATED(MiscUtility.getSqlSysDate());
        posuserSQL.setLAST_OPR(beanUserMng.getUserID());
        posuserSQL.setLAST_OPR_FUNCT("UPDATE USER");
        posuserSQL.update();
    }

    private UserMngResult setUserMngResultBean(PosuserSQL posuserSQL) throws Exception {
        UserMngResult resultBean = new UserMngResult();

        resultBean.setUserID(posuserSQL.USR_ID());
        resultBean.setUserPsw(posuserSQL.USR_PSW());
        resultBean.setUserPin(posuserSQL.USR_PIN());
        resultBean.setFirstName(posuserSQL.FIRST_NAME());
        resultBean.setLastName(posuserSQL.LAST_NAME());
        resultBean.setEmail(posuserSQL.USR_EMAIL());
        resultBean.setContactNumber(posuserSQL.CONTACT());
        resultBean.setAllowVoid(posuserSQL.ALLOW_VOID());
        resultBean.setTitle(posuserSQL.TITLE());
        resultBean.setAuthorization(posuserSQL.AUTHORIZATION());
        resultBean.setDateCreate(posuserSQL.DATE_CREATED() == null ? "" : MiscUtility.parseDate(posuserSQL.DATE_CREATED()));
        resultBean.setCreateBy(posuserSQL.CREATED_BY());
        resultBean.setUserStatus(posuserSQL.USR_ACTIVE_CD());
        resultBean.setLastVersion(String.valueOf(posuserSQL.LAST_VERSION()));

        return resultBean;
    }

    private void validateUpdate(UserMngUpdateBean beanUserMng) throws Exception {
        if (org.apache.commons.lang.StringUtils.isBlank(beanUserMng.getUserID())) {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "User Id"));
            errorFlag = true;
        }

        if (org.apache.commons.lang.StringUtils.isBlank(beanUserMng.getFirstName())) {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "First Name"));
            errorFlag = true;
        }
        verifyUserMng(beanUserMng.getUserID(), beanUserMng.getLastVersion());
    }

    private void verifyUserMng(String userMng, String lastVersion) throws Exception {
        if (org.apache.commons.lang.StringUtils.isBlank(userMng)) {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "User Id"));
            errorFlag = true;
        }
    }

    @Override
    public ResultServiceBean<UserMngResult> delete(EntityServiceBean<UserMngDeleteBean> bean, AuthStatus authStatus) {
        UserMngResult resultUserMng = null;
        messages = new ArrayList<>();
        deleteResult = new ResultServiceBean<>();
        try {
            conn = SourceConnector.openTenantConn(authStatus.getConnectionProp(), false);

            for (UserMngDeleteBean beanUserMng : bean.getEntity()) {
                validateDelete(beanUserMng);

                if (!errorFlag) {
                    resultUserMng = new UserMngResult();

                    posuserSQL.setUSR_ACTIVE_CD("N");
                    posuserSQL.update();

                    posuserSQL.getByKey();

                    resultUserMng.setUserID(posuserSQL.USR_ID());
                    resultUserMng.setEmail(posuserSQL.USR_EMAIL());
                    resultUserMng.setLastVersion(String.valueOf(posuserSQL.LAST_VERSION()));

                    deleteResult.setResultBean(resultUserMng);

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

    private void validateDelete(UserMngDeleteBean beanUserMng) throws Exception {
        long lastVersion = 0L;
        try {
            lastVersion = Long.parseLong(beanUserMng.getLastVersion());
        } catch (NumberFormatException ex) {
            messages.add("Last Version must be numbers only");
            errorFlag = true;
        }

        if (org.apache.commons.lang.StringUtils.isBlank(beanUserMng.getUserID())) {
            messages.add(MessageHelper.getMessage(conn, MessageHelper.EMPTY_FIELD, "User Id"));
            errorFlag = true;
        } else {
            if (posuserSQL == null) {
                posuserSQL = new PosuserSQL(conn);
            }

            posuserSQL.setUSR_ID(beanUserMng.getUserID());

            if (posuserSQL.getByKey() > 0) {
                if (org.apache.commons.lang.StringUtils.equals("N", posuserSQL.USR_ACTIVE_CD())) {
                    messages.add(MessageHelper.getMessage(conn, "INACTIVE", "User Manage"));
                    errorFlag = true;
                } else if (posuserSQL.LAST_VERSION() != lastVersion) {
                    messages.add(MessageHelper.getMessage(conn, "RECORD_MODIFIED"));
                    errorFlag = true;
                }
            }
        }
    }

    @Override
    public ResultServiceBean<UserMngResult> view(UserMngResult bean, AuthStatus authStatus) {
        messages = new ArrayList<>();
        viewResult = new ResultServiceBean<>(); 

        try {
            conn = SourceConnector.openTenantConn(authStatus.getConnectionProp(), false);

            posuserSQL = new PosuserSQL(conn);
            posuserSQL.setUSR_ID(bean.getUserID());
            posuserSQL.setUSR_ID(bean.getLastVersion());

            if (posuserSQL.getByKey() > 0) {
                viewResult.setResultBean(setUserMngResultBean(posuserSQL));
            } else {
                messages.add(MessageHelper.getMessage(conn, "RECORD_NOT_FOUND"));
                errorFlag = true;
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

    private void validateViewBean(UserMngResult viewBean) throws Exception {

        if (posuserSQL == null) {
            posuserSQL = new PosuserSQL(conn);
        }

        if (StringUtils.isBlank(viewBean.getUserID())) {
            messages.add(MessageHelper.getMessage(conn, "EMPTY_FIELD", "User Id"));
            errorFlag = true;
        }

        if (StringUtils.isBlank(viewBean.getLastVersion())) {
            messages.add(MessageHelper.getMessage(gnrlConn, "EMPTY_FIELD", "Last Version"));
            errorFlag = true;
        }
        if (!errorFlag) {

            if (posuserSQL.getByKey() > 0) {
//                if (Long.parseLong(viewBean.getLastVersion()) != posuserSQL.LAST_VERSION()) {
//                    messages.add(MessageHelper.getMessage(gnrlConn, "Last Version Not Match"));
//                    errorFlag = true;
//                }
            }
        }
    }

}
