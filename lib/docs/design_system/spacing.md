# 📏 Evergreen Spacing System

## 1. Base Grid

- 8pt grid system (Material standard)
- Tất cả spacing là bội số của 8

---

## 2. Spacing Scale

- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- xxl: 48px

---

## 3. Padding Rules

- Screen padding: 16px
- Card padding: 16px
- Button padding: 12–16px

---

## 4. Flutter Implementation

```dart id="spacing_001"
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}