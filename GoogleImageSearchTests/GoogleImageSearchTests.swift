import UIKit
import Quick
import Nimble
import GoogleImageSearch

class GoogleImageSearchTests: QuickSpec {
    override func spec() {
        var viewController: ImageSearchController!

        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            viewController = storyboard.instantiateViewControllerWithIdentifier("ImageSearchControllerID") as! ImageSearchController

            let _ = viewController.view
        }

        describe(".viewDidLoad()") {
            it("has no default search value") {
                expect(viewController.currentSearchTerm).to(beNil())
            }
        }
    }
}
