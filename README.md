
![preview](https://github.com/omegaui/desktop_split_pane/assets/73544069/0f19a69c-5ccd-4d06-b013-196f3a7bcf3f)

# desktop_split_pane

A hot reload supported Split Pane widget for flutter desktop and web.

## Features

- Supports Hot Reload (which wasn't supported by good old [resizable_widget](https://pub.dev/packages/resizable_widget))
- Animated Resizing
- Auto resize on app window resize
- Customize Separator Thickness and Color
- States are public to support explicit widget rebuilds (just call `rebuild()` on state)
- You can now remove and add widgets during runtime without needing a hot restart.
- This property is very useful for showing side panes and hiding them later.
- `onResize(widths/heights)` function added to listen to resize events.

## Getting started

```shell
flutter pub add desktop_split_pane
```

## Usage

```dart
import 'package:desktop_split_pane/desktop_split_pane.dart';
import 'package:flutter/material.dart';

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
          builder: (context, constraints) => HorizontalSplitPane(
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
