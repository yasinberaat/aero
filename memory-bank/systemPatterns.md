# System Patterns

## Architectural style
- Feature-based modular structure.
- Each feature owns its:
  - UI (views/pages)
  - State (providers/controllers)
  - Models
  - Repositories/services (if needed)

## Shared layers
- App shell:
  - `AeroContent` is the main entry widget after app startup.
  - Bottom navigation for finance/work/fitness.
  - Drawer for category management.
- Global theme/state:
  - A `theme_provider` (or equivalent lightweight state management) provides:
    - Obsidian theme tokens (colors, text styles)
    - Possibly shared app state (selected tab, categories list)

## UI patterns
- Obsidian cards: background `#111418`, border `#ffffff0d`, rounded corners.
- Primary action button: filled accent (`#257bf4`), rounded.
- Secondary action button: outlined/transparent.

## Finance feature patterns
- Central donut chart that reflects day totals.
- Entry flows (expense/income) use category selection.
- Summary component lists per-category totals for the day.

## Drawer patterns
- Drawer header “AERO” with fixed top action (“Kategori Ekle”) and a divider.
- Category list supports swipe-to-dismiss delete, excluding main categories: work/fitness/finance.
