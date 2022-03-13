### AppStoreSearch App
A demo app for a interview with IBM



### Requirements
Use the iTunes Search API to create an App Store App

iTunes Search API can be used to query data on iTunes Store which includes music, podcasts and apps. 

iTunes Search API can be used to query data on iTunes Store which includes music, podcasts and apps. Since it’s a search API, at a minimum a search term needs to be passed as a parameter for this API to return results.
For example this query will return all the apps (software) that match search query “IBM”: https://itunes.apple.com/search?term=ibm&entity=software&limit=200
Please refer to the following url for more details on this API: https://developer.apple.com/library/archive/documentation/AudioVideo/ Conceptual/ iTuneSearchAPI/index.html

### API Docs
https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html#//apple_ref/doc/uid/TP40017632-CH5-SW1


The iOS App
Write a native iOS app in Swift or Objective-C which has the following features:
1. User should be able to enter the search term to look for apps (software)
2. A list of apps that match the search term should be shown in a list
3. If the user taps on each search result a new view should appear to show
each app’s details, including app name, app icon, description, all screen shots, price, size, version, etc. These need to be constructed via native iOS components and not just by passing the App Store URL to view in a web view.
4. Add filtering capabilities to the search results so that one can filter the results with at least the category (genre) and whether the app is free or paid.
5. Push your project to your GitHub repository and also send us a compressed version of the project along with the link to the GitHub repo.
6. Please be prepared to explain and go over the details of the code in our next meeting

**Constraints:** Only use Apple frameworks and do not use any 3rd party frameworks.




### Design
The app wil lbe based of the MVC design pattern. There will be a data model for handling search queries and a view controller for handling the UI. Note that in Apple's UIKit that the view and controller are somewhat more coupled than the design pattern suggests.

#### Search functionality
Since the requirements are search are quite open the decision was made to back the search with core data entities. There are many reasons to do this. Performance, error handling and recovery AND future search feature work has a solid foundation.

**improvement:** Cache search results and reuse while fetching new results



### Error Handling
Application error codes are defined in `ApplicationErrorCodes`. Each `service` defines it's own error with a code that maps to an application error code as well as providing the `type` of service error. For example the `AppStoreService` errored because it failed to correctly encode the url.

### Data Model
A simple model that can be queried for apps in Apple's App Store. The data model will require storage support for screenshots and logos

I will start with the model and write unit tests and use TDD.


**Tasks**
- Model definition, basic setup ✅
- Define data structure ✅ (will iterate)
- write unit tests for search query string 
- wire up Model to UI ✅
 


### AppStore Service
This a network service(http) that will make the actual http GET request. The data model will provide a url encoded item tso that this service can build the http GET request and process the response. There is the requirement to display ALL screenshots! Suggest it is broken down into a device list first so that we don't overload UI fetching images. It is also possibble to do thumbnails first.

**Contraints:**
- reachablity
- lost connection
- time out
- multiple Asset requests


**Tasks**
- AppStore Service definition ✅
- URLSession setup, will use the `shared` for first pass ✅
- Define service return values
- query builder method ✅
- handle lost connection
- handle timeout


### FileSystem Service
This service handles file system requests. In our case the will a background service that will help with saving json responses to file and saving screenshots once they have been downloaded. 

**Contraints:**
- save json response to  directory for app entity
- can derive path to an app entity's resources - no guessing!
- is ran in the background 
- is performant 

**Tasks**
- Define service ✅
- method to save json for each app entity ✅
- directory structure for media assets ✅
- confirm image\screenshots loading performance


### MediaAssets Service
This service handles fetching remote images so that they can be stored locally. Assets are stored in the documents directory with the following path:

```<documents-directory>/<AppEntity:UUID>/Resourses/<media-name>.<extension>```

There are no persistence requires for the app but it would be good to reuse where possible.

**Contraints:**
- background service
- required to notify `UI` of updates
- is performant
- uses `FileSystem` service to store images locally
- path can be derived 
- async behavior 

**Tasks**
- Define service 
- fetch image from url 
- store image using app entity id


### User Interface
Design here is a simple list/detail view setup. First will be the search view so that I can confirm `DataModel` and services are working with the `ui`

List view will be a UITableView. The detail view will be a simple card view with required elements.

#### Component Views
- `Home`, root of the navigation stack and search
- `Detail` , Detailed listing of an AppStore app 
- `filter`, options to apply to a search results
- `Sceenshots`, gallery for viewing app screenshots


**Tasks**
- this app's icon(s), simple first iteration ✅
- accessability identifiers (UI tests)
- fetch and load app icon image ✅
- Detail view: second pass ✅
- fetch and load app screen shot images ✅
- Confirm basic iPad support
- UI suppoprt for errors
- Progress indicator for endpoint calls
- support Dark mode
- add search view ✅
- wire up search view to data model. ✅
- confirm data entry and log results to console ✅
- Subclass `UITableViewCell` for appEntity ✅
- Add navigation controller ✅
- add `UITableView` to viewcontroller ✅
- setup table view  delegates and datasource ✅
- implement `update` method for tableview ✅
- handle networking errors 
- localization
- create error handling view for messaging user
- build out and map errors and error codes
- filter build out `FilterOptionsViewController` for filtering `ui`
- filter on app price
- filter on genre
- filter on app price and genre
- filter: add ability to set number of search results per query (helps with debugging) ✅
- confirm `ui` on supported operating systems and devices


### Bugs

- format app file size
- ipad: dark mode cells
- coredata handle record deletion
- first responder on selecting a cell while search text is empty ✅


## TODO
The next iteration would be focused on application hardening and error handling. Part of this work would include what I loodsely refer to as an application dialog view. It is a view that handles some of the generic issues with apps such as lost network connection, etc. 


