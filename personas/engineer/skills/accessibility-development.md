---
name: accessibility-development
description: WCAG 2.1/2.2 compliant code development with accessible component patterns, semantic HTML, ARIA implementation, and keyboard navigation for React, Vue, Angular, and vanilla JavaScript. Use when building UI components, implementing forms, creating interactive elements, or when user mentions accessibility during development.
---

# Accessibility Development Skill

Write WCAG 2.1/2.2 compliant code from the start with accessible component patterns, semantic HTML, proper ARIA usage, keyboard navigation, and focus management.

## When to Use This Skill

Automatically invoke when the user:
- Creates UI components (React, Vue, Angular, Web Components)
- Implements forms or interactive elements
- Asks "how to make this accessible"
- Mentions WCAG, ARIA, semantic HTML, or a11y
- Creates buttons, modals, dropdowns, tabs, accordions
- Implements keyboard navigation or focus management
- Works on color, contrast, or visual design in code

## WCAG 2.1 Development Principles

### Four Core Principles (POUR)

#### 1. Perceivable
Information and UI components must be presentable to users in ways they can perceive.

#### 2. Operable
UI components and navigation must be operable (keyboard, mouse, touch, voice).

#### 3. Understandable
Information and UI operation must be understandable.

#### 4. Robust
Content must be robust enough to be interpreted by assistive technologies.

## Accessible Component Patterns

### Semantic HTML First

```html
<!-- ❌ BAD: Non-semantic markup -->
<div class="button" onclick="submitForm()">
  Submit
</div>

<!-- ✅ GOOD: Semantic HTML -->
<button type="submit" onclick="submitForm()">
  Submit
</button>

<!-- ❌ BAD: Div soup for navigation -->
<div class="nav">
  <div class="nav-item"><a href="/">Home</a></div>
  <div class="nav-item"><a href="/about">About</a></div>
</div>

<!-- ✅ GOOD: Semantic navigation -->
<nav aria-label="Main navigation">
  <ul>
    <li><a href="/">Home</a></li>
    <li><a href="/about">About</a></li>
  </ul>
</nav>
```

### React Accessible Components

#### Accessible Button Component

```typescript
// AccessibleButton.tsx
import React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'danger';
  isLoading?: boolean;
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
}

export const AccessibleButton: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  isLoading = false,
  leftIcon,
  rightIcon,
  disabled,
  ...props
}) => {
  return (
    <button
      type={props.type || 'button'}
      className={`btn btn-${variant}`}
      disabled={disabled || isLoading}
      aria-disabled={disabled || isLoading}
      aria-busy={isLoading}
      {...props}
    >
      {leftIcon && <span aria-hidden="true">{leftIcon}</span>}
      {children}
      {isLoading && (
        <>
          <span className="spinner" aria-hidden="true" />
          <span className="sr-only">Loading...</span>
        </>
      )}
      {rightIcon && <span aria-hidden="true">{rightIcon}</span>}
    </button>
  );
};

// CSS for screen reader only text
// .sr-only { position: absolute; width: 1px; height: 1px;
//            padding: 0; margin: -1px; overflow: hidden;
//            clip: rect(0,0,0,0); white-space: nowrap;
//            border-width: 0; }
```

#### Accessible Modal Dialog

```typescript
// AccessibleModal.tsx
import React, { useEffect, useRef } from 'react';
import { createPortal } from 'react-dom';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
}

export const AccessibleModal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title,
  children
}) => {
  const modalRef = useRef<HTMLDivElement>(null);
  const previousActiveElement = useRef<HTMLElement | null>(null);

  useEffect(() => {
    if (isOpen) {
      // Store previously focused element
      previousActiveElement.current = document.activeElement as HTMLElement;

      // Focus first focusable element in modal
      const firstFocusable = modalRef.current?.querySelector<HTMLElement>(
        'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
      );
      firstFocusable?.focus();

      // Trap focus within modal
      const handleTab = (e: KeyboardEvent) => {
        if (e.key !== 'Tab') return;

        const focusableElements = modalRef.current?.querySelectorAll<HTMLElement>(
          'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
        );

        if (!focusableElements || focusableElements.length === 0) return;

        const firstElement = focusableElements[0];
        const lastElement = focusableElements[focusableElements.length - 1];

        if (e.shiftKey && document.activeElement === firstElement) {
          e.preventDefault();
          lastElement.focus();
        } else if (!e.shiftKey && document.activeElement === lastElement) {
          e.preventDefault();
          firstElement.focus();
        }
      };

      const handleEscape = (e: KeyboardEvent) => {
        if (e.key === 'Escape') {
          onClose();
        }
      };

      document.addEventListener('keydown', handleTab);
      document.addEventListener('keydown', handleEscape);

      // Prevent body scroll
      document.body.style.overflow = 'hidden';

      return () => {
        document.removeEventListener('keydown', handleTab);
        document.removeEventListener('keydown', handleEscape);
        document.body.style.overflow = '';

        // Restore focus to previously focused element
        previousActiveElement.current?.focus();
      };
    }
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  return createPortal(
    <div
      className="modal-overlay"
      onClick={(e) => {
        // Close on backdrop click
        if (e.target === e.currentTarget) onClose();
      }}
      role="dialog"
      aria-modal="true"
      aria-labelledby="modal-title"
    >
      <div ref={modalRef} className="modal-content">
        <div className="modal-header">
          <h2 id="modal-title">{title}</h2>
          <button
            onClick={onClose}
            aria-label="Close dialog"
            className="modal-close"
          >
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div className="modal-body">
          {children}
        </div>
      </div>
    </div>,
    document.body
  );
};
```

#### Accessible Form with Validation

```typescript
// AccessibleForm.tsx
import React, { useState } from 'react';

interface FormErrors {
  email?: string;
  password?: string;
}

export const AccessibleForm: React.FC = () => {
  const [errors, setErrors] = useState<FormErrors>({});
  const [touched, setTouched] = useState<Set<string>>(new Set());

  const validateEmail = (email: string): string | undefined => {
    if (!email) return 'Email is required';
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      return 'Please enter a valid email address';
    }
  };

  const validatePassword = (password: string): string | undefined => {
    if (!password) return 'Password is required';
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
  };

  const handleBlur = (field: string) => {
    setTouched(prev => new Set(prev).add(field));
  };

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);

    const email = formData.get('email') as string;
    const password = formData.get('password') as string;

    const newErrors: FormErrors = {
      email: validateEmail(email),
      password: validatePassword(password)
    };

    setErrors(newErrors);
    setTouched(new Set(['email', 'password']));

    if (!newErrors.email && !newErrors.password) {
      // Submit form
      console.log('Form submitted successfully');
    }
  };

  return (
    <form onSubmit={handleSubmit} noValidate>
      {/* Email Field */}
      <div className="form-group">
        <label htmlFor="email">
          Email <span aria-label="required">*</span>
        </label>
        <input
          type="email"
          id="email"
          name="email"
          required
          aria-required="true"
          aria-invalid={touched.has('email') && !!errors.email}
          aria-describedby={errors.email ? 'email-error' : undefined}
          onBlur={() => handleBlur('email')}
        />
        {touched.has('email') && errors.email && (
          <div
            id="email-error"
            className="error-message"
            role="alert"
            aria-live="polite"
          >
            {errors.email}
          </div>
        )}
      </div>

      {/* Password Field */}
      <div className="form-group">
        <label htmlFor="password">
          Password <span aria-label="required">*</span>
        </label>
        <input
          type="password"
          id="password"
          name="password"
          required
          aria-required="true"
          aria-invalid={touched.has('password') && !!errors.password}
          aria-describedby={errors.password ? 'password-error password-requirements' : 'password-requirements'}
          onBlur={() => handleBlur('password')}
        />
        <div id="password-requirements" className="form-hint">
          Must be at least 8 characters
        </div>
        {touched.has('password') && errors.password && (
          <div
            id="password-error"
            className="error-message"
            role="alert"
            aria-live="polite"
          >
            {errors.password}
          </div>
        )}
      </div>

      <button type="submit">Sign In</button>
    </form>
  );
};
```

### Vue Accessible Components

#### Accessible Dropdown Menu (Vue 3)

```vue
<!-- AccessibleDropdown.vue -->
<template>
  <div class="dropdown" ref="dropdownRef">
    <button
      @click="toggleDropdown"
      @keydown.down.prevent="openAndFocusFirst"
      @keydown.up.prevent="openAndFocusLast"
      :aria-expanded="isOpen"
      aria-haspopup="true"
      :aria-controls="menuId"
    >
      {{ label }}
      <span aria-hidden="true">▼</span>
    </button>

    <ul
      v-show="isOpen"
      :id="menuId"
      role="menu"
      :aria-labelledby="buttonId"
      class="dropdown-menu"
    >
      <li
        v-for="(item, index) in items"
        :key="item.id"
        role="none"
      >
        <a
          :href="item.href"
          role="menuitem"
          :tabindex="isOpen ? 0 : -1"
          @click="handleItemClick(item)"
          @keydown.down.prevent="focusNext(index)"
          @keydown.up.prevent="focusPrevious(index)"
          @keydown.home.prevent="focusFirst"
          @keydown.end.prevent="focusLast"
          @keydown.escape="closeAndFocusButton"
          :ref="el => menuItems[index] = el"
        >
          {{ item.label }}
        </a>
      </li>
    </ul>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

interface DropdownItem {
  id: string;
  label: string;
  href: string;
}

interface Props {
  label: string;
  items: DropdownItem[];
}

const props = defineProps<Props>();

const isOpen = ref(false);
const dropdownRef = ref<HTMLElement | null>(null);
const menuItems = ref<(HTMLElement | null)[]>([]);
const menuId = `dropdown-menu-${Math.random().toString(36).substr(2, 9)}`;
const buttonId = `dropdown-button-${Math.random().toString(36).substr(2, 9)}`;

const toggleDropdown = () => {
  isOpen.value = !isOpen.value;
};

const openAndFocusFirst = () => {
  isOpen.value = true;
  setTimeout(() => focusFirst(), 0);
};

const openAndFocusLast = () => {
  isOpen.value = true;
  setTimeout(() => focusLast(), 0);
};

const focusFirst = () => {
  menuItems.value[0]?.focus();
};

const focusLast = () => {
  menuItems.value[menuItems.value.length - 1]?.focus();
};

const focusNext = (currentIndex: number) => {
  const nextIndex = (currentIndex + 1) % menuItems.value.length;
  menuItems.value[nextIndex]?.focus();
};

const focusPrevious = (currentIndex: number) => {
  const prevIndex = currentIndex === 0 ? menuItems.value.length - 1 : currentIndex - 1;
  menuItems.value[prevIndex]?.focus();
};

const closeAndFocusButton = () => {
  isOpen.value = false;
  dropdownRef.value?.querySelector('button')?.focus();
};

const handleItemClick = (item: DropdownItem) => {
  console.log('Item clicked:', item);
  isOpen.value = false;
};

const handleClickOutside = (event: MouseEvent) => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target as Node)) {
    isOpen.value = false;
  }
};

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside);
});
</script>
```

### Angular Accessible Components

#### Accessible Tab Component

```typescript
// accessible-tabs.component.ts
import { Component, ContentChildren, QueryList, AfterContentInit } from '@angular/core';

@Component({
  selector: 'app-tab',
  template: `
    <div
      [hidden]="!active"
      role="tabpanel"
      [attr.id]="'panel-' + tabId"
      [attr.aria-labelledby]="'tab-' + tabId"
      [attr.tabindex]="active ? 0 : -1"
    >
      <ng-content></ng-content>
    </div>
  `
})
export class TabComponent {
  tabId!: string;
  active = false;
  title = '';
}

@Component({
  selector: 'app-tabs',
  template: `
    <div class="tabs">
      <div role="tablist" [attr.aria-label]="ariaLabel">
        <button
          *ngFor="let tab of tabs; let i = index"
          role="tab"
          [attr.id]="'tab-' + tab.tabId"
          [attr.aria-selected]="tab.active"
          [attr.aria-controls]="'panel-' + tab.tabId"
          [attr.tabindex]="tab.active ? 0 : -1"
          (click)="selectTab(tab)"
          (keydown.arrowRight)="selectNextTab()"
          (keydown.arrowLeft)="selectPreviousTab()"
          (keydown.home)="selectFirstTab()"
          (keydown.end)="selectLastTab()"
        >
          {{ tab.title }}
        </button>
      </div>
      <ng-content></ng-content>
    </div>
  `
})
export class TabsComponent implements AfterContentInit {
  @ContentChildren(TabComponent) tabs!: QueryList<TabComponent>;
  ariaLabel = 'Tabs';

  ngAfterContentInit() {
    // Set IDs and activate first tab
    this.tabs.forEach((tab, index) => {
      tab.tabId = `tab-${index}`;
      if (index === 0) {
        tab.active = true;
      }
    });
  }

  selectTab(selectedTab: TabComponent) {
    this.tabs.forEach(tab => {
      tab.active = tab === selectedTab;
    });
  }

  selectNextTab() {
    const tabsArray = this.tabs.toArray();
    const currentIndex = tabsArray.findIndex(tab => tab.active);
    const nextIndex = (currentIndex + 1) % tabsArray.length;
    this.selectTab(tabsArray[nextIndex]);
  }

  selectPreviousTab() {
    const tabsArray = this.tabs.toArray();
    const currentIndex = tabsArray.findIndex(tab => tab.active);
    const prevIndex = currentIndex === 0 ? tabsArray.length - 1 : currentIndex - 1;
    this.selectTab(tabsArray[prevIndex]);
  }

  selectFirstTab() {
    this.selectTab(this.tabs.first);
  }

  selectLastTab() {
    this.selectTab(this.tabs.last);
  }
}
```

## ARIA Reference Guide

### ARIA Roles

```html
<!-- Landmark Roles -->
<header role="banner">...</header>
<nav role="navigation">...</nav>
<main role="main">...</main>
<aside role="complementary">...</aside>
<footer role="contentinfo">...</footer>

<!-- Widget Roles -->
<div role="button" tabindex="0">...</div>
<div role="checkbox" aria-checked="true">...</div>
<div role="dialog" aria-modal="true">...</div>
<div role="tablist">
  <button role="tab">...</button>
</div>

<!-- Live Region Roles -->
<div role="alert">Error message</div>
<div role="status">Loading...</div>
<div role="log">Console output...</div>
```

### ARIA States and Properties

```html
<!-- States (dynamic) -->
<button aria-pressed="true">Toggle</button>
<input aria-invalid="true" aria-errormessage="error-msg">
<div aria-expanded="true">Dropdown content</div>
<div aria-hidden="true">Decorative element</div>

<!-- Properties (relationships) -->
<button aria-label="Close dialog">×</button>
<input aria-labelledby="label-id" aria-describedby="help-id">
<div aria-live="polite" aria-atomic="true">Status update</div>
<input aria-required="true" aria-readonly="false">
```

## Color Contrast Guidelines

### WCAG 2.1 AA Requirements

```css
/* Normal text (< 18px or < 14px bold) */
/* Minimum contrast ratio: 4.5:1 */

.text-normal {
  color: #595959;  /* 7.0:1 on white - PASSES AAA */
  background: #ffffff;
}

/* Large text (≥ 18px or ≥ 14px bold) */
/* Minimum contrast ratio: 3:1 */

.text-large {
  font-size: 18px;
  color: #767676;  /* 4.5:1 on white - PASSES AA */
  background: #ffffff;
}

/* Non-text (icons, borders) */
/* Minimum contrast ratio: 3:1 */

.icon {
  border: 2px solid #767676;  /* 4.5:1 - PASSES */
}

/* ❌ FAILS - Insufficient contrast */
.bad-contrast {
  color: #999999;  /* 2.8:1 - FAILS AA */
  background: #ffffff;
}
```

### Accessible Color Palette Generator

```typescript
// utils/accessible-colors.ts

export const getAccessibleColor = (
  background: string,
  targetRatio: number = 4.5
): string => {
  // Calculate luminance
  const getLuminance = (hex: string): number => {
    const rgb = parseInt(hex.slice(1), 16);
    const r = (rgb >> 16) & 0xff;
    const g = (rgb >> 8) & 0xff;
    const b = (rgb >> 0) & 0xff;

    const [rs, gs, bs] = [r, g, b].map(c => {
      c = c / 255;
      return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
    });

    return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
  };

  // Calculate contrast ratio
  const getContrastRatio = (color1: string, color2: string): number => {
    const l1 = getLuminance(color1);
    const l2 = getLuminance(color2);
    const lighter = Math.max(l1, l2);
    const darker = Math.min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  };

  // Find accessible foreground color
  const bgLuminance = getLuminance(background);

  if (bgLuminance > 0.5) {
    // Light background - use dark text
    return '#000000';
  } else {
    // Dark background - use light text
    return '#ffffff';
  }
};

// Usage
const bgColor = '#3498db';
const textColor = getAccessibleColor(bgColor);  // Returns accessible text color
```

## Keyboard Navigation Patterns

### Focus Management

```typescript
// useFocusTrap.ts - Custom React Hook
import { useEffect, useRef } from 'react';

export const useFocusTrap = (isActive: boolean) => {
  const containerRef = useRef<HTMLElement>(null);

  useEffect(() => {
    if (!isActive) return;

    const container = containerRef.current;
    if (!container) return;

    const focusableElements = container.querySelectorAll<HTMLElement>(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );

    if (focusableElements.length === 0) return;

    const firstElement = focusableElements[0];
    const lastElement = focusableElements[focusableElements.length - 1];

    // Focus first element
    firstElement.focus();

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key !== 'Tab') return;

      if (e.shiftKey) {
        // Shift + Tab
        if (document.activeElement === firstElement) {
          e.preventDefault();
          lastElement.focus();
        }
      } else {
        // Tab
        if (document.activeElement === lastElement) {
          e.preventDefault();
          firstElement.focus();
        }
      }
    };

    container.addEventListener('keydown', handleKeyDown);

    return () => {
      container.removeEventListener('keydown', handleKeyDown);
    };
  }, [isActive]);

  return containerRef;
};
```

### Skip Links

```html
<!-- Always first element in <body> -->
<a href="#main-content" class="skip-link">
  Skip to main content
</a>

<nav>
  <!-- Navigation -->
</nav>

<main id="main-content" tabindex="-1">
  <!-- Main content -->
</main>

<style>
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: #000;
  color: #fff;
  padding: 8px 16px;
  text-decoration: none;
  z-index: 9999;
}

.skip-link:focus {
  top: 0;
}
</style>
```

## Output Format

```
♿ ACCESSIBILITY DEVELOPMENT REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 WCAG 2.1 Compliance: Level AA
✓ Accessible Code Generated
✓ Keyboard Navigation Implemented
✓ Screen Reader Compatible
✓ Color Contrast Validated

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ ACCESSIBLE CODE

[Component: AccessibleButton.tsx]

✓ Semantic HTML: Uses <button> element
✓ ARIA States: aria-disabled, aria-busy
✓ Keyboard: Fully keyboard accessible
✓ Focus: Visible focus indicator
✓ Screen Reader: Loading state announced

[Component: AccessibleModal.tsx]

✓ Focus Management: Traps focus within modal
✓ Keyboard: Escape to close, Tab navigation
✓ ARIA: role="dialog", aria-modal="true"
✓ Focus Restore: Returns focus on close
✓ Screen Reader: Title announced

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ ACCESSIBILITY IMPROVEMENTS NEEDED

[Issue 1] Missing ARIA Label
  Component: IconButton
  Problem: Icon-only button without accessible name

  Current:
  <button><Icon name="close" /></button>

  Fix:
  <button aria-label="Close">
    <Icon name="close" aria-hidden="true" />
  </button>

[Issue 2] Color Contrast
  Element: .secondary-text
  Contrast: 3.8:1 (FAILS AA - need 4.5:1)

  Current: color: #888 on #fff
  Fix: color: #595959 on #fff (7.0:1)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 WCAG 2.1 CHECKLIST

Perceivable:
  ✓ Text alternatives (alt text, aria-label)
  ✓ Color contrast (4.5:1 minimum)
  ✓ Semantic HTML structure
  ✓ Responsive text sizing

Operable:
  ✓ Keyboard accessible
  ✓ No keyboard traps
  ✓ Focus visible
  ✓ Sufficient time for interactions

Understandable:
  ✓ Labels and instructions clear
  ✓ Error messages descriptive
  ✓ Predictable navigation
  ✓ Input assistance provided

Robust:
  ✓ Valid HTML
  ✓ ARIA used correctly
  ✓ Compatible with assistive tech

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Best Practices

1. **Semantic HTML First**: Use correct HTML elements before ARIA
2. **Keyboard Navigation**: All interactive elements keyboard accessible
3. **Focus Management**: Visible focus, logical tab order, focus trapping
4. **ARIA Sparingly**: Only when semantic HTML insufficient
5. **Color Contrast**: Meet WCAG AA minimum (4.5:1 normal, 3:1 large text)
6. **Screen Readers**: Test with NVDA, JAWS, or VoiceOver
7. **Error Messages**: Clear, specific, announced to screen readers
8. **Progressive Enhancement**: Core functionality works without JavaScript

---

**Remember**: Accessibility is not optional - it's a legal requirement (ADA, Section 508) and the right thing to do. Build it in from the start, not as an afterthought.
