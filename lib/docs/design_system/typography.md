# ✍️ Evergreen Typography System

## 1. Font Family

Primary font:
- Inter (Google Fonts)
- Fallback: system-ui

---

## 2. Type Scale

### Headings
- H1: 32px / Bold
- H2: 24px / Bold
- H3: 20px / Semi-Bold

---

### Body
- Body Large: 16px / Regular
- Body Medium: 14px / Regular

---

### Caption
- Caption: 12px / Regular

---

## 3. Usage Rules

- Heading → Titles, Screen headers
- Body → Content text
- Caption → Labels, hints

---

## 4. Flutter Implementation

```dart id="typography_001"
import 'package:flutter/material.dart';

class AppTextStyles {
  // ================= HEADINGS =================
  static const h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ================= BODY =================
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ================= CAPTION =================
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}
