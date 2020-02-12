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

import FirebaseFirestore

//-------------------------------------------------------------------------------------------------------------------------------------------------
class DataObservers: NSObject {

	private var observerPerson:		DataObserver?
	private var observerFriend:		DataObserver?
	private var observerBlocked:	DataObserver?
	private var observerBlocker:	DataObserver?
	private var observerMember:		DataObserver?

	private var observerMembers:	[String: DataObserver] = [:]
	private var observerGroups:		[String: DataObserver] = [:]
	private var observerSingles:	[String: DataObserver] = [:]
	private var observerDetails:	[String: DataObserver] = [:]
	private var observerActions:	[String: DataObserver] = [:]
	private var observerMessages:	[String: DataObserver] = [:]

	//---------------------------------------------------------------------------------------------------------------------------------------------
	static let shared: DataObservers = {
		let instance = DataObservers()
		return instance
	} ()

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override init() {

		super.init()

		NotificationCenter.addObserver(target: self, selector: #selector(initObservers), name: NOTIFICATION_APP_STARTED)
		NotificationCenter.addObserver(target: self, selector: #selector(initObservers), name: NOTIFICATION_USER_LOGGED_IN)
		NotificationCenter.addObserver(target: self, selector: #selector(stopObservers), name: NOTIFICATION_USER_LOGGED_OUT)
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc private func initObservers() {

		if (AuthUser.userId() != "") {
			if (observerPerson == nil)	{ createObserverPerson()	}
			if (observerFriend == nil)	{ createObserverFriend()	}
			if (observerBlocked == nil)	{ createObserverBlocked()	}
			if (observerBlocker == nil)	{ createObserverBlocker()	}
			if (observerMember == nil)	{ createObserverMember()	}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc private func stopObservers() {

		observerPerson?.removeObserver();		observerPerson = nil
		observerFriend?.removeObserver();		observerFriend = nil
		observerBlocked?.removeObserver();		observerBlocked = nil
		observerBlocker?.removeObserver();		observerBlocker = nil
		observerMember?.removeObserver();		observerMember = nil

		for chatId in observerMembers.keys	{ observerMembers[chatId]?.removeObserver()	 }
		for chatId in observerGroups.keys	{ observerGroups[chatId]?.removeObserver()	 }
		for chatId in observerSingles.keys	{ observerSingles[chatId]?.removeObserver()	 }
		for chatId in observerDetails.keys	{ observerDetails[chatId]?.removeObserver()	 }
		for chatId in observerActions.keys	{ observerActions[chatId]?.removeObserver()	 }
		for chatId in observerMessages.keys	{ observerMessages[chatId]?.removeObserver() }

		observerMembers.removeAll()
		observerGroups.removeAll()
		observerSingles.removeAll()
		observerDetails.removeAll()
		observerActions.removeAll()
		observerMessages.removeAll()
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverPerson() {

		let query = Firestore.firestore().collection("Person")
			.whereField("updatedAt", isGreaterThan: Timestamp.create(Person.lastUpdatedAt()))
		observerPerson = DataObserver(query, to: Person.self)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverFriend() {

		let query = Firestore.firestore().collection("Friend")
			.whereField("userId", isEqualTo: AuthUser.userId())
		observerFriend = DataObserver(query, to: Friend.self)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverBlocked() {

		let query = Firestore.firestore().collection("Blocked")
			.whereField("blockedId", isEqualTo: AuthUser.userId())
		observerBlocked = DataObserver(query, to: Blocked.self)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverBlocker() {

		let query = Firestore.firestore().collection("Blocked")
			.whereField("blockerId", isEqualTo: AuthUser.userId())
		observerBlocker = DataObserver(query, to: Blocked.self)
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverMember() {

		let query = Firestore.firestore().collection("Member")
			.whereField("userId", isEqualTo: AuthUser.userId())
		observerMember = DataObserver(query, to: Member.self) { insert, modify in
			if (insert) {
				if let chatIds = Members.chatIds() {
					self.createObserverMembers(chatIds)
					self.createObserverGroup(chatIds)
					self.createObserverSingle(chatIds)
					self.createObserverDetail(chatIds)
					self.createObserverAction(chatIds)
					self.createObserverMessage(chatIds)
				}
			}
		}
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverMembers(_ chatIds: [String]) {

		for chatId in chatIds {
			if (observerMembers[chatId] == nil) {
				let query = Firestore.firestore().collection("Member").whereField("chatId", isEqualTo: chatId)
				observerMembers[chatId] = DataObserver(query, to: Member.self)
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverGroup(_ chatIds: [String]) {

		for chatId in chatIds {
			if (observerGroups[chatId] == nil) {
				let query = Firestore.firestore().collection("Group").whereField("chatId", isEqualTo: chatId)
				observerGroups[chatId] = DataObserver(query, to: Group.self)
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverSingle(_ chatIds: [String]) {

		for chatId in chatIds {
			if (observerSingles[chatId] == nil) {
				let query = Firestore.firestore().collection("Single").whereField("chatId", isEqualTo: chatId)
				observerSingles[chatId] = DataObserver(query, to: Single.self)
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverDetail(_ chatIds: [String]) {

		for chatId in chatIds {
			if (observerDetails[chatId] == nil) {
				let query = Firestore.firestore().collection("Detail").whereField("chatId", isEqualTo: chatId)
				observerDetails[chatId] = DataObserver(query, to: Detail.self)
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverAction(_ chatIds: [String]) {

		for chatId in chatIds {
			if (observerActions[chatId] == nil) {
				let query = Firestore.firestore().collection("Action").whereField("chatId", isEqualTo: chatId)
				observerActions[chatId] = DataObserver(query, to: Action.self)
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverMessage(_ chatIds: [String]) {

		for chatId in chatIds {
			if (observerMessages[chatId] == nil) {
				let query = Firestore.firestore().collection("Message").whereField("chatId", isEqualTo: chatId)
					.whereField("updatedAt", isGreaterThan: Timestamp.create(Message.lastUpdatedAt(chatId)))
				observerMessages[chatId] = DataObserver(query, to: Message.self)
			}
		}
	}
}
