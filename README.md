# Find Shelter

Find Shelter is an application that keeps track on the nearest air-raid shelters (skyddsrum). The data is provided by Myndigheten för Samhällsskydd och Beredskap (Swedish Civil Contingencies Agency) through their ArcGIS-API. This means of course that the application only shows public shelters in Sweden. There are about 65 000 public air-raid shelters in Sweden, with a total capacity of approximately seven million people. The application provides the user with a map where the shelters are marked, and when the user touches one of these annotations, it displays information about the chosen shelter, such as address, capacity and distance from the user. The application keeps track of the user and marks which shelter currently is the closest.

## Installation

The easiest way to install the application is by using the terminal (_bash_). This guide assumes that you have already installed [CocoaPods](https://cocoapods.org/) to manage your frameworks. If you have not, open your terminal and run

```bash
$ sudo gem install cocoapods
```

1. Start by cloning the repository to your computer

```bash
$ git clone https://github.com/jtaxen/FindShelter.git
```

2. Go to the repository directory and run

```bash
$ pod install
```

This will install the frameworks needed to run the app.

3. Now start Xcode and open ```FindShelter.xcworkspace```. The application should be ready to be built and runned

## Testing outside of Sweden

Moving the map view to any place in Sweden should make the application load shelters. There will of course be more shelters visible in the biggest cities: Stockholm, Gothenburg and Malmö.

For testing how the app behaves while moving, two scripts have been added: TestMalmo.gpx and TestStockholm.gpx. When activated, these scripts simulates the position of the user, moving between different waypoints in Malmö and Stockholm respectively.

To test the app with these scripts:

1. Open the scheme preferences (from the menu bar: Product->Scheme->Edit Scheme, or by shortcut: ⌘<)
2. In the menu to the left, choose "Run", and go to "Options".
3. Select "Allow Location Simulation", and select either "TestStockholm" or "TestMalmo" as the default location.

This should work both in the simulator and on a phone, as long as the phone is connected to a computer with a cord.

## Features

The main view comprises a map on which the position of the local air-raid shelters are marked out. The closest one is marked with a circle, and a label on top of the map tells the user how far away it is (this data is not displayed if the distance is greater than 5 km) . By default, the map centers on the location of the user, but he or she can drag around the map and always return the view to his or her position by pressing a back-button. New shelter positions are downloaded, either when the user has moved a certain distance from the location of the last update, or if the user location is not visible, when the map finnishes loading.

When touching a shelter notation, a table with information about the chosen shelter is presented. This table includes the name of the shelter (often the name of the city block and a number), the address, in which city and municipality it is located, for whom the shelter is intended (e.g. civilians, military etc.), for how many people the shelter is built and how far away the shelter is. This view also includes a save button. When pressing this, the location is stored on the device together with all its information, and it marks the location on the map with a star.

When at the map view, the navigation bar contains a button which takes the user to the "favorite list", which displays all the saved shelters. Here the user can choose to inspect the information by touching one of the rows. When displaying information about a saved location, the save button in the table is replaced by a button which takes the user back to the map view and centers the chosen shelter.

## Language support

The application is so far translated to Swedish and English.
