#  IBL App

    IBL App is simple mobile application that displays Imaginary Bank branches and ATMs information. Information should are displayed visually through maps and searchable in list view.
    
## Functionalities ##

The main purpose of the app is to get data from a local JSON file, display pins on the map or as a ListView and be able to see the current location on the map.
To get the data from the JSON file we will use the DataManager that return Decoded object with the getBankList function
To get the currentLocation coordinates we use the Location manager and it's function getCurrentLocation. The LocationManager will first check if the user has allowed the app to use it's location.

## UI ##

The app consists on a rootViewController that handles the UI changes from the Map to the ListView. The rootViewController will switch childViewControllers and display them according to the user interactions with the bottom buttons.

- Map
    The map will display Annotations that use the CustomAnnotation object that has coorditates, image but also a details propertie with data on it that will change the image base on the object type. The details will also be used later when we click on the description view of the Annotation.
    If the user clicks on "My Location" button it will display the UserAnnotation together with the custom image on it
    The user needs to click a specified Annotation on the map and it will display a description view with name and address and after clicking it, the screen will be redirected to the Details.
    -Details
        The details screen is build by a ViewController that has the name, address labels and a static UITableViewController that will display the other data. If the user clicks on the "Work Hours" row, a modal with be displayed with a list of opening hours.
- List
    The list displays the data from the JSON file into a UITableView and the user will be able to filter the data with a search keyword and click the items so the selcted item will be focused on the map.
    
The complete UI is build with Storyboards or Xib files using AutoLayout

## Build Procedures ##

Because the app is not using any 3rd party libraries, it's very easy to build. Just pull from the project with SourceTree or CommandLine and you're ready to go.

The app is build in Xcode 10.1
