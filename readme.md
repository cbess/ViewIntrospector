View Introspector
============
![app icon](https://github.com/cbess/ViewIntrospector/raw/master/CBIntrospector/appicon.png)

[Download View Introspector](http://goo.gl/eWtrr)

[CBIntrospector iOS lib](https://github.com/cbess/CBIntrospector/)

View Introspector is a desktop app for the iOS Simulator that aid in debugging user interfaces built with UIKit. It's especially useful for UI layouts that are dynamically created or can change during runtime.

![Main Window Screenshot](https://github.com/cbess/ViewIntrospector/raw/master/main-window-screenshot.jpg)

![View Introspector Screenshot](https://github.com/cbess/ViewIntrospector/raw/master/cbintrospector-screenshot.jpg)

[CBIntrospector iOS lib](https://github.com/cbess/CBIntrospector/)

[Download View Introspector](http://goo.gl/eWtrr)

It uses keyboard shortcuts to handle starting, ending and other commands.  It can also be invoked via an app-wide `UIGestureRecognizer` if it is to be used on the device.

Features:
--------------
* Simple to setup and use
* See the entire hierarchy (view tree) of the window
* Send messages (call any method) to the selected view during runtime
* Displays a views origin & size, including distances to edges of main window
* Displays properties of a view, including subclass properties, actions and targets (see below for an example)
* Displays accessibility properties — useful for UI automation scripts
* Move and resize view frames during runtime
* Highlighting of view frames

[CBIntrospector Demo App](https://github.com/cbess/CBIntrospector/)

View Introspector Usage
--------------------

* Download desktop app - [View Introspector](http://goo.gl/eWtrr)
* Start your app
* Start `View Introspector` desktop app
* Install [CBIntrospector](https://github.com/cbess/CBIntrospector/) iOS lib
* Start debugging target iOS project
* In the iOS simulator, press `space` key to activate the introspect tool
* Back in the View Introspector, click `Reload` to load the projects
* Select the project to open from `View Introspector` project window (Menu->Window->Show Projects)
* Interact with `View Introspector` UIView tree to select or adjust the UIView in the iOS Simulator
* (More documentation coming soon)

Before you start, make sure the `DEBUG` environment variable is set. CBIntrospect will not run without that set to prevent it being left in for production use.

Provide custom name of view:

    - (void)viewDidLoad
    {
        [super viewDidLoad];

        // provide custom names for use by the View Introspector desktop app and console output
    	[[CBIntrospect sharedIntrospector] setName:@"myActivityIndicator" forObject:self.activityIndicator accessedWithSelf:YES];
        [[CBIntrospect sharedIntrospector] setNameForViewController:self];
    }
    
License
-----------

Made available under the LGPL License.
