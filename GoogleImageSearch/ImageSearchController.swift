import UIKit

let reuseIdentifier = "ImageCell"
let scaleConstant : CGFloat = 0.67

class ImageSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    var searchResults = [GoogleImage]()
    let google = GoogleImageSearch()

    var fetching = false
    var currentPage = 0
    var currentSearchTerm : String?

    func loadDataFromGoogle(){
        google.searchForTerm(currentSearchTerm!, page: currentPage) {
            results, error in
            if let error = error {
                var errorUI = UIAlertController(title: "Error", message: error.description, preferredStyle: .Alert)
                errorUI.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(errorUI, animated: true, completion: nil)
            }

            if let results = results where results.count > 0 {
                self.searchResults += results
                self.fetching = false

                var indexPaths = [AnyObject]()
                for i in (self.currentPage*8)..<(self.currentPage*8)+8 {
                    indexPaths.append(NSIndexPath(forItem: i, inSection: 0))
                }

                self.collectionView?.insertItemsAtIndexPaths(indexPaths)
                self.currentPage++
                if self.currentPage < 3 {
                    self.loadDataFromGoogle()
                }
            }
        }
    }

    func photoForIndexPath(indexPath: NSIndexPath) -> GoogleImage {
        return searchResults[indexPath.row]
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {
            if !self.fetching && self.currentSearchTerm != nil && self.currentPage < 8 {
                self.fetching = true
                loadDataFromGoogle()
            }
        }
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        currentSearchTerm = textField.text
        searchResults = [GoogleImage]()
        collectionView?.reloadData()
        currentPage = 0
        loadDataFromGoogle()
        textField.resignFirstResponder()
        return true
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCell

        let googlePhoto = photoForIndexPath(indexPath)
        cell.imageView.image = googlePhoto.thumbnail

        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let googlePhoto =  photoForIndexPath(indexPath)

        if var size = googlePhoto.thumbnail?.size {
            size.height = size.height * scaleConstant
            size.width = size.width * scaleConstant

            return size
        }
        return CGSize(width: 100, height: 100)
    }
}
