<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- 해당 JSP의 인코딩을 UTF-8로 설정 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<!-- Compiled and minified Materialize JS/CSS -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
	
	<script src="https://unpkg.com/credential-handler-polyfill@2.1.1/dist/credential-handler-polyfill.min.js"></script>
	<script src="https://unpkg.com/web-credential-handler@1.0.1/dist/web-credential-handler.min.js"></script>
	
	<script src='<c:url value="/js/config.js" />'></script>
	<script src='<c:url value="/js/js-helpers.js" />'></script>
	<script src='<c:url value="/js/mock-user-management.js" />'></script>
	
	<!--Simple cookie lib-->
	<script src="https://cdn.jsdelivr.net/npm/js-cookie@beta/dist/js.cookie.min.js"></script>
	
	<title>DemoWeb</title>
</head>
<body>
<div class="container">
  <h5>Wallet 에서 가져오기 </h5>

  <div class="card-panel hide" id="logged-in">
    <div id="confirm">
      <p>Origin <span id="requestOrigin"></span> 에 요청한 정보 :</p>

      <p><span id="requestReason"></span></p>
      <!-- requestReason 의 정보는 verifier 에서 reason 이라는 object 로 담겨서 와서 파싱되어서 span element text요소로 들어온다. -->
    </div>

    <div id="userArea">
      <p><strong>Logged in:</strong> <span id="username"></span></p>
      <a class="waves-effect waves-light btn-small" id="logoutButton">초기화 그리고 로그아웃</a>

      <h6>Wallet Contents:</h6>
      <ol id="walletContents"></ol>
    </div>
  </div>

  <div class="card-panel hide" id="logged-out">
    <p>
      <!-- In order to share a credential with the requesting party: -->
      	요청 상대방과 자격 증명을 공유하려면:
    </p>

    <ol>
      <li>브라우저에 너의 지갑을 등록합니다. </li>
      <li><strong>Login</strong> 버튼을 누릅니다.</li>
      <!-- <li>Click on a Share button next to an appropriate credential.</li> -->
      <li>자격 증명 옆에 있는 Share 버튼을 클릭합니다.</li>
    </ol>

    <a class="waves-effect waves-light btn" id="loginButton">Login</a>
  </div>
</div>

<script>
  /**
   * Globals:
   *  * credentialHandlerPolyfill - from credential-handler-polyfill.min.js.
   *      This provides the get() and store() Credential Handler API calls.
   *
   *  * WebCredentialHandler - from web-credential-handler.min.js.
   *      Utility/convenience library for the CHAPI polyfill, useful for wallet
   *      implementors.
   *
   *  * Persistence and user management - ./mock-user-management.js
   */

  async function handleGetEvent() {
    const event = await WebCredentialHandler.receiveCredentialEvent();

    console.log('Wallet processing get() event:', event);

    document.getElementById('requestOrigin').innerHTML = event.credentialRequestOrigin;

    const vp = event.credentialRequestOptions.web.VerifiablePresentation;
    const query = Array.isArray(vp.query) ? vp.query[0] : vp.query;

    if(!query.type === 'QueryByExample') {
      throw new Error('Only QueryByExample requests are supported in demo wallet.');
    }

    const requestReason = query.credentialQuery.reason;
    document.getElementById('requestReason').innerHTML = requestReason;

    refreshUserArea({
      shareButton: {
        text: 'Share',
        sourceEvent: event
      }
    });
    
  }

  onDocumentReady(() => {
    document.getElementById('loginButton').addEventListener('click', login);
    document.getElementById('logoutButton').addEventListener('click', logout);
  })

  credentialHandlerPolyfill
    .loadOnce(MEDIATOR)
    .then(handleGetEvent);
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
</body>
</html>
