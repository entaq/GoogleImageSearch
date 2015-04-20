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

        describe("initial state") {
            it("has no default search value") {
                expect(viewController.searchField.text).to(equal(""))
            }

            it("should show the right place holder text") {
                expect(viewController.searchField.placeholder).to(equal("Search"))
            }

            it("should not be showing the activity indicator") {
                expect(viewController.activityIndicator.hidden).to(beTrue())
            }
        }

        describe("search text was entered") {
            beforeEach {
                viewController.searchField.text = "nadal"
                viewController.textFieldShouldReturn(viewController.searchField)
            }

            it("starts the search and shows the activity invicator") {
                expect(viewController.activityIndicator.hidden).to(beFalse())
            }

        }
    }
}
