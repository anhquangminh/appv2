# 🧩 Evergreen Component System

## 1. Overview

Component system giúp:
- Tái sử dụng UI
- Giảm duplicate code
- Đồng nhất design toàn app

---

# 2. Button System

## 2.1 Primary Button
- Background: Primary color
- Text: White
- Height: 48px
- Radius: 12px

---

## 2.2 Secondary Button
- Background: Secondary color
- Text: Primary text
- Height: 48px

---

## 2.3 Outline Button
- Border: 1.5px
- Transparent background

---

## 2.4 Text Button
- No background
- Bold text

---

# 3. Input System

## Features:
- Label support
- Error state
- Prefix/Suffix icon
- Password toggle

---

# 4. Card System

## Types:
- User Card
- Info Card
- Product Card

---

# 5. Layout Components

- AppScaffold
- AppBar
- SectionContainer
- ResponsiveWrapper

---

# 6. Flutter Button Example

```dart id="button_001"
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AppButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}