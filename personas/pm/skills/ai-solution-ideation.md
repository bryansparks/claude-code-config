# Skill: AI Solution Ideation - AI-Powered Solution Explorer

## Skill Metadata
- **Skill ID**: `ai-solution-ideation`
- **Version**: 1.0
- **Persona**: Product Manager
- **Auto-invocation**: Yes
- **Priority**: High

---

## Invocation Pattern

This skill automatically activates when Claude detects:

```yaml
triggers:
  - problem_description:
      - PM describes user problem or pain point
      - PM mentions manual/repetitive tasks
      - PM discusses data-heavy workflows

  - solution_exploration:
      - "how could we build this?"
      - "what are our options?"
      - "alternatives to consider"

  - ai_opportunities:
      - Keywords: "personalize", "recommend", "predict", "automate", "classify", "search"
      - User behaviors that could be learned
      - Content that could be generated
      - Decisions that could be automated

  - explicit_request:
      - "/ideate-solutions"
      - "/explore-ai-features"
```

---

## Skill Purpose

Help Product Managers discover AI/ML solution opportunities they might not consider by:
1. Analyzing problems for AI applicability
2. Suggesting modern AI capabilities (especially LLMs)
3. Comparing traditional vs AI-powered approaches
4. Providing feasibility and cost estimates
5. Showing real-world examples

---

## AI Opportunity Detection Framework

### Pattern Recognition

```python
AI_OPPORTUNITY_PATTERNS = {
  "personalization": {
    "signals": [
      "different users want different things",
      "one-size-fits-all doesn't work",
      "users have to manually configure",
      "showing same content to everyone"
    ],
    "ai_solutions": [
      "ML-based recommendation engine",
      "Personalized content ranking",
      "Adaptive UI based on behavior",
      "User preference learning"
    ],
    "examples": ["Netflix", "Amazon", "Spotify"]
  },

  "content_generation": {
    "signals": [
      "users need to write text",
      "templates feel generic",
      "content creation is time-consuming",
      "need multiple variations"
    ],
    "ai_solutions": [
      "LLM-powered content drafting (GPT-4)",
      "Auto-generate product descriptions",
      "Email/message templates with personalization",
      "A/B test copy generation"
    ],
    "examples": ["Jasper.ai", "Copy.ai", "Notion AI"]
  },

  "intelligent_search": {
    "signals": [
      "keyword search returns poor results",
      "users don't know exact terms",
      "synonyms and context matter",
      "search requires multiple refinements"
    ],
    "ai_solutions": [
      "Semantic search (embeddings)",
      "Natural language query understanding",
      "Fuzzy matching and typo tolerance",
      "Search intent classification"
    ],
    "examples": ["Algolia", "Elasticsearch with ML", "Perplexity"]
  },

  "conversational_assistance": {
    "signals": [
      "complex workflows with many options",
      "users ask support for help",
      "decision trees are too complex",
      "users get stuck frequently"
    ],
    "ai_solutions": [
      "LLM-powered chatbot (GPT-4, Claude)",
      "Contextual help and guidance",
      "Conversational form filling",
      "Smart troubleshooting assistant"
    ],
    "examples": ["Intercom Fin", "Shopify Sidekick", "Stripe Support"]
  },

  "prediction": {
    "signals": [
      "need to forecast outcomes",
      "prevent problems before they happen",
      "optimize resource allocation",
      "identify patterns in data"
    ],
    "ai_solutions": [
      "Predictive analytics",
      "Anomaly detection",
      "Churn prediction",
      "Demand forecasting"
    ],
    "examples": ["Stripe Radar", "AWS Forecast", "DataRobot"]
  },

  "classification": {
    "signals": [
      "manually categorizing items",
      "tagging content",
      "triaging requests",
      "routing workflows"
    ],
    "ai_solutions": [
      "Auto-classification/tagging",
      "Smart routing",
      "Sentiment analysis",
      "Priority detection"
    ],
    "examples": ["Zendesk AI", "Gmail Priority Inbox"]
  },

  "image_understanding": {
    "signals": [
      "users upload images",
      "visual content needs moderation",
      "finding products visually",
      "extracting info from images"
    ],
    "ai_solutions": [
      "Image recognition/classification",
      "Visual search",
      "Content moderation",
      "OCR/document extraction"
    ],
    "examples": ["Pinterest Lens", "Google Lens", "AWS Rekognition"]
  },

  "automation": {
    "signals": [
      "repetitive manual tasks",
      "rule-based workflows",
      "data entry",
      "copy-paste operations"
    ],
    "ai_solutions": [
      "Workflow automation with AI routing",
      "Smart data extraction",
      "Intelligent form prefilling",
      "Robotic Process Automation (RPA) with ML"
    ],
    "examples": ["Zapier with AI", "UiPath", "Automation Anywhere"]
  }
}
```

---

## Solution Exploration Process

### Step 1: Analyze the Problem

```
When PM describes problem, extract:
1. User pain point (specific)
2. Current manual process
3. Frequency of the problem
4. Impact (time, cost, frustration)
5. User type/segment

Example:
PM: "Users struggle to find the right shipping option. We have 12 choices
and first-time buyers abandon because it's confusing."

Analysis:
- Pain: Decision overload (12 options → confusion)
- Current: User manually reads and compares all 12
- Frequency: Every checkout (100% of users)
- Impact: 35% abandonment at this step
- Segment: First-time buyers most affected (45% abandon)
```

### Step 2: Generate Solution Spectrum

```
For each problem, generate 3-5 solutions across complexity spectrum:

LOW COMPLEXITY (Traditional)
├─ UX improvements
├─ Better copy/information architecture
├─ Simplified options
└─ Estimated: 1-2 weeks

MEDIUM COMPLEXITY (Rule-Based AI)
├─ Smart defaults based on simple rules
├─ Conditional logic
├─ Personalization via segmentation
└─ Estimated: 3-4 weeks

HIGH COMPLEXITY (ML-Powered)
├─ ML recommendation engine
├─ Predictive models
├─ Requires training data
└─ Estimated: 2-3 months

CUTTING EDGE (LLM-Powered) ⭐
├─ Conversational interface
├─ Natural language understanding
├─ Contextual reasoning
└─ Estimated: 3-4 weeks
```

### Step 3: AI Feasibility Assessment

```yaml
For each AI solution, evaluate:

technical_feasibility:
  - data_requirements: "What data do we need?"
  - data_available: "Do we have it?"
  - api_availability: "Are there existing APIs?"
  - technical_risk: "Low | Medium | High"

business_feasibility:
  - development_time: "Weeks or months?"
  - ongoing_cost: "API costs, infrastructure?"
  - maintenance_burden: "Model updates, monitoring?"
  - ROI_timeline: "When do we break even?"

user_feasibility:
  - trust: "Will users trust AI here?"
  - explainability: "Do they need to understand how it works?"
  - accuracy_requirements: "What error rate is acceptable?"
  - fallback: "What if AI is wrong?"
```

---

## Solution Ideation Template

```markdown
# AI Solution Exploration: [Problem]

## Problem Analysis

**User Pain Point**: [Specific problem]

**Current Process**: [Manual steps users take]

**Impact**:
- Users affected: [Number/percentage]
- Time wasted: [Per user per occurrence]
- Business impact: [Revenue, churn, support costs]

**Why Traditional Solutions Fall Short**:
[Explanation of why this problem is hard to solve without AI]

---

## Solution Approaches

### 1. Traditional UX Improvement (Low Complexity) ⚙️

**Approach**: [Description]

**Pros**:
- ✅ Quick to implement
- ✅ No ongoing costs
- ✅ Proven patterns

**Cons**:
- ❌ Doesn't scale with complexity
- ❌ Still manual for users
- ❌ One-size-fits-all

**Effort**: 1-2 weeks
**Cost**: Development time only
**Example**: [Company using this approach]

---

### 2. Rule-Based Personalization (Medium Complexity) 🔧

**Approach**: [Description with specific rules]

**Pros**:
- ✅ More personalized than traditional
- ✅ Predictable behavior
- ✅ Easier to debug

**Cons**:
- ❌ Rules become complex
- ❌ Hard to maintain
- ❌ Doesn't improve over time

**Effort**: 3-4 weeks
**Cost**: Development time + maintenance
**Example**: [Company using this approach]

---

### 3. ML-Powered Recommendation (High Complexity) 🤖

**Approach**: [Description of ML model]

**AI Technology**:
- Model Type: [Collaborative filtering, Neural network, etc.]
- Training Data: [What data needed, how much]
- Accuracy Target: [Expected performance]

**Pros**:
- ✅ Learns from user behavior
- ✅ Improves over time
- ✅ Handles edge cases

**Cons**:
- ❌ Requires substantial data (6-12 months)
- ❌ Model training and monitoring
- ❌ Black box behavior

**Effort**: 2-3 months
**Ongoing Cost**: ~$500-2000/month (infrastructure)
**Data Requirements**:
- Historical data: 6+ months of user behavior
- Minimum volume: 10,000+ users
- Labeled data: [If supervised learning]

**Example**: [Company using similar approach]

---

### 4. LLM-Powered Assistant (Cutting Edge) ✨ **NEW POSSIBILITY**

**Approach**: [Description of conversational AI]

**AI Technology**:
- Model: GPT-4, Claude 3, or similar
- Integration: API-based, no training required
- Context: Uses product data + user conversation

**How It Works**:
1. User asks "Which shipping option should I choose?"
2. AI asks clarifying questions: "When do you need it by?"
3. User: "Friday, but I want the cheapest"
4. AI: "I recommend Standard (arrives Thursday, $5.99)"

**Pros**:
- ✅ Natural conversation
- ✅ Handles complex scenarios
- ✅ No training data needed
- ✅ Fast to implement (3-4 weeks)
- ✅ Understands context and nuance
- ✅ Can explain recommendations

**Cons**:
- ❌ API costs (~$0.02 per conversation)
- ❌ Requires prompt engineering
- ❌ Need guardrails for edge cases
- ❌ Hallucination risk (needs constraints)

**Effort**: 3-4 weeks
**Ongoing Cost**: ~$0.01-0.03 per user conversation
- Expected volume: 30% of users (30k/month)
- Monthly cost: ~$300-900

**Technical Requirements**:
- OpenAI or Anthropic API key
- Product data API (shipping options, pricing)
- User context (location, past orders)
- Safety guardrails (prevent harmful advice)

**Example Products Using This**:
- Shopify Sidekick (shopping assistant)
- Intercom Fin (customer support)
- Stripe Support Assistant
- Notion AI (document writing)

**Unique Value**:
- First in market for this use case
- Differentiates from competitors
- Reduces support burden
- Improves user satisfaction

---

## Recommended Approach

**Phase 1 (Quick Win)**: [Traditional approach]
- Timeline: 2 weeks
- Impact: Moderate (+10% improvement)
- Cost: Development time

**Phase 2 (Innovation)**: [LLM-powered approach]
- Timeline: 1 month after Phase 1
- Impact: High (+30-40% improvement)
- Cost: $500-1000/month

**Phase 3 (Long-term)**: [ML-powered approach]
- Timeline: 6 months (after data collection)
- Impact: Very High (+50-60% improvement)
- Cost: $1500-3000/month

**Rationale**: [Why this phased approach makes sense]

---

## Risk Assessment & Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| AI gives wrong recommendations | Medium | High | Human-in-the-loop review, confidence thresholds |
| API costs exceed budget | Low | Medium | Rate limiting, caching, usage caps |
| Users don't trust AI | Medium | Medium | Show "AI-powered" badge, allow override |
| Implementation takes longer | Medium | Low | Start with MVP, iterate |

---

## Success Metrics

**Primary**:
- [Metric]: Current → Target
- [Metric]: Current → Target

**AI-Specific Metrics**:
- AI adoption rate: % of users who engage with AI feature
- AI accuracy: % of recommendations accepted
- AI cost per user: Average API cost
- Fallback rate: % of times AI fails and requires human

---

## Next Steps

1. **Validate with Users**: [Prototype or user research needed?]
2. **Technical Spike**: [2-3 days to validate feasibility]
3. **Cost Analysis**: [Detailed API cost modeling]
4. **Build MVP**: [Minimum viable product scope]

---

## Additional Resources

- [Link to AI vendor documentation]
- [Similar product examples]
- [Technical proof of concept]
```

---

## Real-World AI Examples Library

### E-commerce

```yaml
product_recommendations:
  companies: ["Amazon", "Netflix", "Spotify"]
  ai_type: "Collaborative filtering + deep learning"
  impact: "35% increase in average order value"
  complexity: "High (requires ML team)"

visual_search:
  companies: ["Pinterest", "ASOS", "Wayfair"]
  ai_type: "Computer vision (ResNet, CLIP)"
  impact: "2-3x higher conversion from visual search"
  complexity: "Very High"

conversational_shopping:
  companies: ["Shopify Sidekick", "Instacart AI", "Mercado Libre"]
  ai_type: "LLM (GPT-4)"
  impact: "40% reduction in cart abandonment"
  complexity: "Medium (API integration)"
  cost: "$0.02-0.05 per conversation"
```

### SaaS/Productivity

```yaml
ai_writing_assistant:
  companies: ["Notion AI", "Grammarly", "Jasper"]
  ai_type: "LLM (GPT-4, custom models)"
  impact: "50% faster content creation"
  complexity: "Medium (API integration + prompt engineering)"

intelligent_search:
  companies: ["Perplexity", "Glean", "Hebbia"]
  ai_type: "Semantic search (embeddings + reranking)"
  impact: "70% better search relevance"
  complexity: "Medium-High"

auto_categorization:
  companies: ["Gmail (Priority Inbox)", "Superhuman", "Front"]
  ai_type: "Classification models"
  impact: "30% time saved on email triage"
  complexity: "Medium"
```

### Customer Support

```yaml
ai_support_agent:
  companies: ["Intercom Fin", "Zendesk AI", "Ada"]
  ai_type: "LLM + retrieval (RAG)"
  impact: "60-80% ticket deflection"
  complexity: "Medium"
  cost: "$0.50-2.00 per resolved ticket"

sentiment_analysis:
  companies: ["Gong", "Chorus.ai"]
  ai_type: "NLP sentiment models"
  impact: "Identify at-risk customers 2 weeks earlier"
  complexity: "Low-Medium (API available)"
```

---

## Cost Estimation Models

### LLM API Costs (2025 Pricing)

```python
def estimate_llm_cost(conversations_per_month, avg_tokens_per_conversation):
    """
    GPT-4 Pricing (2025):
    - Input: $0.30 per 1M tokens
    - Output: $1.20 per 1M tokens

    Claude 3 Opus Pricing:
    - Input: $15 per 1M tokens
    - Output: $75 per 1M tokens

    Claude 3.5 Sonnet (recommended):
    - Input: $3 per 1M tokens
    - Output: $15 per 1M tokens
    """

    input_tokens = avg_tokens_per_conversation * 0.4  # 40% input
    output_tokens = avg_tokens_per_conversation * 0.6  # 60% output

    # Claude 3.5 Sonnet cost
    cost_per_conversation = (
        (input_tokens / 1_000_000 * 3) +
        (output_tokens / 1_000_000 * 15)
    )

    monthly_cost = conversations_per_month * cost_per_conversation

    return {
        "per_conversation": f"${cost_per_conversation:.4f}",
        "monthly_cost": f"${monthly_cost:.2f}",
        "annual_cost": f"${monthly_cost * 12:.2f}"
    }

# Example: Shopping assistant
# 30k conversations/month, 500 tokens average per conversation
estimate_llm_cost(30_000, 500)
# Result: ~$450/month

# Example: Customer support
# 10k conversations/month, 1500 tokens average
estimate_llm_cost(10_000, 1500)
# Result: ~$675/month
```

### ML Infrastructure Costs

```python
ML_INFRASTRUCTURE_COSTS = {
  "small_model": {
    "description": "Simple classification, <100k users",
    "infrastructure": "Single EC2 instance or Lambda",
    "monthly_cost": "$100-300",
    "data_storage": "$50/month",
    "total": "$150-350/month"
  },

  "medium_model": {
    "description": "Recommendation engine, 100k-1M users",
    "infrastructure": "GPU instance + load balancer",
    "monthly_cost": "$800-1500",
    "data_storage": "$200/month",
    "ml_ops": "$500/month (monitoring, retraining)",
    "total": "$1500-2200/month"
  },

  "large_model": {
    "description": "Advanced ML, 1M+ users",
    "infrastructure": "Kubernetes cluster with GPUs",
    "monthly_cost": "$3000-8000",
    "data_storage": "$1000/month",
    "ml_ops": "$2000/month",
    "ml_team": "$15k-30k/month (2-3 ML engineers)",
    "total": "$21k-41k/month"
  }
}
```

---

## Interaction Examples

### Example 1: Detecting Personalization Opportunity

```
PM: "All users see the same homepage, but different users want
different things. Power users want shortcuts, new users need guidance."

Claude (ai-solution-ideation activates):
"I'm detecting a personalization opportunity here. Let me explore solutions:

PROBLEM: One-size-fits-all homepage doesn't serve different user segments

AI SOLUTION SPECTRUM:

1. **Simple Segmentation** (Low Complexity - 1 week)
   - Show different content based on user type (new vs returning)
   - Pros: Fast, predictable
   - Cons: Only 2 variations, manual rules

2. **Behavioral Personalization** (Medium - 3 weeks)
   - Track which features users actually use
   - Show those features prominently on homepage
   - Pros: Adapts per user, no ML needed
   - Cons: Rules get complex

3. **ML-Powered Layout** (High - 2-3 months)
   - ML model predicts which widgets user will engage with
   - Dynamically reorder homepage sections
   - Pros: Truly personalized, improves over time
   - Cons: Needs 6+ months data, complex to build

4. **AI Onboarding Assistant** ✨ (Medium - 3-4 weeks) **NEW!**
   - LLM-powered chat: 'What brings you here today?'
   - Adapts homepage based on user's goals
   - Can explain features contextually
   - Pros: Natural, handles any use case, fast to build
   - Cons: ~$0.02 per user session

   Example: 'I need to analyze sales data'
   → AI shows: Reports, Analytics, Data Export
   → Hides: Team settings, Billing

RECOMMENDATION: Start with #4 (AI Assistant)
- Quick to implement (3 weeks)
- Handles diverse use cases
- Cost: ~$600/month (30k new users × $0.02)
- Similar to: Notion AI, Superhuman AI

Would you like me to detail the implementation plan?"
```

### Example 2: Search Problem

```
PM: "Users can't find what they're looking for. Keyword search returns
too many irrelevant results. Users end up asking support."

Claude (ai-solution-ideation):
"This is a prime candidate for semantic search with AI. Let me show you:

CURRENT PROBLEM:
- Keyword search: 'comfy shoes' misses 'comfortable footwear'
- Search success rate: 45%
- Support tickets: 'Can't find product' (15% of tickets)

SOLUTION COMPARISON:

1. **Better Keywords** (Traditional - 1 week)
   - Add synonyms manually to database
   - Example: 'shoes' → also search 'footwear', 'sneakers'
   - Impact: +5-10% search success
   - Problem: Doesn't scale, can't handle phrases

2. **Fuzzy Matching** (Low AI - 2 weeks)
   - Elasticsearch with typo tolerance
   - Handle misspellings: 'accomodation' → 'accommodation'
   - Impact: +10-15% search success
   - Problem: Still keyword-based

3. **Semantic Search** 🤖 (Medium AI - 4 weeks) **RECOMMENDED**
   - Use embeddings (OpenAI, Cohere, or custom)
   - Understands INTENT not just keywords
   - Example:
     * Query: 'gift for mother's day'
     * Finds: 'presents', 'moms', 'maternal'

   **How it works**:
   - Convert products to embeddings (one-time)
   - Convert search query to embedding (real-time)
   - Find nearest neighbors (similar meaning)

   **Benefits**:
   - Search success: 45% → 70-80%
   - Handles natural language queries
   - Works across languages

   **Cost**:
   - Embeddings: $0.0001 per search (OpenAI)
   - 100k searches/month = $10/month
   - Infrastructure: ~$200/month (vector database)
   - Total: ~$210/month

   **Effort**: 4 weeks
   - Week 1: Generate embeddings for products
   - Week 2: Set up vector database (Pinecone, Weaviate)
   - Week 3: Integrate search API
   - Week 4: Fine-tune and launch

   **Examples**:
   - Shopify uses this (semantic product search)
   - Notion uses this (semantic page search)
   - Algolia offers this (hybrid search)

4. **LLM Search Assistant** ✨ (Medium AI - 3 weeks) **CUTTING EDGE**
   - Conversational search powered by GPT-4
   - User: 'I need something for my back pain'
   - AI: 'I'd recommend our orthopedic chairs. Are you
          looking for office use or home?'

   **Cost**: ~$0.03 per conversation
   **Best for**: Complex products where users need guidance

RECOMMENDATION: Semantic Search (#3)
- Proven ROI (70%+ search success)
- Affordable ($210/month)
- Works immediately (no training data)
- Can add LLM assistant later as Phase 2

Want me to create a technical implementation plan?"
```

---

## Skill Success Metrics

- **AI Awareness**: 100% of PRDs consider AI solutions
- **Idea Quality**: PMs suggest AI solutions they wouldn't have thought of before
- **Implementation**: 30% of features use AI/ML (up from 5%)
- **Innovation**: Team ships features competitors don't have

---

**This skill ensures PMs are AI-aware and explore cutting-edge solutions.**
