<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 해당 JSP의 인코딩을 UTF-8로 설정 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<!-- Compiled and minified Materialize JS/CSS -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/
	1.0.0/css/materialize.min.css">
	
	
	<!--Credential Handler API Polyfill-->
	<script src="https://unpkg.com/credential-handler-polyfill@2.2.1/dist/credential-handler-polyfill.min.js"></script>
	
  	<script src='<c:url value="/js/config.js" />'></script>
  	<script src='<c:url value="/js/mock-user-management.js" />'></script>
	
	<title>DemoWeb</title>
</head>
<body>
	<div class="container">
	  <div class="card-panel">
		<h1>Credential Verifier</h1>
	
	    <a class="waves-effect waves-light btn" id="requestButton">Credential 보내기</a>
	  </div>
	
	  <div class="card-panel hide" id="resultsPanel">
	    <h6>가져온 결과</h6>
	
	    <pre><code id="getResults"></code></pre>
	  </div>
	</div>
	<script>
	  async function onClickRequest() {
	    //   document.getElementById('getResults').innerHTML = ''; // clear results
	    
	    // 실패 했을 경우 이런 형식으로 보내달라는 예시를 담는 부분
	      const credentialQuery =   {
	        "web": {
	          "VerifiablePresentation": {
	            "query": [{
	              "type": "QueryByExample",
	              "credentialQuery": {
	           	/*  "reason": "Please present a UniversityDegreeCredential for JaneDoe.", */
	                /* "reason": "JaneDoe에 대한 UniversityDegreeCredential 을 제시 해주세요.", */
	                "reason": loadCurrentUser()+ "에 대한 Credential 을 제시 해주세요.",
	                "example": {
	                  "@context": [
	                    "https://w3id.org/credentials/v1",
	                    "https://www.w3.org/2018/credentials/examples/v1"
	                  ],
	                  "type": ["UniversityDegreeCredential"],
	                  "credentialSubject": {
	                    "id": "did:example:ebfeb1f712ebc6f1c276e12ec21"
	                  }
	                }
	              }
	            }]
	          },
	          "recommendedHandlerOrigins": [
	        	  /* 
	        	  	여기 부분도 수정해야한다.
	        	  */
	            // "https://chapi-demo-wallet.digitalbazaar.com"
	        	  window.location.hostname
	          ]
	        }
	      }
	
	      console.log('Requesting credential...');
	      document.getElementById('getResults').innerText = 'Requesting credential...';
	
	      const result = await navigator.credentials.get(credentialQuery);
	
	      document.getElementById('resultsPanel').classList.remove('hide');
	      document.getElementById('getResults').innerText = JSON.stringify(result, null, 2);
	
	      console.log('Result of get() request:', JSON.stringify(result, null, 2));
	  }
	
	  function ready(fn) {
	    if (document.readyState !== 'loading'){
	      fn();
	    } else {
	      document.addEventListener('DOMContentLoaded', fn);
	    }
	  }
	
	  ready(() => {
	    document.getElementById('requestButton').addEventListener('click', onClickRequest);
	    console.log('Document ready.')
	  })
	
	 /*  const MEDIATOR = 'https://authn.io/mediator' + '?origin=' +
	    encodeURIComponent(window.location.origin);
	 */
	 
	  credentialHandlerPolyfill
	    .loadOnce(MEDIATOR)
	    .then(console.log('Polyfill loaded.'))
	    .catch(e => console.error('Error loading polyfill:', e));
	</script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
</body>
</html>
