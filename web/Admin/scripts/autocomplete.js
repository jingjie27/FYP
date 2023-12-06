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
 *            @version autocomplete.js 17 Sep 2023 henry
 *            @author  henry
 *            @since   17 Sep 2023
 * 
 * 
 *            MODIFIED
 *            henry     17 Sep 2023 - Creation
 * 
 * 
 * 
 */

function autocompleteEvent(e, params)
{
    const allowedCharacters = /[a-zA-Z0-9]/;
    ;
    let input = e.target.value;
    let inputBox = $(e.target);
    let resultBox = $(e.target).parent().find(".result-box");
    
    if (allowedCharacters.test(e.key))
    {
        console.log("fieldID: " + inputBox.attr("fieldid"));
        request.get({
            baseUrl: params.serverIP,
            authUrl: params.serverIP,
            accessID: params.SID,
            url: '/API/Web/query',
            data: {
                "queryId": inputBox.attr("fieldid"),
                "content": input
            },
            authToken: true
        }).then((response) => {
            let result = [];
            console.log(response);
            if ("error" !== response.status)
            {
                if (response.data.hasOwnProperty("list") && response.data.list !== null)
                {
                    result = response.data.list;
                    const content = result.map((list) => {
                        return "<li code='" + list.identifier + "' desc='" + list.description + "' version='" + list.lastVersion +"'>" + list.identifier + "-" + list.description + "</li>";
                    })

//                    inputBox.focusout(function ()
//                    {
//                        resultBox.html("");
//                    })

                    $(resultBox).on("mousedown", "li", function (event)
                    {
                        if($(e.target).attr("codeField") === 'true')
                            inputBox.val($(event.target).attr("code"));
                        else
                            inputBox.val($(event.target).attr("desc"));

                        //define a new attribute to store the last version
                        inputBox.attr("lastVersion", $(event.target).attr("version"));
                        
                        console.log("Click " + $(event.target).attr("code"))

                        resultBox.html("");
                    })
                    resultBox.html("<ul>" + content.join('') + "</ul>");
                    
                    $(e.target).on("focusout", function (ev) {
                        resultBox.html("");
                    });
                    
                    if (!result.length || !input.length)
                    {
                        resultBox.html("");
                    }
                } else
                {
                    resultBox.html("");
                }
            } else
            {
                if (params.hasOwnProperty("fail"))
                {
                    params.fail(response.message)
                }
            }

        });
    }

}


