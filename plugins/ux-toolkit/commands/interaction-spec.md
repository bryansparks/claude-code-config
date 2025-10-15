---
description: Interaction and animation specifications
---

**Purpose**: Interaction and animation specifications

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Create interaction specifications for $ARGUMENTS"

Design and document micro-interactions, animations, transitions, and delightful user feedback.

## Usage Examples
- `/interaction-spec --component Button --hover-states`
- `/interaction-spec --page /checkout --transitions`
- `/interaction-spec --analyze animations --performance`
- `/interaction-spec --create loading-states --skeleton`

## Command-Specific Flags
--component: "Specify component for interactions"
--page: "Specify page for transitions"
--analyze: "Analyze existing interactions"
--create: "Create new interaction specs"
--hover-states: "Define hover/focus states"
--transitions: "Define page/state transitions"
--performance: "Check animation performance"
--skeleton: "Create skeleton loading specs"
--reduced-motion: "Verify reduced-motion support"

## Interaction Principles

### Purpose Over Decoration
Every animation must:
- ✅ Communicate state change
- ✅ Provide feedback
- ✅ Guide attention
- ✅ Enhance understanding
- ❌ Not be gratuitous decoration

### Performance First
- ✅ 60fps minimum
- ✅ GPU-accelerated properties only (transform, opacity)
- ❌ Avoid animating: width, height, top, left, margin
- ✅ Use will-change sparingly
- ✅ Respect prefers-reduced-motion

### Timing & Easing
- Fast UI: 100-200ms (instant feedback)
- Medium: 200-300ms (transitions)
- Slow: 300-500ms (complex/dramatic)
- Easing: ease-out (natural deceleration)

## Output Format

```
⚡ INTERACTION SPECIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Component: Button
Type: Primary Action Button
Design System: v2.4.0

STATE TRANSITIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Idle State] → [Hover]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Trigger: Mouse enter, focus (keyboard)
Duration: 100ms
Easing: ease-out

Visual Changes:
  • Background: darken by 5% (hover), lighten by 10% (focus)
  • Scale: 1.0 → 1.02
  • Shadow: elevation 2 → elevation 4
  • Cursor: pointer

Code Implementation:
```css
.button {
  background: var(--color-primary-500);
  transform: scale(1);
  box-shadow: var(--shadow-sm);
  transition: all 100ms ease-out;
}

.button:hover {
  background: var(--color-primary-600);
  transform: scale(1.02);
  box-shadow: var(--shadow-md);
}

.button:focus-visible {
  background: var(--color-primary-400);
  outline: 3px solid var(--color-primary-300);
  outline-offset: 2px;
}
```

Motion Tokens:
  • Duration: tokens.duration.fast (100ms)
  • Easing: tokens.easing.out
  • Shadow: tokens.shadows.sm → tokens.shadows.md

[Hover] → [Active (Click)]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Trigger: Mouse down, Enter/Space key
Duration: 50ms
Easing: ease-in

Visual Changes:
  • Scale: 1.02 → 0.98 (pressed effect)
  • Shadow: elevation 4 → elevation 1
  • Optional: Ripple effect from click point

Code Implementation:
```css
.button:active {
  transform: scale(0.98);
  box-shadow: var(--shadow-xs);
  transition: all 50ms ease-in;
}
```

Ripple Effect (Optional):
```javascript
function createRipple(event) {
  const button = event.currentTarget;
  const ripple = document.createElement('span');

  // Calculate ripple position
  const rect = button.getBoundingClientRect();
  const x = event.clientX - rect.left;
  const y = event.clientY - rect.top;

  ripple.style.left = `${x}px`;
  ripple.style.top = `${y}px`;
  ripple.classList.add('ripple');

  button.appendChild(ripple);

  // Remove after animation
  setTimeout(() => ripple.remove(), 600);
}
```

```css
.ripple {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.4);
  width: 20px;
  height: 20px;
  animation: ripple-animation 600ms ease-out;
  pointer-events: none;
}

@keyframes ripple-animation {
  from {
    transform: scale(0);
    opacity: 1;
  }
  to {
    transform: scale(20);
    opacity: 0;
  }
}
```

[Active] → [Success State]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Trigger: Async action completed successfully
Duration: 300ms
Easing: cubic-bezier(0.16, 1, 0.3, 1) (ease-out-expo)

Visual Changes:
  • Background: primary → success green
  • Icon: spinner → checkmark
  • Scale: brief pulse (1.0 → 1.1 → 1.0)
  • Optional: Confetti burst (if delightful context)

Code Implementation:
```css
.button--success {
  background: var(--color-success-500);
  transition: background 300ms cubic-bezier(0.16, 1, 0.3, 1);
}

@keyframes success-pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
}

.button--success {
  animation: success-pulse 400ms ease-out;
}
```

Icon Transition:
```javascript
// Crossfade spinner to checkmark
spinner.style.opacity = 0; // 150ms fade out
setTimeout(() => {
  spinner.remove();
  checkmark.style.opacity = 0;
  button.appendChild(checkmark);
  checkmark.style.opacity = 1; // 150ms fade in
}, 150);
```

[Any State] → [Disabled]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Trigger: Disabled prop set
Duration: 150ms
Easing: ease-out

Visual Changes:
  • Opacity: 1.0 → 0.6
  • Cursor: pointer → not-allowed
  • Background: desaturated
  • All interactions disabled

Code Implementation:
```css
.button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  pointer-events: none;
  transition: opacity 150ms ease-out;
}
```

LOADING STATE INTERACTION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Idle] → [Loading]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Trigger: Async action started
Duration: 200ms (fade in spinner)
Easing: ease-out

Visual Changes:
  • Button text: fade out (200ms)
  • Spinner: fade in (200ms, delay 100ms)
  • Button: slightly expand width to accommodate spinner
  • Button: disabled during loading

Code Implementation:
```css
.button--loading {
  position: relative;
}

.button__text--loading {
  opacity: 0;
  transition: opacity 200ms ease-out;
}

.button__spinner {
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  opacity: 0;
  transition: opacity 200ms ease-out 100ms;
}

.button--loading .button__spinner {
  opacity: 1;
}
```

Spinner Animation:
```css
@keyframes spin {
  from {
    transform: translate(-50%, -50%) rotate(0deg);
  }
  to {
    transform: translate(-50%, -50%) rotate(360deg);
  }
}

.button__spinner {
  animation: spin 800ms linear infinite;
}
```

MICRO-INTERACTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Icon Button Hover:
  • Icon scale: 1.0 → 1.15
  • Icon color: subtle shift
  • Duration: 100ms
  • Easing: ease-out

Icon-only Button Click:
  • Icon rotate: 0deg → 360deg (e.g., refresh icon)
  • Duration: 400ms
  • Easing: ease-out
  • Happens on click

Favorite Button Toggle:
  • Empty heart → Filled heart
  • Scale pulse: 1.0 → 1.3 → 1.0
  • Color: gray → red
  • Duration: 400ms
  • Easing: cubic-bezier(0.16, 1, 0.3, 1)
  • Optional: Particle burst

Add to Cart Success:
  • Button: "Add to Cart" → "Added!"
  • Checkmark appears
  • Cart icon (header): bounce + badge increment
  • Duration: 2s (then revert)

ACCESSIBILITY CONSIDERATIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Reduced Motion Support:
```css
@media (prefers-reduced-motion: reduce) {
  .button,
  .button * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

Keyboard Navigation:
✅ Focus indicator: 3px outline with 2px offset
✅ Focus visible on Tab (not on click)
✅ Enter/Space triggers click
✅ Tab order logical

Screen Reader Announcements:
```html
<!-- Loading state -->
<button aria-busy="true" aria-live="polite">
  <span aria-hidden="true">Loading...</span>
  <span class="sr-only">Saving your changes</span>
</button>

<!-- Success state -->
<button aria-live="polite">
  <span aria-hidden="true">Saved!</span>
  <span class="sr-only">Your changes have been saved successfully</span>
</button>
```

PERFORMANCE CHECKLIST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ GPU-Accelerated Properties:
  • transform: translateX/Y/Z, scale, rotate
  • opacity
  • filter (use sparingly)

❌ Avoid (Triggers Layout/Paint):
  • width, height
  • top, left, right, bottom
  • margin, padding
  • border-width

✅ will-change Hints:
  • Use on hover: will-change: transform
  • Remove after animation complete
  • Don't overuse (memory cost)

✅ 60fps Target:
  • Monitor with Chrome DevTools Performance tab
  • Look for jank (missed frames)
  • Simplify if dropping below 60fps

IMPLEMENTATION CHECKLIST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Button Interactions:
- [ ] Idle state defined
- [ ] Hover state (100ms ease-out)
- [ ] Focus state (visible 3px outline)
- [ ] Active/press state (50ms ease-in)
- [ ] Loading state (spinner, disabled)
- [ ] Success state (checkmark, color change)
- [ ] Error state (shake, red)
- [ ] Disabled state (0.6 opacity)
- [ ] Reduced motion support
- [ ] Screen reader announcements
- [ ] Keyboard accessible (Enter/Space)
- [ ] 60fps performance verified

MOTION DESIGN TOKENS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Duration Tokens:
```javascript
const duration = {
  instant: '50ms',     // Immediate feedback
  fast: '100ms',       // UI state changes
  normal: '200ms',     // Standard transitions
  slow: '300ms',       // Emphasized transitions
  slower: '400ms',     // Complex animations
  slowest: '500ms',    // Page transitions
};
```

Easing Tokens:
```javascript
const easing = {
  linear: 'linear',
  in: 'cubic-bezier(0.4, 0, 1, 1)',           // Accelerating
  out: 'cubic-bezier(0, 0, 0.2, 1)',          // Decelerating
  inOut: 'cubic-bezier(0.4, 0, 0.2, 1)',      // Smooth
  outExpo: 'cubic-bezier(0.16, 1, 0.3, 1)',   // Dramatic exit
  spring: 'cubic-bezier(0.34, 1.56, 0.64, 1)', // Bouncy
};
```

STORYBOOK DOCUMENTATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Create interactive stories for:
1. All button states (idle, hover, active, focus)
2. Loading state transition
3. Success state animation
4. Error state animation
5. Reduced motion version
6. Keyboard interaction demo

Example Storybook Story:
```javascript
export const InteractiveStates = () => {
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);

  const handleClick = () => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      setSuccess(true);
      setTimeout(() => setSuccess(false), 2000);
    }, 2000);
  };

  return (
    <Button
      onClick={handleClick}
      loading={loading}
      success={success}
    >
      {success ? 'Saved!' : 'Save Changes'}
    </Button>
  );
};
```

NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Review interaction specs with design team
2. Implement button states with motion tokens
3. Add Storybook stories for all states
4. Test with keyboard navigation
5. Verify 60fps performance
6. Test with prefers-reduced-motion
7. Get feedback from users
8. Document in design system

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 Resources:
- Material Design Motion: https://m3.material.io/styles/motion
- Apple HIG Motion: https://developer.apple.com/design/human-interface-guidelines/motion
- Framer Motion: https://www.framer.com/motion/
- GSAP: https://greensock.com/gsap/
```

## Animation Patterns Library

**Common Patterns:**
1. **Fade In/Out**: Opacity transitions
2. **Slide**: Transform translateX/Y
3. **Scale**: Transform scale
4. **Rotate**: Transform rotate
5. **Pulse**: Scale up and down
6. **Shake**: Horizontal oscillation (errors)
7. **Bounce**: Easing with overshoot
8. **Ripple**: Expanding circle from point
9. **Skeleton**: Pulsing gradient (loading)
10. **Confetti**: Particle burst (celebration)

## Collaboration

**Led by:**
- **interaction-designer**: Animation and interaction specs

**Supports:**
- **ui-component-reviewer**: Component state review
- **accessibility-specialist**: Reduced motion and screen readers
- **design-system-expert**: Motion token standardization
- **frontend-engineers**: Implementation and performance

Focus on creating delightful, purposeful, performant, and accessible interactions that enhance the user experience.
