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
 *            @version OdrchklstResult.java 3 Nov 2023 yeehao
 *            @author  jingjie
 *            @since   17 Nov 2023
 * 
 */
package com.aurora.API.Web;

//import com.aurora.API.Bean.EntityServiceBean;
import com.aurora.API.Bean.EntityServiceBean;
import com.aurora.API.Bean.ResultServiceBean;
import com.aurora.API.Bean.Web.UserMngCreateBean;
import com.aurora.API.Bean.Web.UserMngDeleteBean;
//import com.aurora.API.Bean.Web.OdrchklstCreateBean;
//import com.aurora.API.Bean.Web.OdrchklstDeleteBean;
import com.aurora.API.Bean.Web.UserMngPagination;
import com.aurora.API.Bean.Web.UserMngResult;
//import com.aurora.API.Bean.Web.OdrchklstResult;
import com.aurora.API.Bean.Web.UserMngSearchBean;
import com.aurora.API.Bean.Web.UserMngUpdateBean;
import com.aurora.API.Bean.Web.UserMngViewResult;
//import com.aurora.API.Bean.Web.OdrchklstUpdateBean;
//import com.aurora.API.Bean.Web.OdrchklstViewBean;
//import com.aurora.API.Bean.Web.OdrchklstViewResult;
import com.aurora.Servlet.API.AuthStatus;

/**
 *
 * @author yeehao
 */
public interface UserMngAPI {
//
    ResultServiceBean<UserMngResult> create(EntityServiceBean<UserMngCreateBean> bean, AuthStatus authStatus);
    ResultServiceBean<UserMngViewResult> view(UserMngViewResult bean, AuthStatus authStatus);
    ResultServiceBean<UserMngPagination> search(UserMngSearchBean bean, AuthStatus authStatus);
    ResultServiceBean<UserMngResult> delete(EntityServiceBean<UserMngDeleteBean> bean, AuthStatus authStatus);
    ResultServiceBean<UserMngResult> update(EntityServiceBean<UserMngUpdateBean> bean, AuthStatus authStatus);
}
