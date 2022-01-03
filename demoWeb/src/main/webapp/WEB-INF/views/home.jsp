<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- 해당 JSP의 인코딩을 UTF-8로 설정 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
		<!--Credential Handler API Polyfill-->
	<script src="https://unpkg.com/credential-handler-polyfill@2.2.1/dist/credential-handler-polyfill.min.js"></script>
	<script src="https://unpkg.com/web-credential-handler@1.0.1/dist/web-credential-handler.min.js"></script>
	
	<script src="https://cdn.jsdelivr.net/npm/js-cookie@beta/dist/js.cookie.min.js"></script>
	
	<script src='<c:url value="/js/config.js" />'></script>
	<script src='<c:url value="/js/js-helpers.js" />'></script>
	<%-- <script src='<c:url value="/js/install-wallet.js"/>'></script> --%>
	<script src='<c:url value="/js/mock-user-management.js" />'></script>
	
	<title>DemoWeb</title>
</head>
<body>
<h1>
	Demo Web  
</h1>

<%-- <P>  현재 로케일은 ${localeInfo.displayName}. </P>
<P>  The time on the server is ${serverTime}. </P> --%>
	<ul>
		<li><a href="${pageContext.request.contextPath }/wallet">1. 지갑 등록 및 지갑 내용 확인하기</a></li>
		<li><a href="${pageContext.request.contextPath }/issuer">2. Credential 발급하기</a></li>
		<li><a href="${pageContext.request.contextPath }/verifier">3. Credential 내용 검증하기</a></li>
	</ul>
</body>
	<script>
		console.log('Registering wallet...');
		
		// Registers this demo wallet with the current user's browser,
		// from install-wallet.js
		registerWalletWithBrowser()
		  .catch(e => console.error('Error in registerWalletWithBrowser:', e));
	</script>
</html>
