# RFFeatureToggle

[![CI Status](http://img.shields.io/travis/raumfeld/RFFeatureToggle.svg?style=flat)](https://travis-ci.org/raumfeld/RFFeatureToggle)
[![Version](https://img.shields.io/cocoapods/v/RFFeatureToggle.svg?style=flat)](http://cocoapods.org/pods/RFFeatureToggle)
[![License](https://img.shields.io/cocoapods/l/RFFeatureToggle.svg?style=flat)](http://cocoapods.org/pods/RFFeatureToggle)
[![Platform](https://img.shields.io/cocoapods/p/RFFeatureToggle.svg?style=flat)](http://cocoapods.org/pods/RFFeatureToggle)

## About

A simple A/B testing framework for remotely switching features on and off and having the changes reflect in the app immediately.

## Usage

### Setup

Initialize the defaults with **params**, a dictionary containing base URLs for staging and production.

```
NSDictionary *params = @{kRFFeatureToggleBaseURLStringForStagingKey : @"https://staging/",
						 kRFFeatureToggleBaseURLStringForProductionKey : @"https://production/"};
                             
[RFFeatureToggleDefaults sharedDefaultsWithMode:RFFeatureToggleModeProduction params:params];
```

For an easy start there are 3 convenience methods:

### Check if a feature is enabled

```
[RFeatureToggle isEnabled:@"feature"];
```

If the API supports features within features within features, these can be separated with dots like

```
[RFeatureToggle isEnabled:@"feature.subfeature.subsubfeature"];
```

### Refresh all features and cache them

```
[RFeatureToggle refresh];
```

This can be called on `applicationDidBecomeActive:` or whenever convenient. After the initial call the features are automatically refreshed after 24 hours if app has been continuously running in foreground. A custom time interval can be set as default, for example `[RFFeatureToggleDefaults sharedDefaults].refreshTimeInterval = 120.0f;`.

### Fetch all features from the cache

```
NSArray *features = [RFeatureToggle allFeatures];
```

## Extras

### Observing updates

Subscribe to `RFFeatureToggleUpdatedNotification` to receive updates. The notification is triggered only when there has been a change in features.

### Changing base URL

Base URL can be changed dynamically. By assigning different URL, `[RFFeatureToggleDefaults sharedDefaults].mode` will return the mode it's operating in (production, staging, custom).

### Fine tuning
For fine tuning check properties in `RFFeatureToggleDefaults`, which are further explained in the documentation:

* **certificateName**
* **requestHeadersDictionary**
* **refreshTimeInterval**

### Inspection
To inspect the features, there are convenience methods in `RFFeature` class:

* **description**, example output:

```
feature2: disabled
```

* **recursiveDescription**, example output:

```
feature2: disabled	
	|_feature3: disabled		
		|_feature5: disabled
		|_feature6: enabled
	|_feature4: enabled
```

### RFFeatureTableViewController

`RFFeatureTableViewController` lists all features that can be navigated through. It has a refresh control so features can be refreshed to ensure the latest changes are present. This is to be used for QA purposes.

![image](Docs/RFFeatureTableViewController.gif)

This is demonstrated in the example project. To run the example project, run `pod install` from the Example directory first.

### Digging deeper

Aside convenience methods provided in `RFFeatureToggle` class, there are model-controller extensions of `RFFeature` based on [Data Mapper](http://martinfowler.com/eaaCatalog/dataMapper.html) design pattern, as well as `RFFeatureCache` class that handles persistence and auto update. Examples:

#### To handle error when fetching all features

```
[RFFeature fetchFeaturesUsingBlock:^(BOOL succeeded, NSError *error) {
	if (!succeeded)
	{
		//handle error
	}
}];
```

#### To inspect the date of last successful update

```
NSTimeInterval secondsSinceLastSuccessfulUpdate = [RFFeatureCache timeIntervalSinceLastSuccessfulUpdate];
if	(secondsSinceLastSuccessfulUpdate > 120.0f)
{
	//do something
}
```

## Requirements

* A server that returns a list of features in the specified format. See [Fixtures](Example/Tests/Fixtures) for an example of the response.
* iOS7+

## Installation

RFFeatureToggle is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod "RFFeatureToggle"
```

## License

RFFeatureToggle is available under the MIT license. See the LICENSE file for more info.
