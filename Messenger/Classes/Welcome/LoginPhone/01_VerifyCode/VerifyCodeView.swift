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

import ProgressHUD

//-------------------------------------------------------------------------------------------------------------------------------------------------
@objc protocol VerifyCodeDelegate: class {

	func didVerifyCode(verificationCode: String)
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
class VerifyCodeView: UIViewController {

	@IBOutlet weak var delegate: VerifyCodeDelegate?

	@IBOutlet private var labelHeader: UILabel!
	@IBOutlet private var fieldCode: UITextField!

	private var countryCode = ""
	private var phoneNumber = ""

	//---------------------------------------------------------------------------------------------------------------------------------------------
	init(countryCode: String, phoneNumber: String) {

		super.init(nibName: nil, bundle: nil)

		self.countryCode = countryCode
		self.phoneNumber = phoneNumber
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	required init?(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "SMS Verification"

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionDismiss))

		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(gestureRecognizer)
		gestureRecognizer.cancelsTouchesInView = false

		labelHeader.text = "Enter the verification code sent to\n\n\(countryCode) \(phoneNumber)"
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidAppear(_ animated: Bool) {

		super.viewDidAppear(animated)

		fieldCode.becomeFirstResponder()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func dismissKeyboard() {

		view.endEditing(true)
	}

	// MARK: - User actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionDismiss() {

		dismiss(animated: true)
	}
}

// MARK: - UITextFieldDelegate
//-------------------------------------------------------------------------------------------------------------------------------------------------
extension VerifyCodeView: UITextFieldDelegate {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		let text = (textField.text ?? "") as NSString
		let code = text.replacingCharacters(in: range, with: string)

		if (code.count == 6) {
			dismissKeyboard()
			ProgressHUD.show(nil, interaction: false)

			DispatchQueue.main.async(after: 0.25) {
				self.dismiss(animated: true) {
					self.delegate?.didVerifyCode(verificationCode: code)
				}
			}
		}

		return (code.count <= 6)
	}
}
