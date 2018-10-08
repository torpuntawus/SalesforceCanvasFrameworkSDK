var chatterTalk;
if (!chatterTalk) {
    chatterTalk = {};
}

(function ($$) {

    "use strict";

    function onClickHandler() {
    }

    chatterTalk.init = function (sr, button, input, callback) {
        $$.byId(button).onclick = function () {
            var value = $$.byId(input).value;
            chatterTalk.post(sr, value, callback);
        };
    };

    chatterTalk.initGet = function (sr, buttonId, callback) {
        $$.byId(buttonId).onclick = function () {
            chatterTalk.get(sr, callback);
        }
    };


    chatterTalk.post = function (sr, message, callback) {
        var url = sr.context.links.chatterFeedsUrl + "/news/" + sr.context.user.userId + "/feed-items";
        var body = {body: {messageSegments: [{type: "Text", text: message}]}};

        $$.client.ajax(url,
            {
                client: sr.client,
                method: 'POST',
                contentType: "application/json",
                data: JSON.stringify(body),
                success: function (data) {
                    if ($$.isFunction(callback)) {
                        callback(data);
                    }
                }
            });
    };

    chatterTalk.get = function (sr, callback) {
        // Reference the Chatter user's URL from Context.Links object.
        var chatterUsersUrl = sr.context.links.chatterUsersUrl;

        // Make an XHR call back to salesforce through the supplied browser proxy.
        $$.client.ajax(chatterUsersUrl,
            {
                client: sr.client,
                success: function (data) {
                    console.log(data);
                    // Make sure the status code is OK.
                    if ($$.isFunction(callback)) {
                        callback("User length that received from " + sr.context.links.chatterUsersUrl + " is : " + data.payload.users.length);
                    }
                }
            });
    };

}(Sfdc.canvas));
