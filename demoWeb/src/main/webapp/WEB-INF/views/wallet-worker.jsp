<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- 해당 JSP의 인코딩을 UTF-8로 설정 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<script src="https://unpkg.com/credential-handler-polyfill@2.1.1/dist/credential-handler-polyfill.min.js"></script>
  	<script src="https://unpkg.com/web-credential-handler@1.0.1/dist/web-credential-handler.min.js"></script>
  	
  	<script src='<c:url value="/js/config.js" />'></script>

	<title>DemoWeb</title>
</head>
<body>
<script>
  async function activateWalletEventHandler() {
    try {
      await credentialHandlerPolyfill.loadOnce(MEDIATOR);
    } catch(e) {
      console.error('Error in loadOnce:', e);
    }

    console.log('Worker Polyfill loaded, mediator:', MEDIATOR);

    return WebCredentialHandler.activateHandler({
      mediatorOrigin: MEDIATOR,
      async get(event) {
        console.log('WCH: Received get() event:', event);
        return {type: 'redirect', url: WALLET_LOCATION + 'wallet-ui-get'};
      },
      async store(event) {
        console.log('WCH: Received store() event:', event);
        return {type: 'redirect', url: WALLET_LOCATION + 'wallet-ui-store'};
      }
    })
  }

  console.log('worker.html: Activating handler, WALLET_LOCATION:', WALLET_LOCATION);
  activateWalletEventHandler();
</script>
</body>
</html>
