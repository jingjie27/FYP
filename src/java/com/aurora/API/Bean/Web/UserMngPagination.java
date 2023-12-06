
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
 *            @version UserMngPagination.java 6 Nov 2023 yeehao
 *            @author  yeehao
 *            @since   6 Nov 2023
 * 
 */
package com.aurora.API.Bean.Web;

import com.aurora.API.Bean.ResultPagination;
import java.util.List;

/**
 *
 * @author yeehao
 */
public class UserMngPagination extends ResultPagination {

    private List<UserMngSearchResult> userMng;

    public UserMngPagination() {
    }

    public UserMngPagination(int currentPage, int pageSize, int totalRows) {
        super(currentPage, pageSize, totalRows);
    }

    public List<UserMngSearchResult> getUserMng() {
        return userMng;
    }

    public void setUserMng(List<UserMngSearchResult> userMng) {
        this.userMng = userMng;
    }

}
