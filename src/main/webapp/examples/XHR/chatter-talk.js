var chatterTalk;
if (!chatterTalk) {
    chatterTalk = {};
}

(function ($$) {

    "use strict";

    function onClickHandler() {
    }

    chatterTalk.init =  function(sr, button, input, callback) {
        $$.byId(button).onclick=function() {
            var value = $$.byId(input).value;
            chatterTalk.post(sr, value, callback);
        };
    };


    chatterTalk.post =  function(sr, message, callback) {
        var url = sr.context.links.chatterFeedsUrl+"/news/"+sr.context.user.userId+"/feed-items";
        var body = {body : {messageSegments : [{type: "Text", text: message}]}};

        $$.client.ajax(url,
            {client : sr.client,
                method: 'POST',
                contentType: "application/json",
                data: JSON.stringify(body),
                success : function(data) {
                    if ($$.isFunction(callback)) {
                        callback(data);
                    }
                }
            });
    };

    chatterTalk.get = function(sr,button,input,callback)
    {
        $$.byId(button).onclick=function() {
            var value = $$.byId(input).value;
        };
        // Reference the Chatter user's URL from Context.Links object.
        var chatterUsersUrl = sr.context.links.chatterUsersUrl;

        // Make an XHR call back to salesforce through the supplied browser proxy.
        $$.client.ajax(chatterUsersUrl,
            {client : sr.client,
                success : function(data){
                    // Make sure the status code is OK.
                    if (data.status === 200) {
                        // Alert with how many Chatter users were returned.
                        alert("Got back "  + data.payload.users.length + " users"); // Returned 2 users
                    }
                    else
                    {
                        alert("Data Status: " + data.status);
                    }
                }});
    };

}(Sfdc.canvas));
