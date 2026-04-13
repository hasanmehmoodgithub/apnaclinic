# 🔧 Extensions Guide

Simple guide for using extensions in your Flutter app.

---

## 📖 What are Extensions?

Extensions add new methods to existing classes without modifying them:
- **Context Extensions** - Easy access to MediaQuery, screen size, etc.
- **Text Style Extensions** - Responsive text sizing
- **DateTime Extensions** - Date formatting and time ago
- **String Extensions** - Validation, formatting, manipulation
- **List Extensions** - Safe access, filtering, grouping
- **Color Extensions** - Color manipulation and conversion
- **Widget Extensions** - Quick widget modifiers
- **Num Extensions** - Number formatting and calculations
- **BuildContext Extensions** - Theme, navigation, snackbars

---

## 🚀 Quick Start

### Import Extensions

```dart
// Import all extensions
import 'core/extensions/extensions_export.dart';

// Or import specific extension
import 'core/extensions/context_extensions.dart';
import 'core/extensions/string_extensions.dart';
import 'core/extensions/list_extensions.dart';
```

---

## 📱 Context Extensions

### Screen Size

```dart
// Get screen dimensions
final width = context.screenWidth;
final height = context.screenHeight;
final size = context.screenSize;

// Check orientation
if (context.isLandscape) { }
if (context.isPortrait) { }
```

### Responsive Sizing

```dart
// Get percentage of screen
final halfWidth = context.widthPercent(50);  // 50% of screen width
final quarterHeight = context.heightPercent(25);  // 25% of screen height

// Responsive sizing based on design
final responsiveWidth = context.responsiveWidth(100);  // Scales from design width
final responsiveHeight = context.responsiveHeight(50);  // Scales from design height
```

### Screen Type

```dart
// Check screen size
if (context.isSmallScreen) { }   // width < 600
if (context.isMediumScreen) { } // 600 <= width < 1200
if (context.isLargeScreen) { }   // width >= 1200

// Check device type
if (context.isPhone) { }   // width < 600
if (context.isTablet) { } // width >= 600
```

---

## 📝 Text Style Extensions

### Responsive Text

```dart
// Method 1: Using extension on TextStyle
Text(
  'Hello',
  style: TextStyle(fontSize: 16).responsive(
    context: context,
    baseSize: 16,
    minSize: 12,
    maxSize: 20,
  ),
)

// Method 2: Using context extension
Text(
  'Hello',
  style: context.responsiveTextStyle(
    baseSize: 16,
    minSize: 12,
    maxSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  ),
)
```

---

## 📅 DateTime Extensions

### Date Formatting

```dart
final date = DateTime.now();

// Formatted date
date.toFormattedDate();      // "Jan 15, 2024"
date.toShortDate();          // "15/01/2024"
date.toTime();               // "14:30"
date.timeAgo();              // "2 hours ago"
```

---

## 🔤 String Extensions

### Validation

```dart
final email = 'user@example.com';
final phone = '+1234567890';
final pakistaniPhone1 = '92301453343';  // With country code
final pakistaniPhone2 = '03013244123';  // Local format

// Email validation
email.isValidEmail;          // true

// Phone validation (supports international and Pakistani)
phone.isValidPhone;           // true
pakistaniPhone1.isValidPhone; // true (92301453343)
pakistaniPhone2.isValidPhone; // true (03013244123)

// Pakistani phone specific validation
pakistaniPhone1.isValidPakistaniPhone; // true
pakistaniPhone2.isValidPakistaniPhone; // true

// Format Pakistani phone to standard format
pakistaniPhone2.formatPakistaniPhone; // "92301453343" (converts 0... to 92...)

// Other validations
'https://example.com'.isValidUrl;  // true
'password123'.isValidPassword;     // true
```

### Formatting

```dart
final text = 'hello world';

// Capitalization
text.capitalize;             // "Hello world"
text.capitalizeWords;        // "Hello World"
text.initials;               // "HW"

// Manipulation
text.removeWhitespace;       // "helloworld"
text.removeSpecialChars;     // "hello world"
text.truncate(5);            // "hello..."
text.mask(start: 2, end: 2); // "he******ld"
```

### Conversion

```dart
'123'.toIntOrNull();          // 123
'45.67'.toDoubleOrNull();   // 45.67
'true'.toBool();            // true
'100'.toCurrency();        // "$100.00"
```

### Complete Example

```dart
import 'core/extensions/string_extensions.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        if (value.isValidEmail) {
          // Valid email
        }
      },
    );
  }
}

class PhoneField extends StatelessWidget {
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        // Check Pakistani phone
        if (value.isValidPakistaniPhone) {
          // Format to standard format (92301453343)
          final formatted = value.formatPakistaniPhone;
          print('Formatted: $formatted');
        }
        
        // Or check general phone (supports international and Pakistani)
        if (value.isValidPhone) {
          // Valid phone number
        }
      },
    );
  }
}
```

---

## 📋 List Extensions

### Safe Access

```dart
final list = [1, 2, 3];

// Safe access
list.firstOrNull;            // 1
list.lastOrNull;             // 3
list.elementAtOrNull(5);    // null
list.elementAtOrDefault(5, 0);  // 0
```

### Operations

```dart
final numbers = [1, 2, 2, 3, 3, 4];

// Remove duplicates
numbers.unique;              // [1, 2, 3, 4]

// Chunk list
[1, 2, 3, 4, 5].chunk(2);    // [[1, 2], [3, 4], [5]]

// Group by
users.groupBy((u) => u.city);

// Partition
final [even, odd] = numbers.partition((n) => n % 2 == 0);
```

### Calculations

```dart
final prices = [10.0, 20.0, 30.0];

prices.sum;                  // 60.0
prices.average;              // 20.0
prices.max;                  // 30.0
prices.min;                  // 10.0
```

### Complete Example

```dart
import 'core/extensions/list_extensions.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final firstProduct = products.firstOrNull;
    if (firstProduct == null) return Text('No products');

    return ListView(
      children: products
          .uniqueBy((p) => p.id)
          .map((p) => ProductItem(p))
          .toList(),
    );
  }
}
```

---

## 🎨 Color Extensions

### Color Manipulation

```dart
final color = Colors.blue;

// Check brightness
color.isDark;                // false
color.isLight;               // true
color.contrastColor;         // White or Black

// Modify color
color.darken(0.2);           // Darker blue
color.lighten(0.2);          // Lighter blue
color.saturate(0.3);         // More saturated
color.desaturate(0.3);       // Less saturated
color.complementary;         // Complementary color

// Convert
color.hex;                   // "#2196F3"
ColorExtensions.fromHex('#FF0000');  // Red color
```

### Hex Conversion

```dart
'#FF0000'.toColor;           // Red color
'FF0000'.isValidHexColor;    // true
```

### Complete Example

```dart
import 'core/extensions/color_extensions.dart';

class ThemedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;
    final textColor = primaryColor.contrastColor;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textColor,
      ),
      onPressed: () {},
      child: Text('Button'),
    );
  }
}
```

---

## 🧩 Widget Extensions

### Quick Modifiers

```dart
Text('Hello')
  .paddingAll(16)
  .marginSymmetric(horizontal: 8)
  .backgroundColor(Colors.blue)
  .rounded(8)
  .shadow()
  .onTap(() => print('Tapped'))
  .center
  .expand;
```

### Padding & Margin

```dart
widget.padding(EdgeInsets.all(16));
widget.paddingAll(16);
widget.paddingSymmetric(horizontal: 8, vertical: 4);
widget.paddingOnly(left: 8, top: 4);

widget.margin(EdgeInsets.all(16));
widget.marginAll(16);
widget.marginSymmetric(horizontal: 8);
```

### Styling

```dart
widget.backgroundColor(Colors.blue);
widget.border(color: Colors.grey, width: 1);
widget.rounded(8);
widget.shadow(blurRadius: 8);
widget.opacity(0.5);
widget.visible(true);
```

### Layout

```dart
widget.center;
widget.align(Alignment.topRight);
widget.expand;
widget.flexible(flex: 2);
widget.sized(width: 100, height: 50);
widget.square(100);
```

### Complete Example

```dart
import 'core/extensions/widget_extensions.dart';

class CardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Card Content')
        .paddingAll(16)
        .backgroundColor(Colors.white)
        .rounded(12)
        .shadow()
        .onTap(() => print('Card tapped'));
  }
}
```

---

## 🔢 Num Extensions

### Formatting

```dart
final price = 1234.56;
final size = 1048576;
final duration = 3661000;

// Currency
price.toCurrency();          // "$1234.56"
price.toCurrency(symbol: '€'); // "€1234.56"

// Formatted number
1234567.toFormattedString(); // "1,234,567"

// Percentage
0.85.toPercentage();         // "85%"

// File size
size.toFileSize();           // "1.00 MB"

// Duration
duration.toDuration();       // "1h 1m 1s"
duration.toTimeString();     // "01:01:01"

// Compact
1234567.toCompactString();   // "1.2M"
```

### Checks

```dart
5.isPositive;                // true
-3.isNegative;               // true
0.isZero;                    // true
5.isBetween(1, 10);          // true
```

### Complete Example

```dart
import 'core/extensions/num_extensions.dart';

class PriceWidget extends StatelessWidget {
  final double price;

  @override
  Widget build(BuildContext context) {
    return Text(
      price.toCurrency(symbol: '\$'),
      style: TextStyle(fontSize: 24),
    );
  }
}
```

---

## 🎯 BuildContext Extensions

### Theme Access

```dart
// Theme
context.theme;
context.textTheme;
context.colorScheme;
context.primaryColor;
context.isDarkMode;
context.isLightMode;
```

### Snackbars

```dart
// Basic snackbar
context.showSnackBar('Message');

// Typed snackbars
context.showSuccessSnackBar('Success!');
context.showErrorSnackBar('Error!');
context.showInfoSnackBar('Info');
context.showWarningSnackBar('Warning');
```

### Navigation

```dart
// Pop
context.pop();
context.pop(result);

// Push
context.pushNamed('/home');
context.pushReplacementNamed('/login');
context.pushNamedAndRemoveUntil('/home', (route) => false);

// Check
if (context.canPop) context.pop();
```

### Dialogs & Bottom Sheets

```dart
// Dialog
context.showAppDialog(
  builder: (context) => AlertDialog(
    title: Text('Title'),
    content: Text('Content'),
  ),
);

// Bottom sheet
context.showBottomSheet(
  builder: (context) => Container(
    height: 200,
    child: Text('Bottom Sheet'),
  ),
);
```

### Keyboard

```dart
context.hideKeyboard();
context.requestFocus(focusNode);
context.isKeyboardVisible;
```

### Complete Example

```dart
import 'core/extensions/build_context_extensions.dart';

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.showSuccessSnackBar('Button clicked!');
        context.hideKeyboard();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: context.primaryColor,
      ),
      child: Text('Click Me'),
    );
  }
}
```

---

## ✅ Best Practices

### 1. Use Extensions for Common Operations

```dart
// ✅ Good
if (email.isValidEmail) { }
context.showSuccessSnackBar('Done!');
price.toCurrency();

// ❌ Bad
if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) { }
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Done!')));
'\$${price.toStringAsFixed(2)}';
```

### 2. Use Safe Access for Lists

```dart
// ✅ Good
final first = list.firstOrNull;
final item = list.elementAtOrNull(5);

// ❌ Bad
final first = list.isEmpty ? null : list.first;
final item = list.length > 5 ? list[5] : null;
```

### 3. Use Widget Extensions for Quick Styling

```dart
// ✅ Good
Text('Hello').paddingAll(16).rounded(8)

// ❌ Bad
Padding(
  padding: EdgeInsets.all(16),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Text('Hello'),
  ),
)
```

---

## 📋 Quick Reference

### String Extensions
```dart
string.isValidEmail
string.capitalize
string.truncate(10)
string.toIntOrNull()
```

### List Extensions
```dart
list.firstOrNull
list.unique
list.chunk(3)
list.groupBy((item) => item.key)
```

### Color Extensions
```dart
color.darken(0.2)
color.hex
'#FF0000'.toColor
```

### Widget Extensions
```dart
widget.paddingAll(16)
widget.rounded(8)
widget.onTap(() {})
```

### Num Extensions
```dart
price.toCurrency()
size.toFileSize()
number.toFormattedString()
```

### BuildContext Extensions
```dart
context.showSuccessSnackBar('Message')
context.primaryColor
context.pop()
```

---

## 🎯 Summary

1. ✅ **Import**: `import 'core/extensions/extensions_export.dart';`
2. ✅ **Use Extensions**: Make code cleaner and more readable
3. ✅ **Safe Access**: Use `firstOrNull`, `elementAtOrNull` for lists
4. ✅ **Quick Styling**: Use widget extensions for common styling
5. ✅ **Formatting**: Use extensions for currency, dates, numbers

---

That's it! Simple and easy. 🔧
