# Project Brief

## Project
Aero

## Goal
Refactor the Aero project from scratch to a clean, modular, feature-based architecture with an “Obsidian Black” design language.

## Key Requirements
- Design language:
  - Background: `#0b0b0b` (Deep Obsidian)
  - Accent: `#257bf4` (Electric Blue)
  - Cards: `#111418` with thin border `#ffffff0d`
  - Font: `Inter` (modern weights)
- Architecture:
  - Feature-based folders:
    - `features/finance`
    - `features/work`
    - `features/fitness`
  - Global `theme_provider` (or simple state management) for theme + shared app state.
- Finance view:
  - Centered donut chart.
  - Two vertically stacked buttons under chart:
    - Primary: “Harcama Gir” (large, filled accent, rounded)
    - Secondary: “Gelir Gir” (exactly 1.5x smaller, outlined/transparent)
  - Expense entry requires category selection:
    - Alışveriş, Market, Ulaşım, Yiyecek, Faturalar, Diğer
  - Bottom “Summary” area listing daily total expenses per category.
- Navigation and Drawer:
  - Drawer includes “AERO” header.
  - Immediately below header, a fixed “Kategori Ekle” button and a divider (should not be affected by bottom navigation bar).
  - Categories in drawer can be deleted via swipe-to-dismiss except the main categories: `work`, `fitness`, `finance`.
- Startup behavior:
  - No unnecessary splash/logo delays.
  - Home routes directly to `AeroContent` widget.

## Non-Goals (for now)
- Complex onboarding flows.
- Heavy animations that slow startup.

## Deliverables
- Refactored codebase meeting the above UI/UX and architectural requirements.
- Memory bank documentation (`memory-bank/` core files) kept up to date.
