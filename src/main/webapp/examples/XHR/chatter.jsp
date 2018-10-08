<%@ page import="canvas.SignedRequest" %>
<%@ page import="java.util.Map" %>
<%
    // Pull the signed request out of the request body and verify/decode it.
    Map<String, String[]> parameters = request.getParameterMap();
    String[] signedRequest = parameters.get("signed_request");
    if (signedRequest == null) {%>This App must be invoked via a signed request!<%
        return;
    }
    //String yourConsumerSecret=System.getenv("CANVAS_CONSUMER_SECRET");
    String yourConsumerSecret = "1530582893872749099";
    String signedRequestJson = SignedRequest.verifyAndDecodeAsJson(signedRequest[0], yourConsumerSecret);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>

    <title>Chatter Talk Example</title>
    <link rel="stylesheet" type="text/css" href="/examples/XHR/talk.css"/>

    <script type="text/javascript" src="/sdk/js/canvas.js"></script>
    <script type="text/javascript" src="/sdk/js/cookies.js"></script>
    <script type="text/javascript" src="/sdk/js/oauth.js"></script>
    <script type="text/javascript" src="/sdk/js/xd.js"></script>
    <script type="text/javascript" src="/sdk/js/client.js"></script>
    <script type="text/javascript" src="/scripts/json2.js"></script>
    <script type="text/javascript" src="/examples/XHR/chatter-talk.js"></script>

    <style>
        #get-stylized {
            border: solid 2px #b7ddf2;
            /* Safari 4-5, Chrome 1-9 */
            background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#E5F2F7), to(#FEFFFF));

            /* Safari 5.1, Chrome 10+ */
            background: -webkit-linear-gradient(top, #FEFFFF, #E5F2F7);

            /* Firefox 3.6+ */
            background: -moz-linear-gradient(top, #FEFFFF, #E5F2F7);

            /* IE 10 */
            background: -ms-linear-gradient(top, #FEFFFF, #E5F2F7);

            /* Opera 11.10+ */
            background: -o-linear-gradient(top, #FEFFFF, #E5F2F7);

            /*background: #ebf4fb;*/
        }
    </style>
</head>
<body>
<div class="slide device-access" id="speech-input">
    <section>
        <div id="stylized" class="flex hbox boxcenter" style="margin-bottom: 10px;">

            <div style="height:50px;text-align:center">
                <p>
                    <strong>Chatter Talk POST</strong><br/>
                </p>
            </div>

            <div style="height:100px;text-align:center">
                <input id="speech-input-field" type="text" x-webkit-speech/>
                <p style="display:none">Speech input is not enabled in your browser.<br>
                    Try running Google Chrome with the <code>--enable-speech-input</code> flag.</p>
            </div>
            <div style="height:50px;text-align:center">
                <button id="chatter-submit" type="submit" style="background: greenyellow !important;">POST</button>
            </div>
            <div style="height:50px;text-align:center">
                <span id="status" style="color:green"></span>
            </div>

            <div style="height:50px;text-align:center">
                <span>You can view the result here: <a target="_blank"
                                                       href="https://tmbbank--democr.lightning.force.com/lightning/page/chatter">link</a></span>
            </div>
        </div>
        <script>
            if (!('webkitSpeech' in document.createElement('input'))) {
                document.querySelector('#speech-input p').style.display = 'block';
            }
            var sr = JSON.parse('<%=signedRequestJson%>');
            chatterTalk.init(sr, "chatter-submit", "speech-input-field", function (data) {
                Sfdc.canvas.byId('status').innerHTML = data.statusText;
            });
        </script>
    </section>
    <section>
        <div id="get-stylized" class="flex hbox boxcenter">

            <div style="height:50px;text-align:center">
                <p>
                    <strong>Chatter Talk GET</strong><br/>
                </p>
            </div>
            <div style="height:50px;text-align:center">
                <button id="get-chatter-submit" type="submit" style="background: greenyellow !important;">GET</button>
            </div>
            <div style="height:50px;text-align:center">
                <span id="get-status" style="color:green"></span>
            </div>
        </div>
        <script>
            var sr = JSON.parse('<%=signedRequestJson%>');
            chatterTalk.initGet(sr, "get-chatter-submit", function (data) {
                Sfdc.canvas.byId('get-status').innerHTML = JSON.stringify(data.payload.users);
            });
        </script>
    </section>
</div>
</body>
</html>
