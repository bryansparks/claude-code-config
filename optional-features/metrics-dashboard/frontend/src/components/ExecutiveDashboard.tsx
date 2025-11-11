import React, { useEffect, useState } from 'react';
import { getDashboardSummary, DashboardSummary } from '../services/api';
import { LineChart, Line, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

export const ExecutiveDashboard: React.FC = () => {
  const [summary, setSummary] = useState<DashboardSummary | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadDashboardData();
    // Refresh every 60 seconds
    const interval = setInterval(loadDashboardData, 60000);
    return () => clearInterval(interval);
  }, []);

  const loadDashboardData = async () => {
    try {
      setLoading(true);
      const response = await getDashboardSummary();
      setSummary(response.data);
      setError(null);
    } catch (err) {
      setError('Failed to load dashboard data');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  if (loading && !summary) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-gray-600">Loading dashboard...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-red-50 border border-red-200 rounded-lg p-4">
        <p className="text-red-800">{error}</p>
        <button
          onClick={loadDashboardData}
          className="mt-2 px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
        >
          Retry
        </button>
      </div>
    );
  }

  if (!summary) return null;

  const getScoreColor = (score: number, target: number) => {
    if (score >= target) return 'text-green-600';
    if (score >= target * 0.9) return 'text-yellow-600';
    return 'text-red-600';
  };

  const getProgressBarColor = (score: number, target: number) => {
    if (score >= target) return 'bg-green-500';
    if (score >= target * 0.9) return 'bg-yellow-500';
    return 'bg-red-500';
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <h1 className="text-3xl font-bold text-gray-900">Team Performance Dashboard</h1>
        <p className="text-gray-600 mt-2">Last 30 Days</p>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {/* Skill Adoption */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <div className="flex items-center justify-between">
            <h3 className="text-sm font-medium text-gray-600">Skill Adoption</h3>
            <span className="text-2xl">👥</span>
          </div>
          <div className="mt-4">
            <p className={`text-3xl font-bold ${getScoreColor(summary.skillAdoption.adoption_rate, 80)}`}>
              {summary.skillAdoption.adoption_rate.toFixed(1)}%
            </p>
            <p className="text-sm text-gray-600 mt-2">
              {summary.skillAdoption.active_users} / {summary.skillAdoption.total_users} engineers
            </p>
            <div className="mt-3 bg-gray-200 rounded-full h-2">
              <div
                className={`h-2 rounded-full ${getProgressBarColor(summary.skillAdoption.adoption_rate, 80)}`}
                style={{ width: `${Math.min(summary.skillAdoption.adoption_rate, 100)}%` }}
              />
            </div>
            <p className="text-xs text-gray-500 mt-2">Target: ≥80%</p>
          </div>
        </div>

        {/* Overall Quality */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <div className="flex items-center justify-between">
            <h3 className="text-sm font-medium text-gray-600">Overall Quality</h3>
            <span className="text-2xl">📊</span>
          </div>
          <div className="mt-4">
            <p className={`text-3xl font-bold ${getScoreColor(summary.quality.avg_quality_score, 85)}`}>
              {summary.quality.avg_quality_score.toFixed(0)}/100
            </p>
            <p className="text-sm text-gray-600 mt-2">ISO/IEC 25010 Score</p>
            <div className="mt-3 bg-gray-200 rounded-full h-2">
              <div
                className={`h-2 rounded-full ${getProgressBarColor(summary.quality.avg_quality_score, 85)}`}
                style={{ width: `${summary.quality.avg_quality_score}%` }}
              />
            </div>
            <p className="text-xs text-gray-500 mt-2">Target: ≥85</p>
          </div>
        </div>

        {/* Test Coverage */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <div className="flex items-center justify-between">
            <h3 className="text-sm font-medium text-gray-600">Test Coverage</h3>
            <span className="text-2xl">🧪</span>
          </div>
          <div className="mt-4">
            <p className={`text-3xl font-bold ${getScoreColor(summary.testCoverage.avg_coverage, 90)}`}>
              {summary.testCoverage.avg_coverage.toFixed(1)}%
            </p>
            <p className="text-sm text-gray-600 mt-2">Code Coverage</p>
            <div className="mt-3 bg-gray-200 rounded-full h-2">
              <div
                className={`h-2 rounded-full ${getProgressBarColor(summary.testCoverage.avg_coverage, 90)}`}
                style={{ width: `${summary.testCoverage.avg_coverage}%` }}
              />
            </div>
            <p className="text-xs text-gray-500 mt-2">Target: ≥90%</p>
          </div>
        </div>

        {/* Security Posture */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <div className="flex items-center justify-between">
            <h3 className="text-sm font-medium text-gray-600">Security Posture</h3>
            <span className="text-2xl">🔒</span>
          </div>
          <div className="mt-4">
            <p className={`text-3xl font-bold ${getScoreColor(summary.security.avg_security_score, 90)}`}>
              {summary.security.avg_security_score.toFixed(0)}/100
            </p>
            <div className="flex gap-4 text-sm mt-2">
              <span className={summary.security.critical_vulns > 0 ? 'text-red-600' : 'text-green-600'}>
                🔴 {summary.security.critical_vulns}
              </span>
              <span className={summary.security.high_vulns > 10 ? 'text-orange-600' : 'text-green-600'}>
                🟠 {summary.security.high_vulns}
              </span>
            </div>
            <div className="mt-3 bg-gray-200 rounded-full h-2">
              <div
                className={`h-2 rounded-full ${getProgressBarColor(summary.security.avg_security_score, 90)}`}
                style={{ width: `${summary.security.avg_security_score}%` }}
              />
            </div>
            <p className="text-xs text-gray-500 mt-2">Target: ≥90</p>
          </div>
        </div>
      </div>

      {/* Secondary Metrics */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Accessibility */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Accessibility (WCAG)</h3>
            <span className="text-2xl">♿</span>
          </div>
          <div className="space-y-3">
            <div>
              <div className="flex justify-between items-center mb-1">
                <span className="text-sm text-gray-600">Compliance Score</span>
                <span className={`text-lg font-bold ${getScoreColor(summary.accessibility.avg_wcag_score, 95)}`}>
                  {summary.accessibility.avg_wcag_score.toFixed(1)}%
                </span>
              </div>
              <div className="bg-gray-200 rounded-full h-2">
                <div
                  className={`h-2 rounded-full ${getProgressBarColor(summary.accessibility.avg_wcag_score, 95)}`}
                  style={{ width: `${summary.accessibility.avg_wcag_score}%` }}
                />
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4 pt-3 border-t">
              <div>
                <p className="text-2xl font-bold text-red-600">{summary.accessibility.level_a_violations}</p>
                <p className="text-xs text-gray-600">Level A Violations</p>
              </div>
              <div>
                <p className="text-2xl font-bold text-orange-600">{summary.accessibility.level_aa_violations}</p>
                <p className="text-xs text-gray-600">Level AA Violations</p>
              </div>
            </div>
          </div>
        </div>

        {/* Active Alerts */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Active Alerts</h3>
            <span className="text-2xl">🚨</span>
          </div>
          <div className="space-y-3">
            <div className="flex items-center justify-between p-3 bg-red-50 rounded-lg">
              <div className="flex items-center gap-3">
                <span className="text-2xl">🔴</span>
                <div>
                  <p className="font-semibold text-red-900">Critical</p>
                  <p className="text-sm text-red-700">Immediate action required</p>
                </div>
              </div>
              <span className="text-2xl font-bold text-red-600">{summary.alerts.critical_alerts}</span>
            </div>
            <div className="flex items-center justify-between p-3 bg-orange-50 rounded-lg">
              <div className="flex items-center gap-3">
                <span className="text-2xl">🟠</span>
                <div>
                  <p className="font-semibold text-orange-900">High</p>
                  <p className="text-sm text-orange-700">Address within 24h</p>
                </div>
              </div>
              <span className="text-2xl font-bold text-orange-600">{summary.alerts.high_alerts}</span>
            </div>
            <div className="flex items-center justify-between p-3 bg-yellow-50 rounded-lg">
              <div className="flex items-center gap-3">
                <span className="text-2xl">🟡</span>
                <div>
                  <p className="font-semibold text-yellow-900">Medium</p>
                  <p className="text-sm text-yellow-700">Address within week</p>
                </div>
              </div>
              <span className="text-2xl font-bold text-yellow-600">{summary.alerts.medium_alerts}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
