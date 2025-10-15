---
description: Performance optimization and bottleneck resolution
---

**Purpose**: Performance optimization and bottleneck resolution

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Optimize [target] for performance in $ARGUMENTS"

Analyze and improve application performance through profiling, optimization, and best practices.

## Usage Examples
- `/optimize --database --query "getUsersWithPosts"`
- `/optimize --frontend --bundle-size`
- `/optimize --api --endpoint "/users" --target-p95 200ms`
- `/optimize --memory --detect-leaks`

## Command-Specific Flags
--database: "Optimize database queries and schema"
--frontend: "Optimize client-side performance"
--backend: "Optimize server-side performance"
--api: "Optimize API endpoints"
--bundle-size: "Reduce JavaScript bundle size"
--memory: "Optimize memory usage and detect leaks"
--query: "Specific database query to optimize"
--endpoint: "Specific API endpoint to optimize"
--target-p95: "Target 95th percentile response time"
--profile: "Analyze performance profile data"
--cache: "Implement caching strategies"
--algorithm: "Optimize algorithm complexity"

## Optimization Categories

**Database Optimization:**
- Add missing indexes
- Optimize query structure
- Fix N+1 query problems
- Implement query result caching
- Use connection pooling
- Add database read replicas

**Frontend Optimization:**
- Code splitting (route-based, component-based)
- Lazy loading (images, components, routes)
- Bundle size reduction (tree-shaking, compression)
- Caching strategies (service workers, HTTP cache)
- Image optimization (WebP, lazy loading, responsive)
- CSS optimization (critical CSS, purge unused)

**Backend Optimization:**
- Algorithm complexity improvement
- Caching layer (Redis, Memcached)
- Async processing (background jobs)
- Connection pooling
- Response compression
- Horizontal scaling preparation

**Memory Optimization:**
- Leak detection and fixing
- Object pooling
- Garbage collection tuning
- Reference cleanup
- Data structure optimization

## Performance Analysis

**Profiling:**
```bash
# Frontend profiling
- Chrome DevTools Performance tab
- Lighthouse CI
- Web Vitals monitoring

# Backend profiling
- Node.js --prof flag
- Python cProfile
- Go pprof
```

**Key Metrics:**
- Response time (p50, p95, p99)
- Throughput (requests/second)
- Error rate
- Resource utilization (CPU, memory)
- Database query time
- Network latency

## Optimization Techniques

**1. Database Query Optimization:**
```sql
-- Before: N+1 problem
SELECT * FROM users;
-- Then for each user:
SELECT * FROM posts WHERE user_id = ?;

-- After: JOIN
SELECT users.*, posts.*
FROM users
LEFT JOIN posts ON posts.user_id = users.id;
```

**2. Caching:**
```javascript
// Before: Repeated calculation
app.get('/pricing', () => {
    const price = complexCalculation(); // 200ms
    return price;
});

// After: Cached result
const cache = new Redis();
app.get('/pricing', async () => {
    let price = await cache.get('pricing');
    if (!price) {
        price = complexCalculation();
        await cache.set('pricing', price, 'EX', 3600);
    }
    return price;
});
```

**3. Code Splitting:**
```javascript
// Before: Large bundle (2.3MB)
import HeavyComponent from './Heavy';

// After: Lazy loading
const HeavyComponent = lazy(() => import('./Heavy'));
// Bundle size: 400KB initial, 200KB deferred
```

**4. Algorithm Optimization:**
```javascript
// Before: O(n²)
function findDuplicates(arr) {
    for (let i = 0; i < arr.length; i++) {
        for (let j = i + 1; j < arr.length; j++) {
            if (arr[i] === arr[j]) return true;
        }
    }
}

// After: O(n)
function findDuplicates(arr) {
    const seen = new Set();
    for (const item of arr) {
        if (seen.has(item)) return true;
        seen.add(item);
    }
}
```

## Performance Budget

**Frontend Targets:**
- Bundle size: < 200KB (JS), < 100KB (CSS)
- Time to Interactive: < 3s on 3G
- First Contentful Paint: < 1.5s
- Largest Contentful Paint: < 2.5s
- Cumulative Layout Shift: < 0.1

**Backend Targets:**
- Response time p95: < 500ms
- Response time p99: < 1s
- Throughput: > 1000 req/s
- Error rate: < 0.1%
- Database query p95: < 10ms

## Output Format

The optimize command provides:
1. **Performance Analysis**: Current metrics and bottlenecks
2. **Optimization Recommendations**: Prioritized list of improvements
3. **Before/After Comparison**: Expected performance gains
4. **Implementation Plan**: Step-by-step optimization approach
5. **Measurement Strategy**: How to verify improvements
6. **Monitoring Setup**: Ongoing performance tracking

## Optimization Workflow

**1. Measure:**
- Establish baseline metrics
- Profile application
- Identify bottlenecks

**2. Prioritize:**
- Impact vs effort analysis
- Focus on biggest bottlenecks
- Quick wins first

**3. Optimize:**
- Implement targeted fixes
- One optimization at a time
- Measure after each change

**4. Verify:**
- Confirm improvements
- No regressions
- Update monitoring

**5. Monitor:**
- Track metrics over time
- Alert on regressions
- Continuous improvement
