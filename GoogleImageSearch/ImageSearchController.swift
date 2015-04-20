import UIKit

let reuseIdentifier = "ImageCell"

class ImageSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    var searchResults = [GoogleImage]()
    let google = GoogleImageSearch()

    var fetching: Bool = false
    var currentPage = 0
    var currentSearchTerm : String?


    func loadDataFromGoogle(){
        //        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        //        textField.addSubview(activityIndicator)
        //        activityIndicator.frame = textField.bounds
        //        activityIndicator.startAnimating()

        google.searchForTerm(currentSearchTerm!, page: currentPage) {
            results, error in

            //activityIndicator.removeFromSuperview()
            if error != nil {
//                println("Error searching : \(error)")
            }

            if results != nil {
                self.searchResults += results!
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
            size.height = size.height * 0.67
            size.width = size.width * 0.67

            return size
        }
        return CGSize(width: 100, height: 100)
    }
}
