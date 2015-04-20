import UIKit

class GoogleImage {
    var thumbnail : UIImage?
    // TODO: add other attributes in future like caption, page URL, image sizes
}

class GoogleImageSearch {
    var searchResults = [GoogleImage]()

    func searchForTerm(term: String, page: Int, completion: (results: [GoogleImage]?, error: NSError?) -> Void){

        let escapedTerm = term.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let URLString = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=\(escapedTerm)&rsz=8&start=\(page*8)"
        let searchURL = NSURL(string: URLString)!

        NSURLSession.sharedSession().dataTaskWithURL(searchURL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completion(results: nil, error: error)
                return
            }

            var jsonError : NSError?
            let resultsDictionary = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(0), error: &jsonError) as? NSDictionary
            if jsonError != nil {
                completion(results: nil, error: jsonError)
                return
            }

            let responeData = resultsDictionary!["responseData"] as! NSDictionary
            let photoResults = responeData["results"] as! [NSDictionary]

            let googlePhotos : [GoogleImage] = photoResults.map {
                photoDictionary in

                let thumbNailURL = photoDictionary["tbUrl"] as! String
                let googleImage = GoogleImage()
                let imageData = NSData(contentsOfURL: NSURL(string: thumbNailURL)!)
                googleImage.thumbnail = UIImage(data: imageData!)

                return googleImage
            }

            dispatch_async(dispatch_get_main_queue(), {
                completion(results:googlePhotos, error: nil)
            })
        }).resume()
    }
}
