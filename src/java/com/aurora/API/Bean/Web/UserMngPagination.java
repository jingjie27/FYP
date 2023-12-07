
package com.aurora.API.Bean.Web;

import com.aurora.API.Bean.ResultPagination;
import java.util.List;

/**
 *
 * @author jinjie
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
