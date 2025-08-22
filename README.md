English | [简体中文](README_zh.md)

# Circular Floating Action Button Bottom Navigation Bar

A beautiful Flutter plugin that provides a customizable bottom navigation bar with a circular floating action button. When the FAB is pressed, it displays animated options with a blur background effect.

## Features

- ✨ Circular floating action button that protrudes above the navigation bar
- 🎭 Options slide in when the FAB is pressed
- 🌫️ Full-screen blur background effect
- 🎨 Fully customizable colors, sizes, and animations
- 📱 Responsive design that adapts to all screen sizes
- 🚀 Smooth animations with customizable duration and curves

## Animation Demo

![circular_fab_bottom_nav_demo.gif](circular_fab_bottom_nav_demo.gif)

## Usage

### Basic Usage

```dart
import 'package:circular_fab_bottom_nav/circular_fab_bottom_nav.dart';

Scaffold(
  bottomNavigationBar: CircularFabBottomNav(
    currentIndex: _currentIndex,
    onTap: (index) {
      setState(() {
        _currentIndex = index;
      });
    },
    items: [
      CircularBottomNavItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      CircularBottomNavItem(
        icon: Icon(Icons.search_outlined),
        activeIcon: Icon(Icons.search),
        label: 'Search',
      ),
    ],
    fabOptions: [
      FabOptionItem(
        icon: Icons.camera,
        iconColor: Colors.white,
        backgroundColor: Colors.blue,
        title: 'Camera',
        subtitle: 'Take a photo',
        onTap: () {
          // Handle camera option
        },
      ),
    ],
  ),
)
```

### Advanced Usage

```dart
CircularFabBottomNav(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: navItems,
  fabOptions: fabOptions,
  // Customization
  backgroundColor: Color(0xFF111113),
  fabBackgroundColor: Colors.white,
  fabIconColor: Colors.black,
  fabSize: 76.0,
  fabElevation: 20.0,
  selectedItemColor: Colors.white,
  unselectedItemColor: Colors.grey,
  iconSize: 26.0,
  height: 80.0,
)
```

## Configuration

### CircularFabBottomNav Properties

| Property              | Type                          | Default             | Description                           |
|-----------------------|-------------------------------|---------------------|---------------------------------------|
| `items`               | `List<CircularBottomNavItem>` | Required            | Navigation bar items                  |
| `currentIndex`        | `int`                         | Required            | Currently selected tab index          |
| `onTap`               | `ValueChanged<int>`           | Required            | Navigation item click callback        |
| `fabOptions`          | `List<FabOptionItem>`         | Required            | Options displayed when FAB is pressed |
| `backgroundColor`     | `Color`                       | `Color(0xFF111113)` | Navigation bar background color       |
| `fabBackgroundColor`  | `Color`                       | `Colors.white`      | FAB background color                  |
| `fabIconColor`        | `Color`                       | `Colors.black`      | FAB icon color                        |
| `fabSize`             | `double`                      | `76.0`              | FAB diameter                          |
| `fabElevation`        | `double`                      | `20.0`              | Height FAB protrudes above nav bar    |
| `selectedItemColor`   | `Color`                       | `Colors.white`      | Selected navigation item color        |
| `unselectedItemColor` | `Color`                       | `Colors.grey`       | Unselected navigation item color      |
| `iconSize`            | `double`                      | `26.0`              | Navigation item icon size             |
| `height`              | `double`                      | `80.0`              | Navigation bar height                 |

### CircularBottomNavItem Properties

| Property     | Type      | Default  | Description               |
|--------------|-----------|----------|---------------------------|
| `icon`       | `Widget`  | Required | Icon when not selected    |
| `activeIcon` | `Widget`  | Required | Icon when selected        |
| `label`      | `String?` | null     | Optional text label       |

### FabOptionItem Properties

| Property          | Type           | Default  | Description               |
|-------------------|----------------|----------|---------------------------|
| `icon`            | `IconData`     | Required | Option icon               |
| `iconColor`       | `Color`        | Required | Icon color                |
| `backgroundColor` | `Color`        | Required | Option background color   |
| `title`           | `String`       | Required | Option title              |
| `subtitle`        | `String`       | Required | Option subtitle           |
| `onTap`           | `VoidCallback` | Required | Option click callback     |

## Animation Details

- **FAB Rotation**: FAB icon rotates 45° when opening/closing options
- **Option Sliding**: Options slide up from the bottom with staggered delays
- **Blur Effect**: Background blur covers the entire screen including navigation bar
- **Smooth Curves**: Uses `Curves.easeOutBack` for pleasing animations

## Tips

1. **Stack Usage**: Ensure to wrap your Scaffold in a Stack if you need the blur effect to cover the app bar or other UI elements

2. **Safe Area**: The navigation bar automatically respects safe areas, but ensure your main content does too

3. **Performance Considerations**: The blur effect is optimized, but consider the impact on lower-end devices

## Example

Check the `example` folder for a complete implementation demonstrating all features of the plugin.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.