//
// Copyright (c) 2020 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

//-------------------------------------------------------------------------------------------------------------------------------------------------
class WelcomeView: UIViewController {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionLoginPhone(_ sender: Any) {

		let loginPhoneView = LoginPhoneView()
		loginPhoneView.delegate = self
		let navController = NavigationController(rootViewController: loginPhoneView)
		if #available(iOS 13.0, *) {
			navController.isModalInPresentation = true
			navController.modalPresentationStyle = .fullScreen
		}
		present(navController, animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionLoginEmail(_ sender: Any) {

		let loginEmailView = LoginEmailView()
		loginEmailView.delegate = self
		if #available(iOS 13.0, *) {
			loginEmailView.isModalInPresentation = true
			loginEmailView.modalPresentationStyle = .fullScreen
		}
		present(loginEmailView, animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionRegisterEmail(_ sender: Any) {

		let registerEmailView = RegisterEmailView()
		registerEmailView.delegate = self
		if #available(iOS 13.0, *) {
			registerEmailView.isModalInPresentation = true
			registerEmailView.modalPresentationStyle = .fullScreen
		}
		present(registerEmailView, animated: true)
	}
}

// MARK: - LoginPhoneDelegate
//-------------------------------------------------------------------------------------------------------------------------------------------------
extension WelcomeView: LoginPhoneDelegate {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didLoginUserPhone() {

		dismiss(animated: true) {
			Users.loggedIn()
		}
	}
}

// MARK: - LoginEmailDelegate
//-------------------------------------------------------------------------------------------------------------------------------------------------
extension WelcomeView: LoginEmailDelegate {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didLoginUserEmail() {

		dismiss(animated: true) {
			Users.loggedIn()
		}
	}
}

// MARK: - RegisterEmailDelegate
//-------------------------------------------------------------------------------------------------------------------------------------------------
extension WelcomeView: RegisterEmailDelegate {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didRegisterUser() {

		dismiss(animated: true) {
			Users.loggedIn()
		}
	}
}
