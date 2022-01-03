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
	<script src='<c:url value="/js/mock-user-management.js?v=<%=System.currentTimeMillis() %>" />'></script>
	
	<!--Simple cookie lib-->
	<script src="https://cdn.jsdelivr.net/npm/js-cookie@beta/dist/js.cookie.min.js"></script>
	
	<title>DemoWeb</title>
</head>
<body>
<div>
<h1>Demo Wallet에 저장</h1>

  <div class="card-panel hide" id="logged-in">
    <div id="confirm">
      <p>Credential 을 저장하시겠습니까??</p>

      <p><strong>type:</strong> <span id="credentialType"></span></p>

      <p><strong>issuer:</strong> <span id="credentialIssuer"></span></p>

      <a class="waves-effect waves-light btn" id="confirmButton">Confirm</a>
      <a class="waves-effect waves-light btn" id="cancelButton">Cancel</a>
    </div>

    <div id="userArea" class="hide">
      <p><strong>Logged in:</strong> <span id="username"></span></p>
      <a class="waves-effect waves-light btn-small" id="logoutButton">초기화 그리고 로그아웃</a>

      <p><strong>Credential 을 저장했습니다!</strong></p>

      <h6>Wallet Contents:</h6>
      <ol id="walletContents"></ol>

      <a class="waves-effect waves-light btn center" id="doneButton">Done</a>
    </div>
  </div>

  <div class="card-panel hide" id="logged-out">
    <p>
      자격증명을 저장하려면:
    </p>

    <ol>
      <li>브라우저에 너의 지갑을 등록하거나 등록 되어 있어야합니다. </li>
      <li><strong>Login</strong> 버튼을 클릭합니다.</li>
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

  async function handleStoreEvent() {
    const event = await WebCredentialHandler.receiveCredentialEvent();
    console.log('Store Credential Event:', event.type, event);

    const credential = event.credential;

    // document.getElementById('requestOrigin').innerHTML = event.credentialRequestOrigin;
    // document.getElementById('hintKey').innerHTML = credential.hintKey || '';
    // document.getElementById('credentialContents').innerHTML = JSON.stringify(credential.data, null, 2);

    // Display the credential details, for confirmation
    const vp = credential.data;
    const vc = Array.isArray(vp.verifiableCredential)
      ? vp.verifiableCredential[0]
      : vp.verifiableCredential;
    document.getElementById('credentialType').innerHTML = getCredentialType(vc);
    document.getElementById('credentialIssuer').innerHTML = vc.issuer;

    // Set up the event handlers for the buttons
    document.getElementById('cancelButton').addEventListener('click', () => {
      returnToUser(event, null); // Do nothing, close the CHAPI window
    });

    document.getElementById('confirmButton').addEventListener('click', () => {
      document.getElementById('userArea').classList.remove('hide');
      document.getElementById('confirm').classList.add('hide');

      storeInWallet(credential.data); // in mock-user-management.js
      refreshUserArea();
    });

    document.getElementById('doneButton').addEventListener('click', () => {
      returnToUser(event, vp);
    });
  }

  /**
   * @param storeEvent
   * @param {VerifiablePresentation|null} data - Return (to client application)
   *   exactly what was stored, or a `null` if canceled by the user.
   */
  function returnToUser(storeEvent, data) {
    storeEvent.respondWith(new Promise(resolve => {
      return data
        ? resolve({dataType: 'VerifiablePresentation', data})
        : resolve(null);
    }))
  }

  // from js-helpers.js
  onDocumentReady(() => {
    document.getElementById('loginButton').addEventListener('click', login);
    document.getElementById('logoutButton').addEventListener('click', logout);
    refreshUserArea();
  })

  credentialHandlerPolyfill
    .loadOnce(MEDIATOR)
    .then(handleStoreEvent);
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
</body>
</html>
