Countries
========

This repository contains a sample app for requesting RESTCountries API.


---
# Installation

To install the dependencies
* Open a terminal and cd to the directory containing the Podfile
* Run the `pod install` command

(For further details regarding cocoapod installation see https://cocoapods.org/)


---
# Existing Functionalities

The app is currently able to load Countries from RESTCountries API, and show it in list form or detailed.

* When the app loads, it will load the Countries from RESTCountries API, and show them in the tableView
* You can also filter the countries, by filling the "Search Country" field. The filter logics are a simple keyword finding inside Country's Name and Subregion. 
* Upon selecting a Country, it will open a view with detailed data of the selected Country

---
# Development Steps

1. Create new project based on single view app
2. Create folders for MVVM pattern
3. Add CountriesViewController and Design the UI layout to show Countries List
4. Add Networking Layer to handle the RESTCountries API
5. Add Models and ViewModel, that will show the Countries List at CountriesViewController
6. Add pods: Kingfisher
7. Add CountryDetailViewController and Design the UI layout to show the selected country's detail
8. Add CountryDetailViewModel to prepare the Country's detailed data
9. Add Search Country feature in CountriesViewController
10. Add Unit Tests to test the process


