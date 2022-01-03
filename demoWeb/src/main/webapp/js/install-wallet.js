/* global navigator, window, document */
'use strict';

/**
 * Helper function for registering a wallet with the user's browser.
 *
 * NOTE: Only needed for implementors of custom wallets; client code that just
 * wants to receive and verify credentials does not need to do this.
 *
 * This script is loaded in ./index.html.
 *
 * Globals:
 *   WALLET_LOCATION - from local config.js
 *   MEDIATOR - from local config.js
 *
 *   credentialHandlerPolyfill - from credential-handler-polyfill.min.js script.
 *
 *   WebCredentialHandler - from web-credential-handler.min.js.
 *      Utility/convenience library for the CHAPI polyfill, useful for wallet
 *      implementors.
 */

//const workerUrl = WALLET_LOCATION + 'wallet-worker.html';
const workerUrl = WALLET_LOCATION + 'wallet-worker';

async function registerWalletWithBrowser() {
  try {
    await credentialHandlerPolyfill.loadOnce(MEDIATOR);
  } catch(e) {
    console.error('Error in loadOnce:', e);
  }

  console.log('Polyfill loaded.');

  console.log('Installing wallet worker handler at:', workerUrl);

  const registration = await WebCredentialHandler.installHandler({url: workerUrl});

	/*
		IndexedDB에 저장되는 데이터 수정이 필요해 보인다.	
	*/
  await registration.credentialManager.hints.set(
    'test', {
      name: 'TestUser',
      enabledTypes: ['VerifiablePresentation', 'VerifiableCredential', 'AlumniCredential']
      // enabledTypes: ['VerifiablePresentation']
    });

  console.log('Wallet registered.');
}