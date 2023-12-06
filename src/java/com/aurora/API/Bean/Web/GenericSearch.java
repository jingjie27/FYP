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
 *            @version GenericSearch.java 6 Nov 2023 yeehao
 *            @author  jingjie
 *            @since   17 Nov 2023
 * 
 */
package com.aurora.API.Bean.Web;

/**
 *
 * @author yeehao
 */
public class GenericSearch {

    private int currentPage;
    private int pageSize;

    public GenericSearch() {
    }

    public GenericSearch(int currentPage, int pageSize) {
        this.currentPage = currentPage;
        this.pageSize = pageSize;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    @Override
    public String toString() {
        return "GenericSearch{" + "currentPage=" + currentPage + ", pageSize=" + pageSize + '}';
    }
}
