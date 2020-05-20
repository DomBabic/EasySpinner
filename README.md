# EasySpinner

A simple UIView subclass which can be used in place of UIActivityIndicatorView. EasySpinner provides variety of styling options such as layer and spinner dot colors, dot size and max scaling value, animation duration, etc.

## Getting Started

For help on adding EasySpinner and using it within your App take a look at the instructions bellow.

### Prerequisites

Your project deployment target must be at or above iOS v10.0 and using Swift 5.

### Installing

You can add EasySpinner to your project in multiple different ways. If you are using CocoaPods as your dependancy manager simply add the following line to your podfile:

```
pod 'EasySpinner'             //Without explicitly declaring version
pod 'EasySpinner','1.0.0'     //With explicitly declared version
```

Alternatively, you can download whole repo and add EasySpinner as a Framework to your project or simply copy [CGRect+Center](./EasySpinner/CGRect+Center.swift) and [EasySpinner](./EasySpinner/EasySpinner.swift) files to your project.

### Using EasySpinner

EasySpinner provides an initializer with default values for properties used to set it up.

```
public init(frame: CGRect = .zero,
         angleStep: CGFloat = 15,
         layerColor: UIColor = .init(red: 3, green: 194, blue: 252, alpha: 1.0),
         dotColor: UIColor = .white,
         dotSize: CGFloat = 5,
         dotScale: CGFloat = 2)
```

The above properties define the following:
 - `frame` - Frame of EasySpinner (if you are using programmatic AutoLayout you can define width and height of spinner with constraints - EasySpinner is supposed to have symmetrical width and height, so keep that in mind),
 - `angleStep` - Angle between two points of EasySpinner circle layer,
 - `layerColor` - UIColor used to set circle `layer` `backgroundColor` property,
 - `dotColor` - UIColor used to set spinning dot's `layer` `backgroundColor` property,
 - `dotSize` - CGFloat value which determines the radius of spinning dots,
 - `dotScale` - CGFloat value which determines the maximum scale to which spinning dots can resize.
 
Primary purpose of EasySpinner is to indicate some sort of activity (e.g. network requests, loading of data, etc.). As such it contains methods which allow for it to be toggled on and off. By calling `startAnimation` method of EasySpinner the view is instructed to do the following:
- `layer` rotation is triggered,
- generated dot `layers` fade in with a calculated delay based on number of dots and animation duration,
- starts scaling dots from `dotSize` up to a maximum size scale of `dotScale`.
 
 Animation runs indefinitely until it is stopped by calling `stopAnimation`. Aforementioned method does the opposite of `startAnimation`:
 - generated dot `layers` begin fading out with the same delay used to fade them in,
 - once last dot fades out scaling and rotating animations are removed from their appropriate views.
 
 Alternative to calling individual methods is to call `toggleAnimation` method of EasySpinner which will either start or stop animating view depending on its current state.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
