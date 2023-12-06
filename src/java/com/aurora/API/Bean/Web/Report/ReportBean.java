/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.aurora.API.Bean.Web.Report;

import java.util.List;

/**
 *
 * @author Kelly
 */
public class ReportBean {
    
    private String reportKey;
    private String reportPath;
    private String reportQueue;
    private String reportCopyPath;
    private List<String> reportParams;

    public String getReportKey() {
        return reportKey;
    }

    public void setReportKey(String reportKey) {
        this.reportKey = reportKey;
    }

    public String getReportPath() {
        return reportPath;
    }

    public void setReportPath(String reportPath) {
        this.reportPath = reportPath;
    }

    public List<String> getReportParams() {
        return reportParams;
    }

    public void setReportParams(List<String> reportParams) {
        this.reportParams = reportParams;
    }

    public String getReportQueue() {
        return reportQueue;
    }

    public void setReportQueue(String reportQueue) {
        this.reportQueue = reportQueue;
    }

    public String getReportCopyPath() {
        return reportCopyPath;
    }

    public void setReportCopyPath(String reportCopyPath) {
        this.reportCopyPath = reportCopyPath;
    }

    @Override
    public String toString() {
        return "ReportBean{" + "reportKey=" + reportKey + ", reportPath=" + reportPath + ", reportQueue=" + reportQueue + ", reportCopyPath=" + reportCopyPath + ", reportParams=" + reportParams + '}';
    }



}
