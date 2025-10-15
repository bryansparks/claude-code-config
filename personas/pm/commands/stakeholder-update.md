# Command: Stakeholder Update

## Purpose
Creates executive summaries, stakeholder communications, and progress updates tailored to audience.

## Usage
```bash
/stakeholder-update [type] [topic or source-file]
```

## What This Command Does

1. Activates **stakeholder-summary.sh** hook
2. Analyzes technical content
3. Translates to business language
4. Tailors to audience (exec, sales, customers)
5. Formats for communication channel (email, presentation, report)

## Update Types

### Executive Summary
```markdown
# Executive Summary: Q1 Product Update

**TL;DR**: Delivered 5 major features, 20% increase in user satisfaction, on track for Q2.

## Key Achievements
- ✅ Guest checkout launched → +15% conversion
- ✅ Mobile app beta → 10k downloads
- ✅ API v2 complete → 50% faster

## Business Impact
- Revenue: +12% QoQ
- Users: +8,000 new users (+25%)
- Churn: Reduced by 5%

## Q2 Focus
- Enterprise features
- International expansion
- Performance optimization
```

### Sprint/Weekly Update
```markdown
# Sprint 42 Update

**Sprint Goal**: Complete user authentication overhaul

**Completion**: 85% (34/40 story points)

**Highlights**:
- ✅ OAuth integration live
- ✅ Password reset flow improved
- 🔄 2FA implementation (carries over)

**Next Sprint**: Mobile app improvements
```

### Stakeholder Email
```markdown
Subject: [FYI] Product Roadmap Update - API v2 Launch

Hi [Name],

**Quick Update**: API v2 successfully launched yesterday with zero downtime.

**Impact on You**:
- 50% faster response times for your integrations
- New features available (see docs)
- No action required (backward compatible)

**What's Next**:
- Migration guide available [link]
- Office hours Thursday 2pm [calendar]
- Questions? Reply or Slack me

Best,
[PM Name]
```

### Board/Investor Update
```markdown
# Board Update: Q4 2024 Product Report

## Product Highlights
- 🚀 Revenue Feature X → $500k ARR impact
- 📈 MAU Growth: 40k → 55k (+37.5%)
- ⭐ NPS: 45 → 52 (+7 points)

## Strategic Progress
✅ Achieved product-market fit in segment Y
✅ Competitive parity on features A, B, C
🔄 International expansion underway

## 2025 Outlook
- Focus: Enterprise customers (2x ACV potential)
- Investment: Mobile + AI features
- Goal: 100k MAU by year-end
```

## Examples

```bash
# Weekly update
/stakeholder-update sprint 42

# Executive summary from feature
/stakeholder-update executive ~/features/api-v2.md

# Email to stakeholder
/stakeholder-update email "API v2 Launch" --urgency=high

# Quarterly roadmap update
/stakeholder-update roadmap Q1-2025

# Custom audience
/stakeholder-update --audience=sales --topic="New Enterprise Features"
```

## Options
- `--audience=[executive|technical|sales|customer]`
- `--format=[email|presentation|report]`
- `--urgency=[high|normal|low]`
- `--tone=[formal|casual]`
- `--output=<file>`

## Audience Customization

### Executive Audience
- Focus: Business impact, ROI, strategic alignment
- Format: Brief, high-level, metrics-driven
- Language: Business terminology

### Technical Audience
- Focus: Architecture, implementation, technical details
- Format: Detailed, includes diagrams
- Language: Technical terminology

### Sales Audience
- Focus: Features, benefits, competitive advantages
- Format: Feature highlights, customer impact
- Language: Value proposition

### Customer Audience
- Focus: Benefits, how to use, what's new
- Format: User-friendly, visual
- Language: Simple, benefit-focused

## Communication Channels

### Email
- Subject line with urgency prefix
- TL;DR upfront
- Clear action items
- Links to details

### Presentation/Deck
- Visual slides
- One point per slide
- Charts and metrics
- Minimal text

### Written Report
- Executive summary
- Detailed sections
- Appendices
- Data/metrics

## Success Criteria
- [ ] Key message clear and concise
- [ ] Audience-appropriate language
- [ ] Action items identified
- [ ] Timeline communicated
- [ ] Impact quantified
- [ ] Next steps defined
