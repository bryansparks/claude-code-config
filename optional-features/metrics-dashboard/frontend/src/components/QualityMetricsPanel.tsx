import React, { useEffect, useState } from 'react';
import { getQualityTrend, QualityTrend } from '../services/api';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import { format, parseISO } from 'date-fns';

interface Props {
  repositoryId?: string;
}

export const QualityMetricsPanel: React.FC<Props> = ({ repositoryId }) => {
  const [trend, setTrend] = useState<QualityTrend[]>([]);
  const [loading, setLoading] = useState(true);
  const [period, setPeriod] = useState<'7d' | '30d' | '90d'>('30d');
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadTrendData();
  }, [repositoryId, period]);

  const loadTrendData = async () => {
    try {
      setLoading(true);
      const response = await getQualityTrend(repositoryId, period);
      setTrend(response.data);
      setError(null);
    } catch (err) {
      setError('Failed to load quality trend data');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="text-gray-600">Loading quality metrics...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="text-red-600">{error}</div>
      </div>
    );
  }

  // Format data for chart
  const chartData = trend.map((item) => ({
    date: format(parseISO(item.date), 'MMM dd'),
    quality: parseFloat(item.avg_quality_score.toFixed(1)),
    functional: parseFloat(item.avg_functional_suitability.toFixed(1)),
    performance: parseFloat(item.avg_performance_efficiency.toFixed(1)),
    security: parseFloat(item.avg_security.toFixed(1)),
    maintainability: parseFloat(item.avg_maintainability.toFixed(1)),
  }));

  const latestScore = trend.length > 0 ? trend[trend.length - 1].avg_quality_score : 0;

  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h2 className="text-2xl font-bold text-gray-900">Quality Score Trend</h2>
          <p className="text-gray-600">ISO/IEC 25010 Quality Model</p>
        </div>
        <div className="flex items-center gap-4">
          <div className="text-right">
            <p className="text-3xl font-bold text-blue-600">{latestScore.toFixed(1)}/100</p>
            <p className="text-sm text-gray-600">Current Score</p>
          </div>
          <div className="flex gap-2">
            <button
              onClick={() => setPeriod('7d')}
              className={`px-3 py-1 rounded ${
                period === '7d' ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-700'
              }`}
            >
              7D
            </button>
            <button
              onClick={() => setPeriod('30d')}
              className={`px-3 py-1 rounded ${
                period === '30d' ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-700'
              }`}
            >
              30D
            </button>
            <button
              onClick={() => setPeriod('90d')}
              className={`px-3 py-1 rounded ${
                period === '90d' ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-700'
              }`}
            >
              90D
            </button>
          </div>
        </div>
      </div>

      {/* Chart */}
      <div className="h-96">
        <ResponsiveContainer width="100%" height="100%">
          <LineChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis
              dataKey="date"
              style={{ fontSize: '12px' }}
            />
            <YAxis
              domain={[0, 100]}
              style={{ fontSize: '12px' }}
            />
            <Tooltip
              contentStyle={{
                backgroundColor: 'rgba(255, 255, 255, 0.95)',
                border: '1px solid #ccc',
                borderRadius: '4px',
              }}
            />
            <Legend />
            <Line
              type="monotone"
              dataKey="quality"
              name="Overall Quality"
              stroke="#3b82f6"
              strokeWidth={3}
              dot={{ r: 4 }}
            />
            <Line
              type="monotone"
              dataKey="functional"
              name="Functional Suitability"
              stroke="#10b981"
              strokeWidth={2}
              strokeDasharray="5 5"
            />
            <Line
              type="monotone"
              dataKey="performance"
              name="Performance"
              stroke="#f59e0b"
              strokeWidth={2}
              strokeDasharray="5 5"
            />
            <Line
              type="monotone"
              dataKey="security"
              name="Security"
              stroke="#ef4444"
              strokeWidth={2}
              strokeDasharray="5 5"
            />
            <Line
              type="monotone"
              dataKey="maintainability"
              name="Maintainability"
              stroke="#8b5cf6"
              strokeWidth={2}
              strokeDasharray="5 5"
            />
            {/* Target line */}
            <Line
              type="monotone"
              dataKey={() => 85}
              name="Target (85)"
              stroke="#6b7280"
              strokeWidth={1}
              strokeDasharray="10 5"
              dot={false}
            />
          </LineChart>
        </ResponsiveContainer>
      </div>

      {/* Quality Characteristics Grid */}
      <div className="mt-6 grid grid-cols-2 md:grid-cols-4 gap-4">
        {trend.length > 0 && (
          <>
            <MetricCard
              title="Functional"
              score={trend[trend.length - 1].avg_functional_suitability}
              target={90}
              color="green"
            />
            <MetricCard
              title="Performance"
              score={trend[trend.length - 1].avg_performance_efficiency}
              target={85}
              color="yellow"
            />
            <MetricCard
              title="Security"
              score={trend[trend.length - 1].avg_security}
              target={85}
              color="red"
            />
            <MetricCard
              title="Maintainability"
              score={trend[trend.length - 1].avg_maintainability}
              target={80}
              color="purple"
            />
          </>
        )}
      </div>
    </div>
  );
};

interface MetricCardProps {
  title: string;
  score: number;
  target: number;
  color: 'green' | 'yellow' | 'red' | 'purple';
}

const MetricCard: React.FC<MetricCardProps> = ({ title, score, target, color }) => {
  const colorMap = {
    green: 'bg-green-50 text-green-700 border-green-200',
    yellow: 'bg-yellow-50 text-yellow-700 border-yellow-200',
    red: 'bg-red-50 text-red-700 border-red-200',
    purple: 'bg-purple-50 text-purple-700 border-purple-200',
  };

  const isAboveTarget = score >= target;

  return (
    <div className={`border rounded-lg p-4 ${colorMap[color]}`}>
      <p className="text-sm font-medium">{title}</p>
      <p className="text-2xl font-bold mt-1">{score.toFixed(1)}</p>
      <p className="text-xs mt-1">
        Target: ≥{target} {isAboveTarget ? '✓' : '⚠️'}
      </p>
    </div>
  );
};
