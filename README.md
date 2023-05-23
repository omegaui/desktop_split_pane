![Screenshot from 2023-05-23 14-22-50](https://github.com/omegaui/desktop_split_pane/assets/73544069/f64eba88-8eee-4291-804a-d19af90bcd71)

# desktop_split_pane

A hot reload supported Split Pane widget for flutter desktop and web.

## Features

- Supports Hot Reload (which wasn't supported by good old [resizable_widget](https://pub.dev/packages/resizable_widget))
- Animated Resizing
- Auto resize on app window resize
- Customize Separator Thickness and Color
- States are public to support explicit widget rebuilds (just call `rebuild()` on state)

## Getting started

```shell
flutter pub add desktop_split_pane
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:spilt_pane/horizontal_split_pane.dart';
import 'package:spilt_pane/vertical_split_pane.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) =>
              HorizontalSplitPane(
                constraints: constraints,
                separatorColor: Colors.black,
                separatorThickness: 4.0,
                fractions: [0.2, 0.2, 0.2, 0.4],
                children: [
                  Container(
                    color: Colors.blue,
                  ),
                  Container(
                    color: Colors.pinkAccent,
                  ),
                  Container(
                    color: Colors.purpleAccent,
                  ),
                  VerticalSplitPane(
                    constraints: constraints,
                    separatorColor: Colors.white,
                    separatorThickness: 4.0,
                    children: [
                      Container(
                        color: Colors.grey,
                      ),
                      Container(
                        color: Colors.greenAccent,
                      ),
                      Container(
                        color: Colors.teal,
                      ),
                    ],
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

```
