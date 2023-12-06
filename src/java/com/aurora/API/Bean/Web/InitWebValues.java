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
 *            @version InitWebValues.java 12 Nov 2021 Ding
 *            @author  Ding
 *            @since   12 Nov 2021
 * 
 * 
 *            MODIFIED
 *            Ding     12 Nov 2021 - Creation
 * 
 * 
 * 
 */
package com.aurora.API.Bean.Web;

/**
 *
 * @author Ding
 */
public class InitWebValues
{
    private String code;
    private String desc;

    public String getCode()
    {
        return code;
    }

    public void setCode(String code)
    {
        this.code = code;
    }

    public String getDesc()
    {
        return desc;
    }

    public void setDesc(String desc)
    {
        this.desc = desc;
    }

    @Override
    public String toString()
    {
        return "InitWebValues{" + "code=" + code + ", desc=" + desc + '}';
    }
    
    
}
