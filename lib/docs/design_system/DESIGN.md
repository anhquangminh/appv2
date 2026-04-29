# Design System Document

## 1. Overview & Creative North Star: "The Organic Atelier"
This design system moves away from the sterile, "spreadsheet" feel of traditional task management. Our Creative North Star is **The Organic Atelier**: a digital environment that feels like a high-end, bespoke physical workspace. It balances the structured logic of Material Design 3 with the tactile sophistication of editorial print.

By leveraging a deep, botanical green palette (#07513d) and intentional white space, we create a "calm productivity" experience. We break the template look through **Tonal Nesting**—where depth is defined by shifts in color rather than structural lines—and **Asymmetric Breathing Room**, ensuring the UI feels curated, not just generated.

---

## 2. Colors: Tonal Depth & The "No-Line" Rule
The palette is rooted in nature, using the primary deep green to anchor the user’s focus while utilizing a sophisticated range of surface neutrals to define hierarchy.

### The "No-Line" Rule
**Explicit Instruction:** Do not use 1px solid borders to section off content. Traditional dividers create visual noise. Instead:
- **Background Shifts:** Use `surface-container-low` for sidebars and `surface` for main content areas.
- **Nesting:** Place a `surface-container-lowest` card on top of a `surface-container` background to create a soft, natural edge.

### Surface Hierarchy & Nesting
Treat the UI as a series of stacked, premium cardstock.
- **Base Layer:** `surface` (#f8faf6)
- **Secondary Containers:** `surface-container-low` (#f2f4f1)
- **High-Priority Components:** `surface-container-lowest` (#ffffff) for maximum "lift."

### The "Glass & Gradient" Rule
To elevate the experience, use **Glassmorphism** for floating elements like navigation bars or quick-action menus. 
- **Recipe:** Apply `surface` color at 80% opacity with a `24px` backdrop-blur. 
- **Signature Textures:** For primary CTAs (e.g., "New Task"), use a subtle linear gradient from `primary_container` (#07513d) to `primary` (#003829) at a 135-degree angle to add a "jewel-toned" depth.

---

## 3. Typography: Editorial Clarity
We use **Inter** exclusively. Its neutral, high-legibility geometric forms allow the color palette and layout to take center stage.

- **Display (Large/Medium):** Reserved for "Dashboard" headers or empty-state moments. Use `-0.02em` letter spacing to give it an editorial feel.
- **Headlines:** Used for task group titles. These should feel authoritative and grounded.
- **Body (Large/Medium):** The workhorse of the app. Ensure a line height of `1.5` for extended task descriptions to prevent visual fatigue.
- **Labels:** Use `label-md` or `label-sm` in `on_surface_variant` (#404944) for metadata (dates, tags). 

---

## 4. Elevation & Depth: The Layering Principle
We reject the "drop shadow" defaults of the early web. We communicate importance through **Tonal Layering**.

- **Ambient Shadows:** For high-priority floating modals, use a "Botanical Shadow." Instead of grey, use a deep green tint: `rgba(7, 81, 61, 0.08)` with a `40px` blur and `12px` Y-offset.
- **The "Ghost Border" Fallback:** If a layout requires a boundary for accessibility (e.g., high-contrast mode), use a **Ghost Border**: the `outline_variant` (#bfc9c3) at **15% opacity**. It should be felt, not seen.
- **Interactions:** On hover, cards should transition from `surface-container-low` to `surface-container-highest` rather than growing a shadow. This mimics the physical behavior of a light source moving closer.

---

## 5. Components

### Buttons
- **Primary:** Gradient fill (`primary_container` to `primary`), `9999px` (full) roundedness. No border. Text: `on_primary` (#ffffff).
- **Secondary:** `surface-container-high` fill. No border. Softly rounded (`md` scale).
- **Tertiary:** No fill. `primary` text. Use for low-emphasis actions like "Cancel."

### Cards & Lists
- **Rule:** Forbid divider lines between list items. Use a `1.5` (0.375rem) vertical gap and a subtle background change (`surface-container-low` for even rows, `surface` for odd) if necessary.
- **Roundedness:** Task cards must use `xl` (1.5rem) corner radius to feel approachable and modern.

### Input Fields
- **Styling:** Use the "Filled" Material 3 style but replace the bottom stroke with a `surface-container-high` background and `lg` (1rem) top-corner rounding. 
- **Focus State:** Transition the background to `secondary_container` (#cee9db) with a subtle `primary` ghost border.

### Contextual Components
- **The "Focus Pulse":** For active tasks, use a soft glow effect utilizing the `primary_fixed_dim` (#93d4b9) color to gently draw the eye without being intrusive.
- **Progress Rings:** Use `primary` for the progress arc and `surface-container-highest` for the empty track.

---

## 6. Do’s and Don'ts

### Do
- **Do** use white space as a structural element. If a section feels crowded, increase padding using the `8` (2rem) or `10` (2.5rem) scale.
- **Do** use `primary_container` (#07513d) for "Deep Work" states to signal intense focus.
- **Do** use icons from a consistent, rounded-corner set to match the `1.5rem` card radius.

### Don’t
- **Don’t** use pure black (#000000) for text. Always use `on_surface` (#191c1a) to maintain the organic tone.
- **Don’t** use harsh 90-degree corners. Everything must feel "tumbled" and soft to the touch.
- **Don’t** use standard red for error states if it can be avoided; use the `error` (#ba1a1a) token, which is calibrated to sit harmoniously within this green-centric system.