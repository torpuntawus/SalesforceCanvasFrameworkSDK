<%@ page import="canvas.SignedRequest" %>
<%@ page import="java.util.Map" %>
<%
    // Pull the signed request out of the request body and verify/decode it.
    Map<String, String[]> parameters = request.getParameterMap();
    String[] signedRequest = parameters.get("signed_request");
    if (signedRequest == null) {%>
        This App must be invoked via a signed request!<%
		
        return;
    }
    //String yourConsumerSecret=System.getenv("CANVAS_CONSUMER_SECRET");
    String yourConsumerSecret="4933735070567661843";
    String signedRequestJson = SignedRequest.verifyAndDecodeAsJson(signedRequest[0], yourConsumerSecret);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>

    <title>Hello World Canvas Example</title>

    <link rel="stylesheet" type="text/css" href="/sdk/css/canvas.css" />

    <!-- Include all the canvas JS dependencies in one file -->
    <script type="text/javascript" src="/sdk/js/canvas-all.js"></script>
    <!-- Third part libraries, substitute with your own -->
    <script type="text/javascript" src="/scripts/json2.js"></script>

    <script>
        if (self === top) {
            // Not in Iframe
            alert("This canvas app must be included within an iframe");
        }

        Sfdc.canvas(function() {
            var sr = JSON.parse('<%=signedRequestJson%>');

            // Save the token
            Sfdc.canvas.oauth.token(sr.oauthToken);
            //Sfdc.canvas.byId('username').innerHTML = JSON.stringify(sr.context);
			//Sfdc.canvas.byId('signedRequest').innerHTML =  JSON.stringify(sr.client);

        });

        function SendContext() {
            var sr = JSON.parse('<%=signedRequestJson%>');
            Sfdc.canvas.client.publish(sr.client, {
                name: 'myns.sendCon',
                payload: { value : JSON.stringify(sr.context)} });
        }
        function SendSignedRequest() {
            var sr = JSON.parse('<%=signedRequestJson%>');
            Sfdc.canvas.client.publish(sr.client, {
                name: 'myns.sendSign',
                payload: { value : JSON.stringify(sr.context)} });
        }

    </script>

</head>
<body>
    <h1>Context</h1>
    <button onclick="SendContext()">Show Context</button>
    <span id='username'></span>
	<h2>Signed Request</h2>
    <button onclick="SendSignedRequest()">Show Signed Request</button>
    <span id='signedRequest'></span>
</body>
</html>
