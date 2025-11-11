import React, { useState } from 'react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ExecutiveDashboard } from './components/ExecutiveDashboard';
import { QualityMetricsPanel } from './components/QualityMetricsPanel';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
      retry: 1,
      staleTime: 60000, // 1 minute
    },
  },
});

type TabType = 'overview' | 'quality' | 'skills' | 'team';

function App() {
  const [activeTab, setActiveTab] = useState<TabType>('overview');

  const tabs: { id: TabType; label: string; icon: string }[] = [
    { id: 'overview', label: 'Overview', icon: '📊' },
    { id: 'quality', label: 'Quality Metrics', icon: '📈' },
    { id: 'skills', label: 'Skill Usage', icon: '⚡' },
    { id: 'team', label: 'Team Performance', icon: '👥' },
  ];

  return (
    <QueryClientProvider client={queryClient}>
      <div className="min-h-screen bg-gray-100">
        {/* Header */}
        <header className="bg-white shadow-md">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex justify-between items-center py-4">
              <div className="flex items-center gap-3">
                <div className="text-3xl">🤖</div>
                <div>
                  <h1 className="text-2xl font-bold text-gray-900">
                    Claude Code Metrics Dashboard
                  </h1>
                  <p className="text-sm text-gray-600">
                    Track skill usage and quality improvements
                  </p>
                </div>
              </div>
              <div className="flex items-center gap-4">
                <span className="flex items-center gap-2 text-sm text-gray-600">
                  <span className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></span>
                  Live
                </span>
              </div>
            </div>
          </div>
        </header>

        {/* Navigation Tabs */}
        <nav className="bg-white border-b">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex gap-1">
              {tabs.map((tab) => (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`flex items-center gap-2 px-6 py-3 font-medium transition-colors ${
                    activeTab === tab.id
                      ? 'text-blue-600 border-b-2 border-blue-600'
                      : 'text-gray-600 hover:text-gray-900'
                  }`}
                >
                  <span>{tab.icon}</span>
                  <span>{tab.label}</span>
                </button>
              ))}
            </div>
          </div>
        </nav>

        {/* Main Content */}
        <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          {activeTab === 'overview' && <ExecutiveDashboard />}
          {activeTab === 'quality' && (
            <div className="space-y-6">
              <QualityMetricsPanel />
            </div>
          )}
          {activeTab === 'skills' && (
            <div className="bg-white rounded-lg shadow-md p-6">
              <h2 className="text-2xl font-bold text-gray-900 mb-4">Skill Usage Analysis</h2>
              <p className="text-gray-600">Skill usage metrics coming soon...</p>
            </div>
          )}
          {activeTab === 'team' && (
            <div className="bg-white rounded-lg shadow-md p-6">
              <h2 className="text-2xl font-bold text-gray-900 mb-4">Team Performance</h2>
              <p className="text-gray-600">Team performance metrics coming soon...</p>
            </div>
          )}
        </main>

        {/* Footer */}
        <footer className="bg-white border-t mt-12">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
            <p className="text-center text-gray-600 text-sm">
              Claude Code Metrics Dashboard v1.0.0 | Made with ❤️ for engineers
            </p>
          </div>
        </footer>
      </div>
    </QueryClientProvider>
  );
}

export default App;
