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
The app wil lbe based of the MVC design pattern. There will be a data model for handling search queries and a view controller for handling the UI. Note that in Apple's UIKit that the view and controller are somewhat more coupled than the design pattern.


### Data Model
A simple model that can be queried for apps in Apple's App Store. The data model will require storage for screenshots and logos

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
- URLSession setup, will use the `shared` for first pass
- Define service return values
- query builder method ✅
- handle lost connection
- handle timeout





