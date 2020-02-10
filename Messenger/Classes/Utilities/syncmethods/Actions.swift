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
import CryptoSwift

//-------------------------------------------------------------------------------------------------------------------------------------------------
class Actions: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func create(chatId: String, userIds: [String]) {

		let realm = try! Realm()
		try! realm.safeWrite {
			for userId in userIds {
				let action = Action()
				action.objectId = "\(chatId)-\(userId)".md5()
				action.chatId = chatId
				action.userId = userId
				realm.add(action, update: .modified)
			}
		}
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func update(chatId: String, userIds: [String]) {

		var userIds = userIds

		let predicate = NSPredicate(format: "chatId == %@ AND userId IN %@", chatId, userIds)
		let actions = realm.objects(Action.self).filter(predicate)

		for action in actions {
			userIds.removeObject(action.userId)
		}

		self.create(chatId: chatId, userIds: userIds)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func update(chatId: String, mutedUntil: Int64) {

		let predicate = NSPredicate(format: "chatId == %@ AND userId == %@", chatId, AuthUser.userId())
		if let action = realm.objects(Action.self).filter(predicate).first {
			action.update(mutedUntil: mutedUntil)
		}
	}
}
