# CHAPI-demo-java
[credential-handler-polyfill](https://github.com/digitalbazaar/credential-handler-polyfill)를 활용한 wallet demo

CHAPI의 Demo를 가지고 Wallet 과 Credential의 특징을 공부해보았다.

javascript
- WebStorage
- IndexedDB
- polyfill
- WebCredential

- [jose4j (JWT Java라이브러리)](https://bitbucket.org/b_c/jose4j/wiki/Home)
  - [ExampleRsaKeyFromJws.java](https://bitbucket.org/b_c/jose4j/src/ff6d6c2ee7b94ca5e1ee9c17b4647938110bd07d/src/test/java/org/jose4j/keys/ExampleRsaKeyFromJws.java#lines-101)
  - RS256 (RSA-256, RSASSA-PKCS1-V1_5 Digital Signatures with with SHA-2)
  ![JWS-RSA256](https://user-images.githubusercontent.com/75015048/148014769-127bc73e-917f-4b2a-9958-b05ce2f19eae.png)

# 1차 변경
<img width="100%" src="https://user-images.githubusercontent.com/75015048/147902131-0acb8035-28a8-405a-9a5e-bb3d8d5b6502.gif"/>

# 2차 변경
JWS 생성은 되나 credential-handler-polyfill을 이용한 저장과정에서 자꾸 누락되어서 보류

<img width="100%" src="https://user-images.githubusercontent.com/75015048/148498111-75b45e39-b687-44e6-89f5-948bdc6c72d0.gif"/>


# 참고
- [W3C의 Methods 와 Method Syntax](https://www.w3.org/TR/did-core/#methods)

- [W3C의 creation-of-a-did](https://www.w3.org/TR/did-core/#creation-of-a-did)

- [W3C의 did-syntax](https://www.w3.org/TR/did-core/#did-syntax)

![W3C의 detailed-architecture-diagram](https://www.w3.org/TR/did-core/diagrams/did_detailed_architecture_overview.svg)