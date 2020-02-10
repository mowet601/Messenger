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

import RealmSwift

//-------------------------------------------------------------------------------------------------------------------------------------------------
class Detail: SyncObject {

	@objc dynamic var chatId = ""
	@objc dynamic var userId = ""

	@objc dynamic var isDeleted = false
	@objc dynamic var isArchived = false

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func update(isDeleted value: Bool) {

		if (isDeleted == value) { return }

		let realm = try! Realm()
		try! realm.safeWrite {
			isDeleted = value
			syncRequired = true
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func update(isArchived value: Bool) {

		if (isArchived == value) { return }

		let realm = try! Realm()
		try! realm.safeWrite {
			isArchived = value
			syncRequired = true
		}
	}
}
