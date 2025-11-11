import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3001/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor
api.interceptors.request.use(
  (config) => {
    // Add auth token if available
    const token = localStorage.getItem('auth_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Handle unauthorized access
      localStorage.removeItem('auth_token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// API Functions

export interface SkillInvocation {
  id: string;
  skill_id: string;
  skill_name: string;
  skill_display_name: string;
  user_id: string;
  user_email: string;
  user_name: string;
  repository_id?: string;
  repository_name?: string;
  branch?: string;
  commit_sha?: string;
  trigger_method: 'manual' | 'automatic';
  duration_seconds?: number;
  tokens_used?: number;
  status: 'success' | 'error' | 'partial';
  created_at: string;
}

export interface SkillStats {
  id: string;
  name: string;
  display_name: string;
  category: string;
  invocation_count: number;
  unique_users: number;
  avg_duration: number;
  success_count: number;
  error_count: number;
}

export interface QualityTrend {
  date: string;
  avg_quality_score: number;
  avg_functional_suitability: number;
  avg_performance_efficiency: number;
  avg_security: number;
  avg_maintainability: number;
}

export interface TestCoverageTrend {
  date: string;
  avg_coverage_statements: number;
  avg_coverage_branches: number;
  avg_coverage_functions: number;
  avg_coverage_lines: number;
  avg_total_tests: number;
  avg_execution_time: number;
}

export interface SecurityTrend {
  date: string;
  avg_security_score: number;
  total_critical: number;
  total_high: number;
  total_medium: number;
  total_low: number;
}

export interface AccessibilityTrend {
  date: string;
  avg_wcag_score: number;
  total_level_a: number;
  total_level_aa: number;
  total_level_aaa: number;
}

export interface DashboardSummary {
  skillAdoption: {
    active_users: number;
    total_users: number;
    adoption_rate: number;
  };
  quality: {
    avg_quality_score: number;
  };
  testCoverage: {
    avg_coverage: number;
  };
  security: {
    avg_security_score: number;
    critical_vulns: number;
    high_vulns: number;
  };
  accessibility: {
    avg_wcag_score: number;
    level_a_violations: number;
    level_aa_violations: number;
  };
  alerts: {
    critical_alerts: number;
    high_alerts: number;
    medium_alerts: number;
  };
}

// Skill Invocations
export const getSkillInvocations = async (params?: {
  page?: number;
  limit?: number;
  skill_id?: string;
  user_id?: string;
  repository_id?: string;
  start_date?: string;
  end_date?: string;
}) => {
  const response = await api.get<{ data: SkillInvocation[]; pagination: any }>(
    '/skill-invocations',
    { params }
  );
  return response.data;
};

export const recordSkillInvocation = async (data: Partial<SkillInvocation>) => {
  const response = await api.post<{ data: SkillInvocation }>(
    '/skill-invocations',
    data
  );
  return response.data;
};

export const getSkillStats = async (period: '7d' | '30d' | '90d' = '30d') => {
  const response = await api.get<{ data: SkillStats[]; period: string }>(
    '/skill-invocations/stats',
    { params: { period } }
  );
  return response.data;
};

// Metrics
export const getQualityTrend = async (
  repositoryId?: string,
  period: '7d' | '30d' | '90d' = '30d'
) => {
  const response = await api.get<{ data: QualityTrend[]; period: string }>(
    '/metrics/quality-trend',
    { params: { repository_id: repositoryId, period } }
  );
  return response.data;
};

export const getTestCoverageTrend = async (
  repositoryId?: string,
  branch: string = 'main',
  period: '7d' | '30d' | '90d' = '30d'
) => {
  const response = await api.get<{ data: TestCoverageTrend[]; period: string; branch: string }>(
    '/metrics/test-coverage-trend',
    { params: { repository_id: repositoryId, branch, period } }
  );
  return response.data;
};

export const getSecurityTrend = async (
  repositoryId?: string,
  period: '7d' | '30d' | '90d' = '30d'
) => {
  const response = await api.get<{ data: SecurityTrend[]; period: string }>(
    '/metrics/security-trend',
    { params: { repository_id: repositoryId, period } }
  );
  return response.data;
};

export const getAccessibilityTrend = async (
  repositoryId?: string,
  period: '7d' | '30d' | '90d' = '30d'
) => {
  const response = await api.get<{ data: AccessibilityTrend[]; period: string }>(
    '/metrics/accessibility-trend',
    { params: { repository_id: repositoryId, period } }
  );
  return response.data;
};

export const getDashboardSummary = async (teamId?: string) => {
  const response = await api.get<{ data: DashboardSummary }>(
    '/metrics/dashboard-summary',
    { params: { team_id: teamId } }
  );
  return response.data;
};

export default api;
