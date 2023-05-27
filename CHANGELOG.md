## 1.0.0

- Supports Hot Reload (which wasn't supported by good old [resizable_widget](https://pub.dev/packages/resizable_widget))
- Animated Resizing
- Auto resize on app window resize
- Customize Separator Thickness and Color
- States are public to support explicit widget rebuilds (just call `rebuild()` on state)

## 1.0.1

- Now, Supports hot reload completely.
- You can now remove and add widgets during runtime without needing a hot restart.
- This property is very useful for showing side panes and hiding them later.
- `onResize(widths/heights)` function added to listen to resize events.

## 1.0.2

- Optimized Performance
- Removed Container Animations

## 1.0.3

- Now, Supports Offstage widgets
- This helps in getting the accessing the current State of the Widget without even rendering it
- Useful for IDEs to show their tab panes when they have elements or else hide them as needed.
