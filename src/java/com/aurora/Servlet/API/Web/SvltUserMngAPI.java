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
 *            @version SvltUserMngAPI.java 26 Mar 2022 yeehao
 *            @author  jingjie
 *            @since   17 NOV 2023
 * 
 * 
 * 
 * 
 * 
 */
package com.aurora.Servlet.API.Web;

import com.aurora.API.Bean.EntityServiceBean;
import com.aurora.API.Bean.ResultServiceBean;
import com.aurora.API.Bean.Web.UserMngCreateBean;
//import com.aurora.API.Bean.Web.UserMngCreateBean;
//import com.aurora.API.Bean.Web.UserMngDeleteBean;
import com.aurora.API.Bean.Web.UserMngPagination;
import com.aurora.API.Bean.Web.UserMngResult;
//import com.aurora.API.Bean.Web.UserMngResult;
import com.aurora.API.Bean.Web.UserMngSearchBean;
//import com.aurora.API.Bean.Web.UserMngUpdateBean;
//import com.aurora.API.Bean.Web.UserMngViewBean;
//import com.aurora.API.Bean.Web.UserMngViewResult;
import com.aurora.API.Web.UserMngAPI;
import com.aurora.API.Web.UserMngAPIImpl;
import com.aurora.DataSource.SourceConnector;
import com.aurora.Servlet.API.APIServlet;
import com.aurora.Servlet.API.Message.ResponseInfo;
import com.aurora.Servlet.API.ServletAction;
import com.aurora.Servlet.API.Utils.StatusCode;
import com.aurora.Utility.MiscUtility;
import com.fasterxml.jackson.core.type.TypeReference;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import org.apache.commons.lang3.ArrayUtils;

/**
 *
 * @author yeehao
 */
public class SvltUserMngAPI extends APIServlet {

    @Override
    public void init(ServletConfig servletConfig) throws ServletException {

        try {
            register(APIServlet.ActionBuilder.of(this)
                    .jackson(true)
                    .ofInstance(SourceConnector.PropKey.GENERAL_MODE)
                    .post("/API/Web/um/create", "create", APIServlet.WEB_CHANNEL, true)
//                    .post("/API/Web/um/update", "update", APIServlet.WEB_CHANNEL, true)
//                    .get("/API/Web/um/view", "view", APIServlet.WEB_CHANNEL, true)
                    .get("/API/Web/um/search", "search", APIServlet.WEB_CHANNEL, true)
//                    .post("/API/Web/um/delete", "delete", APIServlet.WEB_CHANNEL, true)
                    .build());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
//
    public ResponseInfo<UserMngResult> create(ServletAction action) throws Exception {
        ResultServiceBean<UserMngResult> result = new ResultServiceBean<>();
        EntityServiceBean<UserMngCreateBean> bean = fromBody(action, new TypeReference<EntityServiceBean<UserMngCreateBean>>() {
        });

        try {
            UserMngAPI pochklstService = new UserMngAPIImpl();
            result = pochklstService.create(bean, getAuthStatus());

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        if (ArrayUtils.isNotEmpty(result.getMessages())) {
            return ResponseInfo.<UserMngResult>builder()
                    .statusCode(StatusCode.ERROR)
                    .version(String.valueOf(MiscUtility.todayMillis()))
                    .globals(result.getMessages())
                    .build();
        }

        UserMngResult resultBean = result.getResult();
        return ResponseInfo.<UserMngResult>builder()
                .statusCode(StatusCode.OK)
                .version(String.valueOf(MiscUtility.todayMillis()))
                .entity(resultBean)
                .build();
    }
//
//    public ResponseInfo<UserMngResult> update(ServletAction action) throws Exception {
//        ResultServiceBean<UserMngResult> result = new ResultServiceBean<>();
//        EntityServiceBean<UserMngUpdateBean> bean = fromBody(action, new TypeReference<EntityServiceBean<UserMngUpdateBean>>() {
//        });
//
//        try {
//            UserMngAPI odrchklstService = new UserMngAPIImpl();
//            result = odrchklstService.update(bean, getAuthStatus());
//
//        } catch (Exception ex) {
//            ex.printStackTrace();
//        }
//
//        if (ArrayUtils.isNotEmpty(result.getMessages())) {
//            return ResponseInfo.<UserMngResult>builder()
//                    .statusCode(StatusCode.ERROR)
//                    .version(String.valueOf(MiscUtility.todayMillis()))
//                    .globals(result.getMessages())
//                    .build();
//        }
//
//        UserMngResult resultBean = result.getResult();
//        return ResponseInfo.<UserMngResult>builder()
//                .statusCode(StatusCode.OK)
//                .version(String.valueOf(MiscUtility.todayMillis()))
//                .entity(resultBean)
//                .build();
//    }
//
//    public ResponseInfo<UserMngViewResult> view(ServletAction servlet) throws Exception {
//        ResultServiceBean<UserMngViewResult> result = new ResultServiceBean<>();
//        UserMngViewBean odrchklstViewBean = new UserMngViewBean();
//
//        try {
//            String chklstNo = servlet.request().getString("chklstNo");
//            String store = servlet.request().getString("store");
//            String lastVersion = servlet.request().getString("lastVersion");
//
//            odrchklstViewBean.setChklstNo(chklstNo);
//            odrchklstViewBean.setStore(store);
//            odrchklstViewBean.setLastVersion(lastVersion);
//
//            UserMngAPI odrchklstAPI = new UserMngAPIImpl();
//            result = odrchklstAPI.view(odrchklstViewBean, getAuthStatus());
//        } catch (Exception ex) {
//            ex.printStackTrace();
//        }
//
//        if (ArrayUtils.isNotEmpty(result.getMessages())) {
//            return ResponseInfo.<UserMngViewResult>builder()
//                    .statusCode(StatusCode.ERROR)
//                    .version(String.valueOf(MiscUtility.todayMillis()))
//                    .globals(result.getMessages())
//                    .build();
//        }
//
//        UserMngViewResult resultBean = result.getResult();
//        return ResponseInfo.<UserMngViewResult>builder()
//                .statusCode(StatusCode.OK)
//                .version(String.valueOf(MiscUtility.todayMillis()))
//                .entity(resultBean)
//                .build();
//    }

    public ResponseInfo<UserMngPagination> search(ServletAction servlet) throws Exception {
        ResultServiceBean<UserMngPagination> result = new ResultServiceBean<>();
        UserMngSearchBean userMngSearchBean = new UserMngSearchBean();

        try {
            String userID = servlet.request().getString("userID");
            String firstName = servlet.request().getString("firstName");
            String lastName = servlet.request().getString("lastName");
            String email = servlet.request().getString("email");
            String title = servlet.request().getString("title");
            String authorization = servlet.request().getString("authorization");
            String createDate = servlet.request().getString("createDate");
            int currentPage = servlet.request().getInt("currentPage");
            int pageSize = servlet.request().getInt("pageSize");

            userMngSearchBean.setUserID(userID);
            userMngSearchBean.setFirstName(firstName);
            userMngSearchBean.setLastName(lastName);
            userMngSearchBean.setEmail(email);
            userMngSearchBean.setTitle(title);
            userMngSearchBean.setAuthorization(authorization);
            userMngSearchBean.setCreateDate(createDate);
            userMngSearchBean.setCurrentPage(currentPage);
            userMngSearchBean.setPageSize(pageSize);

            UserMngAPI userMngAPI = new UserMngAPIImpl();
            result = userMngAPI.search(userMngSearchBean, getAuthStatus());
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        if (ArrayUtils.isNotEmpty(result.getMessages())) {
            return ResponseInfo.<UserMngPagination>builder()
                    .statusCode(StatusCode.ERROR)
                    .version(String.valueOf(MiscUtility.todayMillis()))
                    .globals(result.getMessages())
                    .build();
        }

        UserMngPagination resultBean = result.getResult();
        return ResponseInfo.<UserMngPagination>builder()
                .statusCode(StatusCode.OK)
                .version(String.valueOf(MiscUtility.todayMillis()))
                .entity(resultBean)
                .build();
    }

//    public ResponseInfo<UserMngPagination> searchReleasePochklst(ServletAction servlet) throws Exception {
//        ResultServiceBean<UserMngPagination> result = new ResultServiceBean<>();
//        UserMngSearchBean odrchklstSearchBean = new UserMngSearchBean();
//
//        try {
//            String store = servlet.request().getString("store");
//            String chklstDate = servlet.request().getString("chklstDate");
//            String buyer = servlet.request().getString("buyer");
//            String delvLocation = servlet.request().getString("delvLocation");
//            String expDelvDate = servlet.request().getString("expDelvDate");
//            String remark = servlet.request().getString("remark");
//            int currentPage = servlet.request().getInt("currentPage");
//            int pageSize = servlet.request().getInt("pageSize");
//
//            odrchklstSearchBean.setStore(store);
//            odrchklstSearchBean.setChklstDate(chklstDate);
//            odrchklstSearchBean.setBuyer(buyer);
//            odrchklstSearchBean.setDelvLocation(delvLocation);
//            odrchklstSearchBean.setExpDelvDate(expDelvDate);
//            odrchklstSearchBean.setRemark(remark);
//            odrchklstSearchBean.setCurrentPage(currentPage);
//            odrchklstSearchBean.setPageSize(pageSize);
//
//            UserMngAPI odrchklstAPI = new UserMngAPIImpl();
//            result = odrchklstAPI.searchPochklstForRelease(odrchklstSearchBean, getAuthStatus());
//        } catch (Exception ex) {
//            ex.printStackTrace();
//        }
//
//        if (ArrayUtils.isNotEmpty(result.getMessages())) {
//            return ResponseInfo.<UserMngPagination>builder()
//                    .statusCode(StatusCode.ERROR)
//                    .version(String.valueOf(MiscUtility.todayMillis()))
//                    .globals(result.getMessages())
//                    .build();
//        }
//
//        UserMngPagination resultBean = result.getResult();
//        return ResponseInfo.<UserMngPagination>builder()
//                .statusCode(StatusCode.OK)
//                .version(String.valueOf(MiscUtility.todayMillis()))
//                .entity(resultBean)
//                .build();
//    }
//
//    public ResponseInfo<Object> delete(ServletAction servlet) throws Exception {
//
//        ResultServiceBean<UserMngResult> result = new ResultServiceBean<>();
//        EntityServiceBean<UserMngDeleteBean> bean = fromBody(servlet, new TypeReference<EntityServiceBean<UserMngDeleteBean>>() {
//        });
//
//        try {
//            UserMngAPI odrchklstService = new UserMngAPIImpl();
//            result = odrchklstService.delete(bean, getAuthStatus());
//
//        } catch (Exception ex) {
//            ex.printStackTrace();
//        }
//
//        if (ArrayUtils.isNotEmpty(result.getMessages())) {
//            return ResponseInfo.<Object>builder()
//                    .statusCode(StatusCode.ERROR)
//                    .version(String.valueOf(MiscUtility.todayMillis()))
//                    .globals(result.getMessages())
//                    .build();
//        }
//
//        UserMngResult resultBean = result.getResult();
//        return ResponseInfo.<Object>builder()
//                .statusCode(StatusCode.OK)
//                .version(String.valueOf(MiscUtility.todayMillis()))
//                .entity(resultBean)
//                .build();
//    }
}
