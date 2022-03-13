# Slide Puzzle: Escape of Cao Cao

This is a puzzle game made on live-stream, demonstrating various animation techniques in Flutter
with just Dart code - no dependencies or asset files. It can target mobile, desktop, and the web
from a single code base.

The goal of the game is to move "the biggest puzzle piece (Cao Cao)" to "the exit" at the bottom, in
as few steps as possible.

[A playable web version is available](https://d1qjxjz3vso8bm.cloudfront.net/). For the best
experience, you can also try out native desktop or mobile apps.

## Version History

### v1.2.0 (2020-03-12)

- Added a hint button.
- Minor changes to the reset button.

The new hint feature spawns an `isolate` to find an optimal solution for the current state using
Breadth-First Search. Once the result comes back, an `OverlayEntry` is created precisely on top of
the hinted piece, with the help of a `CompositedTransformFollower` widget and `LayerLink`s embedded
in the pieces.

<center>
    <img alt="the new hint button in action" height="200"
    src="https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/hint.gif" />
</center>

### v1.1.0 (2020-03-06)

- Added more levels.
- Added a new 3D animation during level transitions.
- Added an option to hide decorative texts on puzzle pieces.
- Various minor UI enhancements and performance improvements.

This is my first time trying to simulate 3D objects without 3rd party tools or plugins in Flutter.
It's made using `Transform` widgets to translate and rotate 6 rectangles to correct places to form a
cuboid.

<center>
    <img alt="a 3d cube made with transform widget" height="200"
    src="https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/cube-3d.gif" />
</center>

Further optimizations were made so only up to 3 faces (visible to the viewers) are rendered at a
time, and a glare effect was added by changing `stops` on a `LinearGradient`. This formed the basis
for a new transition animation when a level is completed.

<center>
    <img alt="a 3d puzzle piece with glare effect" height="200"
    src="https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/cao-3d.gif" />
</center>

I've published a **video tutorial** on this topic, watch it
in [English](https://www.youtube.com/watch?v=hDmWOsOU_Ko)
| [Chinese](https://www.bilibili.com/video/BV1Qb4y1W7dS).

### v1.0.1 (2020-02-26)

- Added a simple tutorial screen.
- Fixed a bug where the web version was not rendering correctly on mobile browsers.

The tutorial screen is a responsive dialog made with `LayoutBuilder` and `ConstrainedBox`, and
decorated by `CupertinoPopupSurface`. It also includes a `WillPopScope` to allow Android users to
dismiss it with the back button.

<center>
    <img alt="new tutorial dialog with an option to hide decorative texts" width="200"
    src="https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/tutorial-hide.gif" />
</center>

It provides an option to hide decorative texts in case they don't render properly, e.g. when there
are no international fonts installed.

When building for web, make sure to use `canvaskit` renderer for better experience across devices.
You can do so with `flutter build web --web-renderer canvaskit` command. Otherwise, the puzzle might
not render correctly on mobile browsers. I've
created [an issue](https://github.com/flutter/flutter/issues/99045) for this and looks like the
Flutter team is [already on it](https://github.com/flutter/engine/pull/31887).

### v1.0.0 (2020-02-22)

- Initial release for all platforms.

The initial version of the app was created as "live coding" stream sessions. With discussions and
voting polls on design choices such as the color palette, together we built the game in 12
live-stream sessions.

<center>
    <img alt="the project was created on live stream" width="200"
    src="https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/live-stream.gif" />
</center>

The support for more platforms were added after the live stream ended.

<center>
    <img alt="multi-platform: a photo of the app running on multiple devices" width="200"
    src="https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/multi-platform.jpg" />
</center>

The video overview (see below) was released at the same time as this initial version, so new
features and changes are not included in the video.

## Video Overview

A short video (less than 3 min) is available, providing a brief overview of version 1.0.0.

[![video](https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/video-cover.jpg)](
https://www.youtube.com/watch?v=VFiejrt7uTk)

You can choose to watch the video in [English](https://www.youtube.com/watch?v=VFiejrt7uTk)
| [Chinese](https://www.bilibili.com/video/BV1y44y1n73G).

At a high level, the app can be divided into 3 parts: the background layer, the game board, and the
puzzle pieces. Each puzzle piece also comes with a pair of interlocking attachments and a shadow for
some added depth. These components are stacked as 3 different layers, to make sure they always
appear in the correct order when being moved.

<center>
    <img alt="each puzzle piece is layered 3 times" width="200"
    src="https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/video-layering.png" />
</center>

The color palette is configured as an `InheritedWidget` so its values can be modified in one place,
and easily accessed elsewhere in the widget tree.

The puzzle pieces are made from `AnimatedPositioned`. For the duration, I pass in zero if the window
size is different from before. This is to skip the unwanted animation when the app is being resized.
And for the curve, I use `EaseOut` to slow them down naturally.

To handle user input, I added `GestureDetector`. I used the `onPanUpdate` event instead of
the `onPanEnd` event, to reduce input lag.

<center>
    <img alt="use onPanUpdate for a faster response" width="200"
    src="https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/video-gesture.png" />
</center>

From the picture above you can see that the user has not finished the action (finger is still
touching the screen), but with `onPanUpdate` event, the game has already responded.

For the reset button, I added a `MouseRegion` widget to make it glow when being hovered.

<center>
    <img alt="use MouseRegion to make the reset button glow" width="200"
    src="https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/video-mouse.gif" />
</center>

The step counter on the side is another example of utilizing implicit animations in Flutter. It’s
also wrapped in a `ValueListenableBuilder`, so it can always keep up with the steps.

<center>
    <img alt="an animated flip counter used to track steps" width="100"
    src="https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/video-counter.gif" />
</center>

I’ve [published the counter as a package](https://pub.dev/packages/animated_flip_counter) on `pub`
and made a [video](https://www.bilibili.com/video/BV163411q7Yw) explaining how it was made. If you
like this animation, you can import it to your own project.

The game board is mostly a `Container` with some decorations and clipping. I also used
a `BackdropFilter` here to blur everything behind it, and a `ShaderMask` to create a beam effect.

<center>
    <img alt="BackdropFilter and ShaderMask" width="200"
    src="https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/video-blur.png" />
</center>

The beam created by `ShaderMask` is an explicit animation with its controller set to repeat, so it
can keep dancing around in the game.

<center>
    <img alt="glare effect on texts" width="200"
    src="https://flutter-challenge.s3.us-west-2.amazonaws.com/hosting/video-shiny.gif" />
</center>

Similarly, the decorative texts puzzle pieces are also animated to have a subtle glare effect.

Lastly, I used a `CustomPaint` for the app background. It efficiently draws colorful rectangles
every frame and runs well even on low-end devices.

## What's Next

- [x] Resolve web rendering issue for mobile browsers
- [x] Add a tutorial screen to explain the game
- [x] Add more levels to the game
- [x] Add an automatic solver or a hint system
- [ ] Allow users to select levels
- [ ] Design an app icon
- [ ] Add keyboard support
- [ ] Further improve swiping gestures

# Extra Resources

I've been making lots of video tutorials (mostly in Chinese) on Flutter, covering a wide range of
topics and popular questions from viewers. If you are interested, please follow me on "bilibili" so
you won't miss the next live stream or video from me.

### Animations

I've made a total of 19 video tutorials on Flutter Animations, divided into 3 sections: implicit,
explicit and others.

- [How to choose the right animations for your needs](https://www.bilibili.com/video/BV1dt4y117J9)

#### Implicit Animations

- [Get moving with just 2 lines of code](https://www.bilibili.com/video/BV1JZ4y1p7NG)
- [Smooth transitioning between different widgets](https://www.bilibili.com/video/BV1Wk4y167V4)
- [Curves, and more animation widgets](https://www.bilibili.com/video/BV1oC4y1H73Q)
- [DIY with a TweenAnimationBuilder](https://www.bilibili.com/video/BV1Q54y1X72E)
- [Case study: make a flip counter](https://www.bilibili.com/video/BV1Ng4y1B754)
- [Case study: flip counter continued](https://www.bilibili.com/video/BV1EV411C7Zq)

#### Explicit Animations

- [A repeating animation](https://www.bilibili.com/video/BV1Ri4y147ny)
- [What is an AnimationController](https://www.bilibili.com/video/BV1iV411C7oN)
- [Curves and Tween](https://www.bilibili.com/video/BV1LT4y1g7MD)
- [Staggered animations with intervals](https://www.bilibili.com/video/BV1sV411C7fs)
- [DIY with an AnimatedBuilder](https://www.bilibili.com/video/BV15p4y1X7Xp)
- [Case study: coordinating multiple animations](https://www.bilibili.com/video/BV1KQ4y1P7Xf)
- [Case study: multiple animation controllers](https://www.bilibili.com/video/BV1zV411C73b)

#### Other types of Animations

- [Under the hood: animations and tickers](https://www.bilibili.com/video/BV1dz411v76Z)
- [Hero animations](https://www.bilibili.com/video/BV1cC4y1a7u6)
- [CustomPaint: do you wanna build a snowman](https://www.bilibili.com/video/BV135411W7wE)
- [Animate with Rive/Flare](https://www.bilibili.com/video/BV1YK4y1x73S)
- [Bonus: create an asset with Rive tool](https://www.bilibili.com/video/BV1fv411z74W)

### Keys

I've made 7 video tutorials on keys, covering basic concepts such as widgets and elements, 3 types
of local keys, 2 different uses of global keys, and more.

- [Spooky stuff when you forget to use keys](https://www.bilibili.com/video/BV1b54y1z7iD)
- [Widgets, Elements and their States](https://www.bilibili.com/video/BV15k4y1B74z)
- [Three types of LocalKeys](https://www.bilibili.com/video/BV1Jz4y1D7Jp)
- [Two purposes of GlobalKeys](https://www.bilibili.com/video/BV1Hf4y1R7Pf)
- [Case study: make a color sorting game](https://www.bilibili.com/video/BV1uA411v7tk)
- [Case study: use LocalKey in the game](https://www.bilibili.com/video/BV1ia4y1a7Wx)
- [Case study: use GlobalKey in the game](https://www.bilibili.com/video/BV1QD4y1m73g)

### Scrollable

- [ListView and lazy loading](https://www.bilibili.com/video/BV1jT4y1A7cN)
- [Deep dive into the ListView widget](https://www.bilibili.com/video/BV1G54y1y75K)
- [RefreshIndicator and NotificationListener](https://www.bilibili.com/video/BV1Xh411R7UA)
- [Swipe away with the Dismissible widget](https://www.bilibili.com/video/BV1UK4y1a7bg)
- [Case study: a GitHub repo browser](https://www.bilibili.com/video/BV1JA411J7xp)
- [GridView widget](https://www.bilibili.com/video/BV1qK4y187MZ)
- [Even more scrollable widgets](https://www.bilibili.com/video/BV1Wk4y1C76n)

### Asynchronous

- [Event loop, queues, and microtasks](https://www.bilibili.com/video/BV12K4y1Z7Zg)
- [Deep dive into the Future type](https://www.bilibili.com/video/BV18K4y1Z7X3)
- [FutureBuilder widget](https://www.bilibili.com/video/BV165411V7PS)
- [Stream and StreamBuilder widget](https://www.bilibili.com/video/BV1Di4y1V78M)
- [Case study: generate stream from user actions](https://www.bilibili.com/video/BV1t5411G7x1)
- [Case study: listen to our event stream](https://www.bilibili.com/video/BV1nK4y1L7j9)
- [Case study: a good use for StreamTransformer](https://www.bilibili.com/video/BV1gK411G7BH)

### Layout

- [Constraints, size, and positions](https://www.bilibili.com/video/BV1254y1s7Zo)
- [LayoutBuilder and ConstraintBox](https://www.bilibili.com/video/BV1TA411p7ST)
- [Flex: Flexible and non-flexible](https://www.bilibili.com/video/BV1kr4y1K7qW)
- [Stack: Positioned and non-positioned](https://www.bilibili.com/video/BV1Gv4y1Z7fD)
- [What is a Container, really](https://www.bilibili.com/video/BV1jK4y1H71r)
- [CustomMultiChildLayout widget](https://www.bilibili.com/video/BV1ZN411X7nD)
- [Let's make a RenderObject](https://www.bilibili.com/video/BV14y4y177Uv)

### Slivers

- [Welcome to the world of Slivers](https://www.bilibili.com/video/BV1RK4y1R74t)
- [All sorts of sliver lists](https://www.bilibili.com/video/BV1xy4y1W7S6)
- [SliverAppBar widget](https://www.bilibili.com/video/BV1V64y1y75V)
- [More sliver widgets and SliverLayoutBuilder](https://www.bilibili.com/video/BV1Vh411a79Q)
- [Case study: convert a ListView into a sliver](https://www.bilibili.com/video/BV1Mw411o7HF)
- [Case study: SliverPersistentHeader](https://www.bilibili.com/video/BV1154y1H7vL)
- [Case study: Design a page with a SliverAppBar](https://www.bilibili.com/video/BV1xP4y1x78X)

### Coding challenge and follow-ups

(Sometimes I post questions for my viewers and then do follow-up videos to discuss all the creative
solutions I receive, so we can learn from each other.)

- [Pinch-to-zoom gallery with smooth transitions](https://www.bilibili.com/video/BV1cq4y1H7HX)
- [A button that counts down with its border](https://www.bilibili.com/video/BV15b4y1Z7EU)
- [Adaptive watermark overlay with FittedBox](https://www.bilibili.com/video/BV1bU4y1h7yd)
- [Different ways to implement Hollowed Text](https://www.bilibili.com/video/BV1Sb4y1Q7U4)
- [Ink, InkWell, and Material](https://www.bilibili.com/video/BV1RV411v7bX)
- [Creative ways to achieve diagonal layout](https://www.bilibili.com/video/BV13p4y1H7ni)
- [Adaptive banner made with Pythagorean Theorem](https://www.bilibili.com/video/BV1mr4y1K7om)
- [The new and the old material buttons](https://www.bilibili.com/video/BV1vh411y7uH)
- [Different ways to implement the same animation](https://www.bilibili.com/video/BV1Ko4y1o7JB)
- [Different ways to detect screen rotation](https://www.bilibili.com/video/BV1So4y1d7dM)

### Other popular topics

- [What is BuildContext?!](https://www.bilibili.com/video/BV1by4y1t7oG)
- [Flutter Web: common problems and solutions](https://www.bilibili.com/video/BV1DS4y1D7Tw)
- [What is SOUND null safety?](https://www.bilibili.com/video/BV1CL4y1z7p5)
- [Some super useful widgets in Flutter](https://www.bilibili.com/video/BV1dP4y1s7N5)
- [Some less known widgets in Flutter](https://www.bilibili.com/video/BV1Mq4y1U75Y)
- [Flutter 2.0 is here!](https://www.bilibili.com/video/BV1nN411Q7As)
- [WillPopScope and iOS swiping gesture](https://www.bilibili.com/video/BV1dB4y1M72A)
- [Weird tricks about Flutter Hot Reload](https://www.bilibili.com/video/BV1eK4y1m7VX)
- [Hotkeys in Android Studio](https://www.bilibili.com/video/BV1R64y1D79a)
- [Publish a package: animated flip counter](https://www.bilibili.com/video/BV163411q7Yw)
- [Publish a package: interactive chart](https://www.bilibili.com/video/BV1xU4y1F71A)
