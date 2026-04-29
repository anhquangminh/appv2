# 🎨 Evergreen Color System (Flutter Design System)

## 1. Overview

Hệ thống màu được thiết kế theo chuẩn:
- WCAG Accessibility compliant
- Hỗ trợ Light / Dark Mode
- Semantic color rõ ràng
- Không sử dụng Colors.* trực tiếp trong UI

---

# 2. Light Mode Colors

## Primary Palette
- Primary: #07513D (Deep Evergreen)
- Secondary: #34D399 (Emerald Mist)
- Accent: #F59E0B (Amber Gold)

---

## Background & Surface
- Background: #F8FAF6 (Off-White Mint)
- Surface: #FFFFFF (Pure White)

---

## Text Colors
- Text Primary: #1A1C1A
- Text Secondary: #404944
- Text Disabled: #9CA3AF

---

## Border & Divider
- Border: #E5E7EB

---

## Semantic Colors
- Success: #10B981
- Warning: #F59E0B
- Error: #EF4444
- Info: #3B82F6

---

# 3. Dark Mode Colors

## Primary Palette
- Primary: #10B981
- Secondary: #064E3B
- Accent: #FBBF24

---

## Background & Surface
- Background: #0F1713
- Surface: #19211D

---

## Text Colors
- Text Primary: #F9FAFB
- Text Secondary: #D1D5DB
- Text Disabled: #4B5563

---

## Border & Divider
- Border: #2D3732

---

## Semantic Colors
- Success: #34D399
- Warning: #FBBF24
- Error: #F87171
- Info: #60A5FA

---

# 4. Flutter Implementation

```dart id="app_colors_001"
import 'package:flutter/material.dart';

class AppColors {
  // ================= LIGHT MODE =================
  static const primaryLight = Color(0xFF07513D);
  static const secondaryLight = Color(0xFF34D399);
  static const accentLight = Color(0xFFF59E0B);

  static const backgroundLight = Color(0xFFF8FAF6);
  static const surfaceLight = Color(0xFFFFFFFF);

  static const textPrimaryLight = Color(0xFF1A1C1A);
  static const textSecondaryLight = Color(0xFF404944);
  static const textDisabledLight = Color(0xFF9CA3AF);

  static const borderLight = Color(0xFFE5E7EB);

  // Semantic Light
  static const successLight = Color(0xFF10B981);
  static const warningLight = Color(0xFFF59E0B);
  static const errorLight = Color(0xFFEF4444);
  static const infoLight = Color(0xFF3B82F6);

  // ================= DARK MODE =================
  static const primaryDark = Color(0xFF10B981);
  static const secondaryDark = Color(0xFF064E3B);
  static const accentDark = Color(0xFFFBBF24);

  static const backgroundDark = Color(0xFF0F1713);
  static const surfaceDark = Color(0xFF19211D);

  static const textPrimaryDark = Color(0xFFF9FAFB);
  static const textSecondaryDark = Color(0xFFD1D5DB);
  static const textDisabledDark = Color(0xFF4B5563);

  static const borderDark = Color(0xFF2D3732);

  // Semantic Dark
  static const successDark = Color(0xFF34D399);
  static const warningDark = Color(0xFFFBBF24);
  static const errorDark = Color(0xFFF87171);
  static const infoDark = Color(0xFF60A5FA);
}