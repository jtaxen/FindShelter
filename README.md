# Find shelter

Find shelter is an iOS application to help you feel safer. It shows you where the closest bomb shelter is, so that you always know where to go, if the worst is happening. Hopefully this app will never be needed, but it is better to have it without the need, than to be missing it.

The data is taken from Myndigheten för Samhällsskydd och Beredskaps (*Swedish Civil Contingencies Agency*) webpage.

## Installation

The project is dependent on three libraries: [*Alamofire*](https://github.com/Alamofire/Alamofire), [*SwiftyJSON*](https://github.com/SwiftyJSON/SwiftyJSON) and [*ObjectMapper*](https://github.com/Hearst-DD/ObjectMapper). These instructions show how to install them from the terminal using bash.

**1. Download CocaPods**

Start by downloading [CocoaPods](https://cocoapods.org/):

```bash
$ sudo gem install cocoapods
```

when done, enter

```bash
$ pod setup
```

to clone the CocoaPods Master Specs repository onto your computer.

**2. Include the libraries**

Create a new text file in the project repository and name it ``Podfile``. Specify which libraries you want to include by writing

```
platform :ios, '9.0'
use_frameworks!

target 'FindShelter' do
	pod 'Alamofire', '~> 4.4'
	pod 'SwiftyJSON'
	pod 'ObjectMapper', '~> 2.2'
end
```

Now, open FindShelter.xcworkspace (*not* FindShelter.xcproj) and use **⌘b** to build the project. Now it should be ready to use. 
