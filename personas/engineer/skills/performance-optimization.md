---
name: performance-optimization
description: Analyze and optimize application performance including frontend loading, backend response times, database queries, and resource usage. Use when user mentions performance issues, slow code, optimization needs, or wants to improve speed.
---

# Performance Optimization Skill

Provide comprehensive performance analysis and optimization recommendations for frontend, backend, database, and infrastructure performance issues.

## When to Use This Skill

Automatically invoke when the user:
- Reports slow performance or latency issues
- Asks to optimize code or improve speed
- Mentions "performance", "slow", "bottleneck", or "lag"
- Wants to reduce bundle size or loading time
- Needs database query optimization
- Asks about scaling or efficiency improvements
- Wants to analyze Core Web Vitals

## Performance Optimization Process

Follow this data-driven approach:

### 1. Measure - Establish Baseline

Collect current performance metrics:
- **Response times**: p50, p95, p99 percentiles
- **Throughput**: Requests per second
- **Resource usage**: CPU, memory, disk I/O
- **Error rates**: Failed requests
- **Frontend metrics**: FCP, LCP, TTI, CLS, FID
- **Database**: Query times, connection pool usage

### 2. Analyze - Identify Bottlenecks

Profile and investigate:
- **Profile application**: CPU profiling, memory profiling, flame graphs
- **Identify bottlenecks**: Database, network, CPU, memory, I/O
- **Analyze metrics**: Compare against targets
- **Prioritize issues**: Impact vs effort

### 3. Optimize - Implement Improvements

Make targeted fixes:
- Implement specific optimizations
- Test each change individually
- Measure improvement
- Avoid premature optimization
- Focus on high-impact changes

### 4. Monitor - Track & Prevent Regression

Ensure sustained performance:
- Set up continuous monitoring
- Configure performance alerts
- Track metrics over time
- Prevent performance regression
- Establish performance budgets

## Optimization Areas

### Frontend Performance

#### Loading Performance
- **Bundle size reduction**
  - Code splitting (route-based, component-based)
  - Tree shaking unused code
  - Lazy loading non-critical components
  - Remove duplicate dependencies
  - Use lighter alternatives

- **Resource optimization**
  - Image optimization (WebP, AVIF, lazy loading)
  - Critical CSS extraction
  - Font subsetting and preloading
  - Minification and compression (Gzip, Brotli)

- **Network optimization**
  - Resource hints (prefetch, preload, preconnect)
  - HTTP/2 server push
  - CDN for static assets
  - Cache-Control headers

#### Runtime Performance
- **React optimization**
  - React.memo for expensive components
  - useMemo/useCallback for expensive calculations
  - Virtual scrolling for long lists
  - Avoid unnecessary re-renders
  - Code splitting with React.lazy

- **JavaScript optimization**
  - Debouncing/throttling event handlers
  - Web Workers for heavy computation
  - Avoid layout thrashing
  - Optimize animations (CSS vs JS)

#### Core Web Vitals
- **Largest Contentful Paint (LCP)**: < 2.5s
  - Optimize images, fonts
  - Server-side rendering
  - Reduce render-blocking resources

- **First Input Delay (FID)**: < 100ms
  - Minimize JavaScript execution
  - Break up long tasks
  - Use web workers

- **Cumulative Layout Shift (CLS)**: < 0.1
  - Set image dimensions
  - Avoid inserting content above existing content
  - Use transform for animations

### Backend Performance

#### Application Optimization
- **Algorithm efficiency**: Reduce time complexity
- **Async processing**: Background jobs, message queues
- **Connection pooling**: Reuse database/HTTP connections
- **Caching**: Application-level, Redis, Memcached
- **Compression**: Enable response compression
- **Rate limiting**: Prevent resource exhaustion

#### Database Optimization
- **Query optimization**
  - Analyze slow queries with EXPLAIN
  - Add appropriate indexes
  - Avoid SELECT *, use specific columns
  - Fix N+1 query problems
  - Use JOIN instead of multiple queries

- **Indexing strategies**
  - B-tree indexes for range queries
  - Composite indexes for multi-column filters
  - Covering indexes to avoid table lookups
  - Partial indexes for filtered queries

- **Connection management**
  - Connection pooling
  - Appropriate pool size tuning
  - Query timeout configuration
  - Read replicas for scaling

- **Schema optimization**
  - Appropriate normalization level
  - Partitioning large tables
  - Archiving old data
  - Denormalization where beneficial

#### Caching Strategies
- **Cache-Aside**: Check cache, load on miss, populate cache
- **Write-Through**: Update cache synchronously on write
- **Write-Behind**: Update cache asynchronously
- **TTL Strategy**: Time-based expiration
- **Invalidation**: Event-based cache clearing

### Network Performance

- **HTTP optimization**
  - HTTP/2 or HTTP/3 for multiplexing
  - Keep-Alive connections
  - Request/response compression
  - Reduce payload size

- **API optimization**
  - Batch multiple requests
  - GraphQL for flexible queries
  - Pagination for large datasets
  - Field filtering to reduce payload

- **CDN usage**
  - Edge caching for static content
  - Geographic distribution
  - Cache invalidation strategy

### Memory Optimization

- **Leak prevention**
  - Proper cleanup of event listeners
  - Clear timers and intervals
  - Weak references where appropriate
  - Avoid circular references

- **Efficient data structures**
  - Choose appropriate structures (Map vs Object)
  - Object pooling for frequent allocations
  - Limit in-memory caching

- **Garbage collection**
  - Minimize object creation in hot paths
  - Reuse objects when possible
  - Monitor GC pause times

## Output Format

Provide actionable performance analysis:

```
⚡ PERFORMANCE ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Current Performance Metrics
Response Time: p50=320ms, p95=1.2s, p99=3.5s
Throughput: 150 req/s (target: 500 req/s)
Error Rate: 0.5%
Resource Usage: CPU 65%, Memory 78%
Bundle Size: 2.3MB JavaScript, 450KB CSS
TTI: 4.5s on 3G

🎯 Bottlenecks Identified

1. 🔴 CRITICAL: Database N+1 Queries (60% of response time)
   Location: UserService.getAllWithPosts()
   Issue: 1 + 50 queries per request
   Impact: 1.8s average query time
   Fix:
   ```javascript
   // Before
   const users = await User.findAll();
   const posts = await Promise.all(
     users.map(u => Post.findByUserId(u.id))
   );

   // After - Use eager loading
   const users = await User.findAll({
     include: [{ model: Post }]
   });
   ```
   Expected Gain: -75% query time (450ms → 110ms)

2. 🟠 HIGH: Excessive Bundle Size
   Issue: No code splitting, entire app loaded upfront
   Impact: 4.5s Time to Interactive on 3G
   Fixes:
   • Implement route-based code splitting
   • Lazy load non-critical components
   • Tree-shake unused dependencies (lodash → lodash-es)
   Expected Gain: -60% bundle size, -2.5s TTI

3. 🟠 HIGH: Missing Redis Cache
   Location: ProductPricing.calculate()
   Issue: Complex calculation on every request (200ms)
   Impact: High CPU usage, slow response
   Fix: Redis caching with 1-hour TTL
   Expected Gain: -95% calculation time (200ms → 10ms)

4. 🟡 MEDIUM: Unoptimized Images
   Issue: Serving PNG instead of WebP
   Impact: 800KB extra per page load
   Fix: Convert to WebP with PNG fallback
   Expected Gain: -70% image bandwidth

📋 Optimization Recommendations

IMMEDIATE (< 1 day):
1. Add database indexes on user_id, created_at columns
2. Enable Gzip compression on responses
3. Implement Redis caching for pricing calculations

SHORT-TERM (< 1 week):
4. Fix N+1 queries using DataLoader pattern
5. Implement route-based code splitting
6. Convert images to WebP format
7. Add CDN for static assets
8. Optimize React components with memo

LONG-TERM (< 1 month):
9. Set up database read replicas
10. Implement horizontal scaling strategy
11. Advanced caching layer with invalidation
12. Performance monitoring dashboard

📈 Expected Impact
Response Time: 320ms → 85ms (p50) [-73%]
Throughput: 150 → 600 req/s [+300%]
Bundle Size: 2.3MB → 900KB [-61%]
TTI: 4.5s → 2.0s [-56%]
Error Rate: 0.5% → 0.1% [-80%]

📐 Performance Budgets (Enforce)
Frontend:
  • Bundle Size: < 200KB (JS), < 100KB (CSS)
  • TTI: < 3s on 3G
  • LCP: < 2.5s
  • CLS: < 0.1

Backend:
  • Response Time: p95 < 500ms
  • Throughput: > 500 req/s
  • Error Rate: < 0.1%
  • Database Queries: < 10ms p95

📊 Monitoring Plan
• Set up APM tool (DataDog/New Relic)
• Track Core Web Vitals in production
• Alert on p95 response time > 500ms
• Weekly performance review meetings
• Performance regression CI checks

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Performance Profiling Tools

### Frontend
- **Chrome DevTools**: Lighthouse, Performance tab, Coverage
- **WebPageTest**: Real-world performance testing
- **Bundle Analyzers**: webpack-bundle-analyzer, source-map-explorer
- **Core Web Vitals**: web-vitals library, Chrome UX Report

### Backend
- **APM Tools**: DataDog, New Relic, Dynatrace
- **Profilers**: Node.js profiler, Python cProfile, Java VisualVM
- **Database**: EXPLAIN plans, slow query log, query profilers
- **Load Testing**: k6, Apache JMeter, Gatling

### Monitoring
- **Metrics**: Prometheus, Grafana
- **Tracing**: Jaeger, Zipkin, OpenTelemetry
- **Logs**: ELK stack, Splunk, Papertrail
- **Real User Monitoring**: Google Analytics, Sentry

## Performance Testing

### Load Testing
- Simulate realistic user load
- Measure response times under load
- Identify breaking points
- Test scalability

### Stress Testing
- Push system beyond normal capacity
- Find maximum throughput
- Identify failure modes
- Test recovery

### Benchmarking
- Establish baseline metrics
- Compare before/after optimization
- Track performance over time
- Validate improvements

## Best Practices

1. **Measure First**: Always profile before optimizing
2. **Set Targets**: Define specific performance goals
3. **Prioritize Impact**: Focus on high-impact optimizations
4. **One Change at a Time**: Isolate performance improvements
5. **Monitor Continuously**: Track performance in production
6. **Performance Budget**: Enforce size/time budgets in CI
7. **User-Centric**: Optimize for perceived performance
8. **Document**: Record baselines and improvements
