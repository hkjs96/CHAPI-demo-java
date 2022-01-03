'use strict'

/**
 * UI Management
 */

function login() {
	//saveCurrentUser('JaneDoe'); // 여기 jane Doe 하드코딩된 것 어떻게 처리할 까 생각해야한다.
	// console.log(document.getElementById('name').value);
	// saveCurrentUser(document.getElementById('name').value); 
	refreshUserArea();
}


/*
	wallet 에서 Login 버튼 클릭 시 동작한.
	입력 받은 username을 현재 지갑의 사용자로 등록하고
	user UI 를 로그인 상태로 바뀌서 보여준다.
*/
function login(name) {
	saveCurrentUser(name); // 사용자 이름을 입력 받아 현재 사용자 이름으로 등록한다.
	refreshUserArea(); 
}

function logout() {
	resetCurrentUser();
	clearWalletDisplay();
	clearWalletStorage();
	refreshUserArea();
}

// user의 로그인 UI 상태를 보여준다.
function refreshUserArea({ shareButton } = {}) {
	const currentUser = loadCurrentUser();
	document.getElementById('username').innerHTML = currentUser;

	if (currentUser) {
		document.getElementById('logged-in').classList.remove('hide');
		document.getElementById('logged-out').classList.add('hide');
	} else {
		// not logged in
		document.getElementById('logged-in').classList.add('hide');
		document.getElementById('logged-out').classList.remove('hide');
	}

	// Refresh the user's list of wallet contents
	clearWalletDisplay();
	const walletContents = loadWalletContents();

	if (!walletContents) {
		return addToWalletDisplay({ text: 'none' });
	}

	for (const id in walletContents) {
		const vp = walletContents[id];
		// TODO: Add support for multi-credential VPs
		const vc = Array.isArray(vp.verifiableCredential)
			? vp.verifiableCredential[0]
			: vp.verifiableCredential;
		
		/*
			vp를 추출해서 제출
		*/
		addToWalletDisplay({
			text: `${getCredentialType(vc)} from ${vc.issuer}`,
			vc,
			button: shareButton
		});
	}
}

/**
 * Wallet Storage / Persistence
 */

function loadWalletContents() {
	/*const walletContents = Cookies.get('walletContents');*/
	const walletContents = localStorage.getItem('walletContents');
	if (!walletContents) {
		return null;
	}
	return JSON.parse(atob(walletContents));
}

function clearWalletStorage() {
	/*Cookies.remove('walletContents', {path: ''});*/
	localStorage.removeItem('walletContents');
}

function storeInWallet(verifiablePresentation) {
	const walletContents = loadWalletContents() || {};
	const id = getCredentialId(verifiablePresentation);
	walletContents[id] = verifiablePresentation;

	// base64 encode the serialized contents (verifiable presentations)
	const serialized = btoa(JSON.stringify(walletContents));
	/*Cookies.set('walletContents', serialized, {path: '', secure: true, sameSite: 'None'});*/
	localStorage.setItem('walletContents', serialized);
}

function clearWalletDisplay() {
	const contents = document.getElementById('walletContents');
	while (contents.firstChild)
		contents.removeChild(contents.firstChild);
}

function addToWalletDisplay({ text, vc, button }) {
	const li = document.createElement('li');

	if (button) {
		const buttonNode = document.createElement('a');
		buttonNode.classList.add('waves-effect', 'waves-light', 'btn-small');
		buttonNode.setAttribute('id', vc.id);
		buttonNode.appendChild(document.createTextNode(button.text));
		li.appendChild(buttonNode);
	}

	li.appendChild(document.createTextNode(' ' + text));

	document.getElementById('walletContents')
		.appendChild(li);

	if (button) {
		document.getElementById(vc.id).addEventListener('click', () => {
			/*
			const vp = {
				"@context": [
					"https://www.w3.org/2018/credentials/v1",
					"https://www.w3.org/2018/credentials/examples/v1"
				],
				"type": "VerifiablePresentation",
				"verifiableCredential": vc
			}
			console.log('wrapping and returning vc:', vp);
			*/
			// 위에 이상해서 원래 내용 가져와서 그대로 넣음. 이게 맞음.
			const vp = loadWalletContents()[vc.id];
			
			button.sourceEvent
				.respondWith(Promise.resolve({ dataType: 'VerifiablePresentation', data: vp }));
		});
	}
}

function getCredentialId(vp) {
	const vc = Array.isArray(vp.verifiableCredential)
		? vp.verifiableCredential[0]
		: vp.verifiableCredential;
	return vc.id;
}

function getCredentialType(vc) {
	if (!vc) {
		return 'Credential'
	};
	const types = Array.isArray(vc.type) ? vc.type : [vc.type];
	return types.length > 1 ? types.slice(1).join('/') : types[0];
}

/**
 * User Storage / Persistence
 */

function loadCurrentUser() {
	/*return Cookies.get('username') || '';*/
	return localStorage.getItem('username') || '';
}

function saveCurrentUser(name) {
	console.log('Setting login cookie.');
	/*Cookies.set('username', name, {path: '', secure: true, sameSite: 'None'});*/
	localStorage.setItem('username', name);
}

function resetCurrentUser() {
	console.log('Clearing login cookie.');
	/*Cookies.remove('username', {path: ''});*/
	localStorage.removeItem('username');
}