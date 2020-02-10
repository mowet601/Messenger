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

import Foundation

//-------------------------------------------------------------------------------------------------------------------------------------------------
class DataUpdaters: NSObject {

	private var updaterPerson:	DataUpdater?
	private var updaterFriend:	DataUpdater?
	private var updaterBlocked:	DataUpdater?
	private var updaterMember:	DataUpdater?

	private var updaterGroup:	DataUpdater?
	private var updaterSingle:	DataUpdater?
	private var updaterDetail:	DataUpdater?
	private var updaterAction:	DataUpdater?
	private var updaterMessage:	DataUpdater?

	//---------------------------------------------------------------------------------------------------------------------------------------------
	static let shared: DataUpdaters = {
		let instance = DataUpdaters()
		return instance
	} ()

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override init() {

		super.init()

		updaterPerson	= DataUpdater(name: "Person", type: Person.self)
		updaterFriend	= DataUpdater(name: "Friend", type: Friend.self)
		updaterBlocked	= DataUpdater(name: "Blocked", type: Blocked.self)
		updaterMember	= DataUpdater(name: "Member", type: Member.self)

		updaterGroup	= DataUpdater(name: "Group", type: Group.self)
		updaterSingle	= DataUpdater(name: "Single", type: Single.self)
		updaterDetail	= DataUpdater(name: "Detail", type: Detail.self)
		updaterAction	= DataUpdater(name: "Action", type: Action.self)
		updaterMessage	= DataUpdater(name: "Message", type: Message.self)
	}
}
