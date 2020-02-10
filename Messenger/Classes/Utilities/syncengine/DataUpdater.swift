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
import RealmSwift

//-------------------------------------------------------------------------------------------------------------------------------------------------
class DataUpdater: NSObject {

	private var name: String = ""

	private var updating = false

	private var objects: Results<SyncObject>?

	//---------------------------------------------------------------------------------------------------------------------------------------------
	init(name: String, type: SyncObject.Type) {

		super.init()

		self.name = name

		let predicate = NSPredicate(format: "syncRequired == YES")
		objects = realm.objects(type).filter(predicate).sorted(byKeyPath: "updatedAt")

		Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
			if (AuthUser.userId() != "") {
				if (Connectivity.isReachable()) {
					self.updateNextObject()
				}
			}
		}
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func updateNextObject() {

		if (updating) { return }

		if let object = objects?.first {
			updateObject(object: object)
		}
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func updateObject(object: SyncObject) {

		updating = true

		let values = populateValues(object: object)

		if (object.neverSynced) {
			Firestore.firestore().collection(name).document(object.objectId).setData(values) { error in
				if (error == nil) {
					object.updateSynced()
				}
				self.updating = false
			}
		} else {
			Firestore.firestore().collection(name).document(object.objectId).updateData(values) { error in
				if (error == nil) {
					object.updateSynced()
				}
				self.updating = false
			}
		}
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func populateValues(object: SyncObject) -> [String: Any] {

		var values: [String: Any] = [:]

		for property in object.objectSchema.properties {
			populateValue(object: object, property: property, values: &values)
		}

		if (object.neverSynced) {
			values["createdAt"] = FieldValue.serverTimestamp()
		} else {
			values["createdAt"] = Timestamp.create(object.createdAt)
		}

		values["updatedAt"] = FieldValue.serverTimestamp()

		values.removeValue(forKey: "neverSynced")
		values.removeValue(forKey: "syncRequired")

		return values
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func populateValue(object: SyncObject, property: Property, values: inout [String: Any]) {

		switch property.type {
			case .int:
				if let value = object[property.name] as? Int64 {
					values[property.name] = value
				}
			case .bool:
				if let value = object[property.name] as? Bool {
					values[property.name] = value
				}
			case .float:
				if let value = object[property.name] as? Float {
					values[property.name] = value
				}
			case .double:
				if let value = object[property.name] as? Double {
					values[property.name] = value
				}
			case .string:
				if let value = object[property.name] as? String {
					values[property.name] = value
				}
			case .date:
				if let value = object[property.name] as? Date {
					values[property.name] = value
				}
			default:
				print("Property type \(property.type.rawValue) is not populated.")
				break
		}
	}
}
