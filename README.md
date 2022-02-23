# slide_puzzle

A remake of the classic sliding puzzle. The goal is to navigate Cao Cao (the biggest piece) to the
exit at the bottom, by carefully rearranging other pieces.

## Multi-platform

The project is written in Flutter and runs on desktop platforms including Windows, macOS, Linux, as
well as mobile platforms including Android and iOS. The game is also available as a web app, which
can be accessed from any desktop browsers.

## Live Demo

A [web version](https://d1qjxjz3vso8bm.cloudfront.net/) is available here.

Known issue: the web version has some rendering issues when viewed from mobile browsers (for
example, Chrome on Android). For best experience, please use a desktop browser, or install the
Android/iOS app.

## Project Overview

Please watch the project overview [video in English](https://www.youtube.com/watch?v=)
and [video in Chinese](https://www.bilibili.com/video/BV1y44y1n73G).

At a high level, the app can be divided into 3 parts: the background layer, the game board, and the
puzzle pieces. Each puzzle piece also comes with a pair of interlocking attachments and a shadow for
some added depth. They are then stacked as different layers, to make sure they always appear in the
correct order. The color palette is configured as an `InheritedWidget` so its values can be modified
in one place, and easily accessed elsewhere in the widget tree.

The puzzle pieces are made from `AnimatedPositioned`. In Flutter, implicit animation widgets like
these are super easy to use - just give them a duration and an optional curve, and they’ll
automatically animate when their values are changed. For the duration, I first check if the window
size is different from before, and if so, I pass in zero. This is to skip the unwanted animation
when the app is being resized. And for the curve, I use `EaseOut` to simulate physical objects being
slowed down by friction.

To handle user input, I added `GestureDetector`. I used the `onUpdate` event instead of the `onEnd`
event here. This reduces input lag, allowing the game to react before the gesture ends. For the
reset button, I also added a `MouseRegion` widget to make it glow when being hovered.

The step counter is another example of utilizing implicit animations in Flutter. It’s also wrapped
in a `ValueListenableBuilder`, so it can always keep up with the steps. I’ve published this widget
as a package on `pub` and made a video explaining how it was made. If you like this animation, you
can import it to your own project.

The game board is mostly a `Container`. I used a `BackdropFilter` to blur everything behind it, and
a `ShaderMask` to create a beam effect. Since we want the beam to keep dancing around, it’s easier
to use explicit animations with a controller. Also, the exit arrows at the bottom, and the
highlighting effect on texts, are all made with Flutter’s explicit animations.

Lastly, I used a `CustomPaint` for the background. A text-painting version was first implemented but
later scrapped because having to layout texts every frame caused some performance issues on the web.
The simplified version looks similar but performs much better, even on low-end devices.

## My Videos

I've published lots of Chinese video tutorials on Flutter, covering a wide range of topics and
popular questions from viewers. Here are a few of them.

### Animations

#### Intro to Animations in Flutter

- [How to choose the right animations for your needs](https://www.bilibili.com/video/BV1dt4y117J9)

### Implicit Animations

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
- [Bonus: create an asset with Rive tool](https://www.bilibili.com/video/BV1YK4y1x73S)

### Keys

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
- [Case study: event stream from user actions](https://www.bilibili.com/video/BV1t5411G7x1)
- [Case study: monitor event stream](https://www.bilibili.com/video/BV1nK4y1L7j9)
- [Case study: a good use for StreamTransformer](https://www.bilibili.com/video/BV1gK411G7BH)

### Layout

- [Constraints, size, and positions](https://www.bilibili.com/video/BV1254y1s7Zo)
- [LayoutBuilder and ConstraintBox](https://www.bilibili.com/video/BV1TA411p7ST)
- [Flex: Flexible and non-flexible](https://www.bilibili.com/video/BV1kr4y1K7qW)
- [Stack: Positioned and non-positioned](https://www.bilibili.com/video/BV1Gv4y1Z7fD)
- [What is a Container, really](https://www.bilibili.com/video/BV1jK4y1H71r)
- [CustomMultiChildLayout widget](https://www.bilibili.com/video/BV1ZN411X7nD)
- [Let's make a RenderObject](https://www.bilibili.com/video/BV14y4y177Uv)

### Sliver

- [Welcome to the world of Sliver](https://www.bilibili.com/video/BV1RK4y1R74t)
- [All sorts of sliver lists](https://www.bilibili.com/video/BV1xy4y1W7S6)
- [SliverAppBar widget](https://www.bilibili.com/video/BV1V64y1y75V)
- [More sliver widgets and SliverLayoutBuilder](https://www.bilibili.com/video/BV1Vh411a79Q)
- [Case study: convert a ListView into sliver](https://www.bilibili.com/video/BV1Mw411o7HF)
- [SliverPersistentHeader](https://www.bilibili.com/video/BV1154y1H7vL)
- [Design a page with a SliverAppBar](https://www.bilibili.com/video/BV1xP4y1x78X)

### Flutter Discussions

- [Different ways to detect screen rotation](https://www.bilibili.com/video/BV1So4y1d7dM)
- [Different ways to implement this animation](https://www.bilibili.com/video/BV1Ko4y1o7JB)
- [The new and the old material buttons](https://www.bilibili.com/video/BV1vh411y7uH)
- [Adaptive banner with Pythagorean Theorem](https://www.bilibili.com/video/BV1Ny4y127dz)
- [Creative ways to achieve diagonal layout](https://www.bilibili.com/video/BV1yh411C7xG)
- [Ink, InkWell, and Material](https://www.bilibili.com/video/BV1RV411v7bX)
- [Hollowed Text](https://www.bilibili.com/video/BV1Sb4y1Q7U4)
- [Adaptive watermark with FittedBox](https://www.bilibili.com/video/BV13h411D747)
- [A button that counts down with its border](https://www.bilibili.com/video/BV15b4y1Z7EU)
- [Pinch-to-zoom on a GridView, with animations!](https://www.bilibili.com/video/BV1cq4y1H7HX)

### Other Flutter topics

- [What is BuildContext?!](https://www.bilibili.com/video/BV1by4y1t7oG)
- [What is SOUND null safety](https://www.bilibili.com/video/BV1CL4y1z7p5)
- [Hotkeys in Android Studio](https://www.bilibili.com/video/BV1R64y1D79a)
- [Weird tricks about Flutter Hot Reload](https://www.bilibili.com/video/BV1eK4y1m7VX)
- [WillPopScope and iOS swiping gesture](https://www.bilibili.com/video/BV1dB4y1M72A)
- [Some super useful widgets in Flutter](https://www.bilibili.com/video/BV1dP4y1s7N5)
- [Some less known widgets in Flutter](https://www.bilibili.com/video/BV1Mq4y1U75Y)
- [Flutter 2.0 is here!](https://www.bilibili.com/video/BV1nN411Q7As)
- [Common problems and solutions on Flutter Web](https://www.bilibili.com/video/BV1DS4y1D7Tw)
- [Publish a package: animated flip counter](https://www.bilibili.com/video/BV163411q7Yw)
- [Publish a package: interactive chart](https://www.bilibili.com/video/BV1xU4y1F71A)
