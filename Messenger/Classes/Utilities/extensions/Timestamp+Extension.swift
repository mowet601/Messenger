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
extension Timestamp {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func timestamp() -> Int64 {

		return self.seconds * 1000 + Int64(self.nanoseconds / 1000000)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func create(_ timestamp: Int64) -> Timestamp {

		return Timestamp(seconds: timestamp / 1000, nanoseconds: Int32(timestamp % 1000) * 1000000)
	}
}
