/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.aurora.API.Bean.Web.AD;

import java.util.List;

/**
 *
 * @author henry
 * 
 */
public class ADLoginNav
{
    private String navHeader;
    private String navPage;
    private String navIcon;
    private String navIP;
    private List<ADLoginNav> subNavigation;

    public String getNavHeader()
    {
        return navHeader;
    }

    public void setNavHeader(String navHeader)
    {
        this.navHeader = navHeader;
    }

    public String getNavPage()
    {
        return navPage;
    }

    public String getNavIP()
    {
        return navIP;
    }

    public void setNavIP(String navIP)
    {
        this.navIP = navIP;
    }

    public void setNavPage(String navPage)
    {
        this.navPage = navPage;
    }

    public List<ADLoginNav> getSubNavigation()
    {
        return subNavigation;
    }

    public void setSubNavigation(List<ADLoginNav> subNavigation)
    {
        this.subNavigation = subNavigation;
    }

    public String getNavIcon()
    {
        return navIcon;
    }

    public void setNavIcon(String navIcon)
    {
        this.navIcon = navIcon;
    }
    
    

    @Override
    public String toString()
    {
        return "ADLoginNav{" + "navHeader=" + navHeader + ", navPage=" + navPage + ", subNavigation=" + subNavigation + '}';
    }
}
