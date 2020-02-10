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

	private var observerMembers:	DataObserver?
	private var observerGroup:		DataObserver?
	private var observerSingle:		DataObserver?
	private var observerDetail:		DataObserver?
	private var observerAction:		DataObserver?
	private var observerMessage:	DataObserver?

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

		observerMembers?.removeObserver();		observerMembers = nil
		observerGroup?.removeObserver();		observerGroup = nil
		observerSingle?.removeObserver();		observerSingle = nil
		observerDetail?.removeObserver();		observerDetail = nil
		observerAction?.removeObserver();		observerAction = nil
		observerMessage?.removeObserver();		observerMessage = nil
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
					DataFetcher.fetchMissingMessages(chatIds)
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

		observerMembers?.removeObserver()
		let query = Firestore.firestore().collection("Member")
			.whereField("chatId", in: chatIds)
		observerMembers = DataObserver(query, to: Member.self)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverGroup(_ chatIds: [String]) {

		observerGroup?.removeObserver()
		let query = Firestore.firestore().collection("Group")
			.whereField("objectId", in: chatIds)
		observerGroup = DataObserver(query, to: Group.self)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverSingle(_ chatIds: [String]) {

		observerSingle?.removeObserver()
		let query = Firestore.firestore().collection("Single")
			.whereField("objectId", in: chatIds)
		observerSingle = DataObserver(query, to: Single.self)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverDetail(_ chatIds: [String]) {

		observerDetail?.removeObserver()
		let query = Firestore.firestore().collection("Detail")
			.whereField("chatId", in: chatIds)
		observerDetail = DataObserver(query, to: Detail.self)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverAction(_ chatIds: [String]) {

		observerAction?.removeObserver()
		let query = Firestore.firestore().collection("Action")
			.whereField("chatId", in: chatIds)
		observerAction = DataObserver(query, to: Action.self)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func createObserverMessage(_ chatIds: [String]) {

		observerMessage?.removeObserver()
		let query = Firestore.firestore().collection("Message")
			.whereField("chatId", in: chatIds)
			.whereField("updatedAt", isGreaterThan: Timestamp.create(Message.lastUpdatedAt()))
		observerMessage = DataObserver(query, to: Message.self)
	}
}
