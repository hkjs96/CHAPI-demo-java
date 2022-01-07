<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 해당 JSP의 인코딩을 UTF-8로 설정 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<!-- Compiled and minified Materialize JS/CSS -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
	
	
	<!--Credential Handler API Polyfill-->
	<script
		src="https://unpkg.com/credential-handler-polyfill@2.2.1/dist/credential-handler-polyfill.min.js"></script>
	
	<!-- jQuery CDN -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	
	<script src='<c:url value="/js/mock-user-management.js" />'></script>
	<script src='<c:url value="/js/uuid.js" />'></script>
	
	<title>DemoWeb</title>
</head>
<body>
	<div class="container">
		<div class="card-panel">
			<h1>Verified Credential Issuer</h1>
			<a class="waves-effect waves-light btn" href="${pageContext.request.contextPath }/">Home</a><hr>
			
			<form>
				<div class="input-field">
					<select name="issuer" id="issuer">
						<option value="" disabled selected>선택하세요.</option>
						<option value="goverment" data-ctype="GovermentDegreeCredential"
							data-cid="http://gov.kr/"
							data-credential-id="gov">정부</option>
						<option value="police" data-ctype="PoliceDegreeCredential"
							data-cid="http://police.co.kr/"
							data-credential-id="pol">경찰청</option>
						<option value="univercity" data-ctype="UniversityDegreeCredential"
							data-cid="http://uni.edu/"
							data-credential-id="uni">대학교</option>
					</select>
					<label for="issuer">Issuer</label>
				</div>
			</form>
			<a class="waves-effect waves-light btn" id="receiveButton">Credential 발급 하기</a>		
			
		</div>

		<div class="card-panel hide" id="resultsPanel">
<!-- 			<h6>Result of store() operation:</h6> -->
			<h6>저장한 결과</h6>

			<pre>
				<code id="storeResults"></code>
			</pre>
		</div>
	</div>
	
	<script>
	  // ^ Note that:
	  // 1. The Verifiable Credential is signed, and wrapped in a VerifiablePresentation.
	  // 2. The wrapping VerifiablePresentation is not signed.

	  /**
	  	이름과 발급 기관을 입력 받아 해당하는 VC를 만들기 위함.
	  */
	  async function onClickReceive() {
//	  function onClickReceive() {
	      // let uname = document.getElementById('user');
	      // let issuer = document.getElementById('issuer');
	      let issuer = $("#issuer option:selected");

	      // if (uname.value.length <= 0 && issuer.value == "") {
	      if (loadCurrentUser().length <= 0 && issuer.value == "") {
	          return;
	      }
	      /* const testCredential = (uname, issuer) => { */

          // saveCurrentUser(uname.value);
          
          /*
          	발급 시간을 위한 목적으로 만든 것
          */
          let today = new Date();
          // 현재 포멧에는 Date.toISOString() 메서드를 사용하는 것이 맞다.
          // console.log(today.toISOString());
                    
          /*
          	dataset
          	 - ctype : credentialType
          	 - cid : credential issuer 의 id에 들어가는 값
          	 - credential-id : credential 의 DID의 method  
          */
          // const testCredential = {
          let testCredential = {
              "@context": [
                  "https://www.w3.org/2018/credentials/v1",
                  /* "https://www.w3.org/2018/credentials/examples/v1" */
                  "https://www.w3.org/2018/credentials/"+ issuer.val() +"/v1"
              ],
              "type": "VerifiablePresentation",
              "verifiableCredential": [{
                  "@context": [
                      "https://www.w3.org/2018/credentials/v1",
                      /* "https://www.w3.org/2018/credentials/examples/v1" */
                      "https://www.w3.org/2018/credentials/"+ issuer.val() +"/v1"
                  ],
                  /* "id": "http://example.edu/credentials/1872", */
                  "id": issuer.data('cid') + "credentials/1872",
                  /* "type": ["VerifiableCredential", "UniversityDegreeCredential"], */
                  "type": ["VerifiableCredential", issuer.data('ctype')],
                  /* "issuer": "https://example.edu/issuers/565049", */
                  /* "issuer": issuer.data('ctype') + "issuer/565049", */
                  "issuer": issuer.data('ctype') + "issuer/" + Math.floor(Math.random() * 999999 + 1) ,
                  "issuanceDate": "2010-01-01T19:73:24Z",
                  "credentialSubject": {
                      /* "id": "did:example:ebfeb1f712ebc6f1c276e12ec21", */
                      /* "id": "did:" + issuer.data('credentialId') + ":ebfeb1f712ebc6f1c276e12ec21", */
                      "id": "did:" + issuer.data('credentialId') + ":" + getUUID(),
                      "alumniOf": {
                          /* "id": "did:" + issuer.data('credentialId') + ":c276e12ec21ebfeb1f712ebc6f1", */
                          "id": "did:" + issuer.data('credentialId') + ":" + getUUID(),
                          "name": {
                              /* "@value": "Example University", */
                              "@value": issuer.val(),
                              "@language": "en"
                          }
                      }
                  },
                  "proof": {
                      "type": "RsaSignature2018",
                      /* 	        "created": "2017-06-18T21:19:10Z", */
                      "created": today.toISOString(),
                      "proofPurpose": "assertionMethod",
                      /* "verificationMethod": "https://example.edu/issuers/keys/1", */
                      "verificationMethod": issuer.data('cid') + "issuers/keys/1",
                      "jws": "eyJhbGciOiJSUzI1NiIsImI2NCI6ZmFsc2UsImNyaXQiOlsiYjY0Il19..TCYt5XsITJX1CxPCT8yAV-TVkIEq_PbChOMqsLfRoPsnsgw5WEuts01mq-pQy7UJiN5mgRxD-WUcX16dUEMGlv50aqzpqh4Qktb3rk-BuQy72IFLOqV0G_zS245-kronKb78cPN25DGlcTwLtjPAYuNzVBAh4vGHSrQyHUdBBPM"
                      // "jws": ""
                  }
              }]
          };
          
          /*
          	여기 AJAX로 데이터 보내는 부분 JSON 데이터로 보낼 수 있게 준비해야한다.
          	컨트롤러에서 못받는다. 넘어오는건 String으로 넘어오게 처리했다.
          */
	      
          let cdata = JSON.stringify(testCredential);
          
          let ajax = new XMLHttpRequest();
          const url = '${pageContext.request.contextPath }/createJws';
          
		  const credentialType = 'VerifiablePresentation';
	      
	      const webCredentialWrapper = new WebCredential(
	          credentialType, testCredential, {
	              recommendedHandlerOrigins: [
	                  window.location.hostname
	              ]
	          });

	      document.getElementById('storeResults').innerText = 'Credential 을 저장 중 입니다.';

	      // Use Credential Handler API to store
	      const result = await navigator.credentials.store(webCredentialWrapper);

	      console.log(result);
	      
	      if (!result) {
	          return;
	      }

	      document.getElementById('resultsPanel').classList.remove('hide');
	      document.getElementById('storeResults').innerText = JSON.stringify(result, null, 2);

	      console.log('Result of receiving via store() request:', result);
          
	      /*
	      
	      jws 생성한 것이 저장하면 ctore 함수로 보내면 들어가지 않는다.
          ajax.onreadystatechange = function() {
        	  let jws = '';
       		  jws = ajax.response
       		  console.log(jws);
       		  testCredential['verifiableCredential'][0]['proof']['jws'] = jws;
       		  const credential = testCredential;
       		  console.log(credential);
       		  cstore(credential);
          };
          ajax.open("POST", url, true); // ajax.open("POST", url, true);
          ajax.setRequestHeader("Content-Type", "application/json");
          ajax.send(cdata);
          */
	  }
          
      /*    
	  async function cstore(testCredential) {
		// Construct the WebCredential wrapper around the credential to be stored
	      const credentialType = 'VerifiablePresentation';
	      
	      const webCredentialWrapper = new WebCredential(
	          credentialType, testCredential, {
	              recommendedHandlerOrigins: [
	                  window.location.hostname
	              ]
	          });

	      document.getElementById('storeResults').innerText = 'Credential 을 저장 중 입니다.';

	      // Use Credential Handler API to store
	      const result = await navigator.credentials.store(webCredentialWrapper);

	      console.log(result);
	      
	      if (!result) {
	          return;
	      }

	      document.getElementById('resultsPanel').classList.remove('hide');
	      document.getElementById('storeResults').innerText = JSON.stringify(result, null, 2);

	      console.log('Result of receiving via store() request:', result);
      }
      */

	  function ready(fn) {
	      if (document.readyState !== 'loading') {
	          fn();
	      } else {
	          document.addEventListener('DOMContentLoaded', fn);
	      }
	  }

	  ready(() => {
	      document.getElementById('receiveButton').addEventListener('click', onClickReceive);
	      console.log('Document ready.')

	      $('select').formSelect();
	  })

	  const MEDIATOR = 'https://authn.io/mediator' + '?origin=' +
	      encodeURIComponent(window.location.origin);

	  credentialHandlerPolyfill
	      .loadOnce(MEDIATOR)
	      .then(console.log('Polyfill loaded.'))
	      .catch(e => console.error('Error loading polyfill:', e));
	</script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
</body>
</html>
