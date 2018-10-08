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
    String yourConsumerSecret="548682061335522235";
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
            Sfdc.canvas.client.publish(sr.client,
                { name: 'js_publish',
                payload: { Context : "Js publish" }
            });

            Sfdc.canvas.client.subscribe(sr.client,
                { name : 'vs_publish', onData : function (data)
                    {
                        if (data != null)
                        {
                            alert(JSON.stringify(data));
                            //Sfdc.canvas.byId('Showtext').innerHTML += JSON.stringify(data.value);
                            //document.write(JSON.stringify(data.value));
                        }
                        else
                        {
                            alert("Can't Subscribe");
                        }
                    }
                });
        });

        <%--var sr = JSON.parse('<%=signedRequestJson%>');--%>
        <%--Sfdc.canvas.controller.publish({--%>
            <%--name: 'sendContext',--%>
            <%--payload: { Context : JSON.stringify(sr.context),SignedRequest : JSON.stringify(sr.client) }--%>
        <%--});--%>
        <%--function Unsubscribe() {--%>
            <%--var sr = JSON.parse('<%=signedRequestJson%>');--%>
            <%--Sfdc.canvas.client.unsubscribe(sr.client, {name : "subscribe"});--%>
            <%--alert("unsubscribe success");--%>
        <%--}--%>
    </script>

</head>
<body>
    <%--<button onclick="Subscribe()">Subscribe</button>--%>
    <%--<button onclick="Unsubscribe()">Unsubscribe</button>--%>
    <span id='inputtext'></span>
</body>
</html>
