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
 *            @version InitWebResult.java 12 Nov 2021 Ding
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

import java.util.List;

/**
 *
 * @author Ding
 */
public class InitWebResult
{
    private String identifier;
    private List<InitWebValues> values;

    public String getIdentifier()
    {
        return identifier;
    }

    public void setIdentifier(String identifier)
    {
        this.identifier = identifier;
    }

    public List<InitWebValues> getValues()
    {
        return values;
    }

    public void setValues(List<InitWebValues> values)
    {
        this.values = values;
    }

    

    @Override
    public String toString()
    {
        return "InitWebResult{" + "identifier=" + identifier + ", values=" + values + '}';
    }
    
    
}
