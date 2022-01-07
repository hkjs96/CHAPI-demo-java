<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 해당 JSP의 인코딩을 UTF-8로 설정 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

	<!-- Compiled and minified Materialize JS/CSS -->
	<link rel="stylesheet"
		href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
	
	<!--Credential Handler API Polyfill-->
	<script
		src="https://unpkg.com/credential-handler-polyfill@2.2.1/dist/credential-handler-polyfill.min.js"></script>
	<script
		src="https://unpkg.com/web-credential-handler@1.0.1/dist/web-credential-handler.min.js"></script>
	
	<script src='<c:url value="/js/config.js" />'></script>
	<script src='<c:url value="/js/js-helpers.js" />'></script>
	<script src='<c:url value="/js/install-wallet.js"/>'></script>
	<%-- <script src='<c:url value="/js/mock-user-management.js" />'></script> --%>
	<script src='<c:url value="/js/mock-user-management.js?ver=2" />'></script>
	
	<!--Simple cookie lib-->
	<script src="https://cdn.jsdelivr.net/npm/js-cookie@beta/dist/js.cookie.min.js"></script>
	
	<title>DemoWeb</title>
</head>
<body>
	<div class="container">
		<div class="card-panel">
			<h1>Demo Wallet</h1>
			<a class="waves-effect waves-light btn" href="${pageContext.request.contextPath }/">Home</a>  
			<p>페이지 로딩에서 'Allow'를 클릭하면 이 페이지가 브라우저에 등록되어 테스트 월렛 역할 수행 가능</p>

			<div class="card-panel hide" id="logged-in">
				<p>
					<strong>Logged in:</strong> <span id="username"></span>
					<h6>Wallet 내용:</h6>
					<ol id="walletContents"></ol>
				</p>
				<a class="waves-effect waves-light btn" id="logoutButton">Reset and Logout</a>
			</div>

			<div class="card-panel hide" id="logged-out">
				<p>
					지갑을 사용하기 시작하려면, 이름을 입력하고 <strong>Login</strong> 버튼을 눌러주세요.
				</p>
				<!-- <p>현재 데모는 등록을 건너 뛰고 테스트 계정을 사용합니다. </p> -->
				
				<input type="text" value="" placeholder="이름 입력" name="user" id="name" />
				
				<a class="waves-effect waves-light btn" id="loginButton" onClick='login(document.getElementById("name").value)' >Login</a>
			</div>
		</div>
	</div>

	<script>
	  console.log('Registering wallet...');
	
	  // Registers this demo wallet with the current user's browser,
	  // from install-wallet.js
	  registerWalletWithBrowser()
	    .catch(e => console.error('Error in registerWalletWithBrowser:', e));
	
	  // Set up the UI / button events.
	  // `onDocumentReady` helper function is defined in ./js-helpers.js
	  onDocumentReady(() => {
	    // document.getElementById('loginButton').addEventListener('click', login);
	    document.getElementById('logoutButton').addEventListener('click', logout);
	    refreshUserArea();
	  });
	</script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
</body>
</html>
