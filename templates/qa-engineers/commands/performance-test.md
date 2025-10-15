**Purpose**: Run performance and load tests to ensure application scalability

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Run performance tests for $ARGUMENTS"

Execute comprehensive performance testing including load tests, stress tests, and performance profiling to ensure the application meets performance requirements.

## Usage Examples
- `/performance-test --load --users 100 --duration 5m`
- `/performance-test --lighthouse --url https://app.example.com`
- `/performance-test --stress --breakpoint`
- `/performance-test --spike --users "0,100,500,100,0"`
- `/performance-test --profile --page /dashboard`

## Command-Specific Flags
--load: "Run load test with sustained user load"
--stress: "Run stress test to find breaking point"
--spike: "Run spike test with sudden traffic bursts"
--soak: "Run soak test for extended duration (stability)"
--lighthouse: "Run Lighthouse performance audit"
--profile: "Profile application performance"
--users: "Number of virtual users (default: 50)"
--duration: "Test duration (e.g., 5m, 1h)"
--ramp: "Ramp-up time to reach target users"
--breakpoint: "Continue until system breaks"
--url: "URL to test"
--page: "Specific page to profile"
--api: "Test API endpoints only"
--report: "Generate detailed performance report"
--baseline: "Save/compare against performance baseline"
--ci: "Run in CI mode with stricter thresholds"

## Performance Testing Types

**1. Load Testing:**
- Test under expected load
- Verify normal operation
- Measure response times
- Target: 95th percentile < 500ms

**2. Stress Testing:**
- Push beyond normal capacity
- Find breaking point
- Identify bottlenecks
- Observe graceful degradation

**3. Spike Testing:**
- Sudden traffic increases
- Test auto-scaling
- Cache effectiveness
- Recovery time

**4. Soak Testing:**
- Extended duration (hours/days)
- Memory leak detection
- Resource exhaustion
- Stability verification

**5. Scalability Testing:**
- Horizontal scaling
- Vertical scaling
- Database performance
- Cache efficiency

## Performance Testing Process

**1. Planning:**
- Define performance goals
- Identify critical user journeys
- Set success criteria
- Determine test scenarios

**2. Baseline Establishment:**
- Run tests in clean environment
- Record baseline metrics
- Document system configuration
- Save for comparison

**3. Test Execution:**
- Start with load test
- Progress to stress test
- Run spike scenarios
- Execute soak test

**4. Analysis:**
- Review response times
- Check error rates
- Identify bottlenecks
- Correlate metrics

**5. Optimization:**
- Implement fixes
- Retest to verify
- Update baseline
- Document changes

## Output Format

The performance-test command provides:
1. **Test Configuration**: Users, duration, ramp-up
2. **Response Time Metrics**: p50, p95, p99 percentiles
3. **Throughput**: Requests per second
4. **Error Rate**: Percentage of failed requests
5. **Resource Usage**: CPU, memory, network
6. **Bottleneck Analysis**: System constraints
7. **Recommendations**: Optimization suggestions
8. **Baseline Comparison**: Performance regression check

## Key Performance Metrics

**Core Web Vitals:**
```
LCP (Largest Contentful Paint):
  Good: < 2.5s
  Needs Improvement: 2.5s - 4.0s
  Poor: > 4.0s

FID (First Input Delay):
  Good: < 100ms
  Needs Improvement: 100ms - 300ms
  Poor: > 300ms

CLS (Cumulative Layout Shift):
  Good: < 0.1
  Needs Improvement: 0.1 - 0.25
  Poor: > 0.25
```

**Backend Metrics:**
```
Response Time:
  Excellent: < 100ms
  Good: 100ms - 300ms
  Acceptable: 300ms - 500ms
  Slow: > 500ms

Error Rate:
  Excellent: < 0.1%
  Good: 0.1% - 0.5%
  Acceptable: 0.5% - 1%
  Poor: > 1%

Throughput:
  Measured in requests/second
  Compare against requirements
```

## Load Testing Example (k6)

```javascript
// load-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

const errorRate = new Rate('errors');

export const options = {
  stages: [
    { duration: '2m', target: 100 },   // Ramp up to 100 users
    { duration: '5m', target: 100 },   // Stay at 100 users
    { duration: '2m', target: 200 },   // Ramp up to 200 users
    { duration: '5m', target: 200 },   // Stay at 200 users
    { duration: '2m', target: 0 },     // Ramp down to 0 users
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],  // 95% of requests < 500ms
    http_req_failed: ['rate<0.01'],    // Error rate < 1%
    errors: ['rate<0.01'],
  },
};

export default function() {
  // Homepage
  let response = http.get('https://app.example.com');

  const result = check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });

  errorRate.add(!result);

  sleep(1);

  // API call
  response = http.get('https://app.example.com/api/products');

  check(response, {
    'api status is 200': (r) => r.status === 200,
    'api response time < 300ms': (r) => r.timings.duration < 300,
  });

  sleep(2);
}
```

## Lighthouse Performance Audit

```bash
# Run Lighthouse
lighthouse https://app.example.com \
  --only-categories=performance \
  --output=json \
  --output-path=./perf-report.json \
  --chrome-flags="--headless"

# With specific device
lighthouse https://app.example.com \
  --preset=desktop \
  --throttling.cpuSlowdownMultiplier=1

# Mobile simulation
lighthouse https://app.example.com \
  --preset=mobile \
  --emulated-form-factor=mobile
```

## Performance Profiling

**Chrome DevTools Profiling:**
1. Open DevTools (F12)
2. Performance tab
3. Start recording
4. Perform user actions
5. Stop recording
6. Analyze flame graph

**Key Indicators:**
- Long tasks (> 50ms)
- Layout shifts
- JavaScript execution time
- Render blocking resources
- Main thread blocking

## Common Bottlenecks

**1. Database Queries:**
```
Symptoms:
  • High response time variability
  • Slow page loads
  • Increased error rate under load

Solutions:
  • Add database indexes
  • Optimize N+1 queries
  • Implement query caching
  • Use connection pooling
```

**2. Unoptimized Assets:**
```
Symptoms:
  • Large bundle sizes
  • Slow initial page load
  • High bandwidth usage

Solutions:
  • Code splitting
  • Image optimization (WebP, compression)
  • Minification and bundling
  • CDN for static assets
```

**3. Memory Leaks:**
```
Symptoms:
  • Memory usage increases over time
  • Application crashes after hours
  • Degraded performance over time

Solutions:
  • Fix event listener leaks
  • Clear intervals/timeouts
  • Proper cleanup in unmount
  • Monitor heap snapshots
```

**4. API Rate Limiting:**
```
Symptoms:
  • 429 errors under load
  • Requests queued/delayed
  • Inconsistent response times

Solutions:
  • Implement request queuing
  • Add caching layer
  • Optimize API usage
  • Increase rate limits
```

## Output Example

```
Performance Load Test Report
===========================

Test Configuration:
  Tool: k6
  Target: https://app.example.com
  Virtual Users: 100 → 200
  Duration: 16 minutes
  Test Type: Load Test

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RESULTS SUMMARY

Total Requests:    48,532
Failed Requests:   73 (0.15%) ✓
Duration:          16m 0s
Throughput:        50.5 req/sec

Response Time:
  Average:         187ms ✓
  Median (p50):    165ms ✓
  p95:            421ms ✓
  p99:            687ms ⚠
  Max:            2,340ms

Status: ✓ PASSED (all thresholds met)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PERFORMANCE BREAKDOWN

By Endpoint:
  GET /
    Requests:   16,177
    p95:       234ms ✓
    Errors:    0.02%

  GET /api/products
    Requests:   16,177
    p95:       389ms ✓
    Errors:    0.12%

  GET /api/user/profile
    Requests:   16,178
    p95:       678ms ⚠
    Errors:    0.31%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PERFORMANCE UNDER LOAD

100 VUs (5 min sustained):
  Avg Response:  165ms
  Error Rate:    0.08%
  Throughput:    33 req/sec

200 VUs (5 min sustained):
  Avg Response:  256ms
  Error Rate:    0.23%
  Throughput:    50 req/sec

Scalability: ✓ Linear scaling up to 200 VUs

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

BOTTLENECK ANALYSIS

⚠ User Profile API (p95: 678ms)
  Issue: Slow database query
  Impact: Affects 5% of requests
  Recommendation: Add index on user_id column

⚠ High p99 Latency (687ms)
  Issue: Occasional slow responses
  Impact: Poor UX for 1% of requests
  Recommendation: Investigate slow queries

✓ No Error Rate Issues
  All endpoints < 1% error rate

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

LIGHTHOUSE AUDIT (Homepage)

Performance Score: 89/100 ✓

Metrics:
  FCP:  1.2s ✓
  LCP:  1.8s ✓
  TBT:  180ms ✓
  CLS:  0.05 ✓
  SI:   2.1s ✓

Opportunities:
  • Eliminate render-blocking resources (-320ms)
  • Minify JavaScript (-120ms)
  • Use WebP images (-240KB)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RECOMMENDATIONS

High Priority:
  [ ] Optimize user profile query (add index)
  [ ] Investigate p99 latency spikes
  [ ] Implement API response caching

Medium Priority:
  [ ] Eliminate render-blocking CSS
  [ ] Optimize images (convert to WebP)
  [ ] Code split main bundle

Low Priority:
  [ ] Implement service worker caching
  [ ] Add resource hints (prefetch/preload)
  [ ] Optimize font loading

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

BASELINE COMPARISON

                Current    Baseline   Change
Response (p95)  421ms      389ms      +8.2% ⚠
Error Rate      0.15%      0.12%      +0.03% ✓
Throughput      50.5/s     48.2/s     +4.8% ✓

Verdict: Minor performance regression acceptable

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next Steps:
  1. Optimize user profile API
  2. Monitor p99 latency in production
  3. Schedule stress test to find breaking point
  4. Update baseline after optimizations
```

## CI/CD Integration

```yaml
# .github/workflows/performance.yml
name: Performance Tests

on: [pull_request]

jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Lighthouse CI
        run: |
          npm install -g @lhci/cli
          lhci autorun

  load-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run k6 load test
        uses: grafana/k6-action@v0.3.0
        with:
          filename: tests/load-test.js
          cloud: true
          token: ${{ secrets.K6_CLOUD_TOKEN }}
```

## Performance Budgets

```json
{
  "budgets": [
    {
      "path": "/*",
      "resourceSizes": [
        { "resourceType": "total", "budget": 2048 },
        { "resourceType": "script", "budget": 500 },
        { "resourceType": "image", "budget": 800 },
        { "resourceType": "stylesheet", "budget": 100 }
      ],
      "timings": [
        { "metric": "interactive", "budget": 3800 },
        { "metric": "first-contentful-paint", "budget": 1800 },
        { "metric": "largest-contentful-paint", "budget": 2500 }
      ]
    }
  ]
}
```
