  # setup-frontend.ps1 - Create all frontend files for pgobi Phase 1

  Write-Host "Creating frontend directory structure..." -ForegroundColor Green

  # Create directories
  New-Item -ItemType Directory -Force -Path "src/components/controls" | Out-Null
  New-Item -ItemType Directory -Force -Path "src/lib" | Out-Null
  New-Item -ItemType Directory -Force -Path "src/stores" | Out-Null
  New-Item -ItemType Directory -Force -Path "src/types" | Out-Null

  # index.html
  @"
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <link rel="icon" type="image/svg+xml" href="/vite.svg" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>pgobi - Multi-dimensional Data Visualization</title>
    </head>
    <body>
      <div id="root"></div>
      <script type="module" src="/src/main.tsx"></script>
    </body>
  </html>
  "@ | Out-File -FilePath "index.html" -Encoding UTF8

  # src/main.tsx
  @"
  import React from 'react'
  import ReactDOM from 'react-dom/client'
  import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
  import App from './App'
  import './index.css'

  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        refetchOnWindowFocus: false,
        retry: 1,
      },
    },
  })

  ReactDOM.createRoot(document.getElementById('root')!).render(
    <React.StrictMode>
      <QueryClientProvider client={queryClient}>
        <App />
      </QueryClientProvider>
    </React.StrictMode>,
  )
  "@ | Out-File -FilePath "src/main.tsx" -Encoding UTF8

  # src/App.tsx
  @"
  import { FileUpload } from './components/controls/FileUpload'
  import { useDataStore } from './stores/dataStore'

  function App() {
    const dataset = useDataStore((state) => state.dataset)

    return (
      <div className="min-h-screen bg-gray-50">
        <header className="bg-white shadow-sm">
          <div className="max-w-7xl mx-auto px-4 py-6">
            <h1 className="text-3xl font-bold text-gray-900">pgobi</h1>
            <p className="text-sm text-gray-600 mt-1">
              Multi-dimensional data visualization tool
            </p>
          </div>
        </header>

        <main className="max-w-7xl mx-auto px-4 py-8">
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-xl font-semibold text-gray-800 mb-4">
              Upload Dataset
            </h2>
            <FileUpload />

            {dataset && (
              <div className="mt-8">
                <h3 className="text-lg font-semibold text-gray-800 mb-4">
                  Dataset Information
                </h3>
                <div className="space-y-4">
                  <div>
                    <span className="font-medium text-gray-700">Filename:</span>{' '}
                    <span className="text-gray-900">{dataset.metadata.filename}</span>
                  </div>
                  <div>
                    <span className="font-medium text-gray-700">Rows:</span>{' '}
                    <span className="text-gray-900">{dataset.metadata.row_count}</span>
                  </div>
                  <div>
                    <span className="font-medium text-gray-700">Columns:</span>{' '}
                    <span className="text-gray-900">{dataset.metadata.column_count}</span>
                  </div>
                  <div>
                    <span className="font-medium text-gray-700 block mb-2">
                      Column Names:
                    </span>
                    <div className="flex flex-wrap gap-2">
                      {dataset.metadata.columns.map((col) => (
                        <span
                          key={col}
                          className="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm"
                        >
                          {col}
                        </span>
                      ))}
                    </div>
                  </div>
                  <div>
                    <span className="font-medium text-gray-700 block mb-2">
                      Data Types:
                    </span>
                    <div className="grid grid-cols-2 gap-2 text-sm">
                      {Object.entries(dataset.metadata.dtypes).map(([col, dtype]) => (
                        <div key={col} className="flex justify-between">
                          <span className="text-gray-600">{col}:</span>
                          <span className="text-gray-900 font-mono">{dtype}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>
        </main>
      </div>
    )
  }

  export default App
  "@ | Out-File -FilePath "src/App.tsx" -Encoding UTF8

  # src/index.css
  @"
  @tailwind base;
  @tailwind components;
  @tailwind utilities;

  :root {
    font-family: Inter, system-ui, Avenir, Helvetica, Arial, sans-serif;
    line-height: 1.5;
    font-weight: 400;

    color-scheme: light;
    color: rgba(17, 24, 39, 0.87);
    background-color: #f9fafb;

    font-synthesis: none;
    text-rendering: optimizeLegibility;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }

  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  body {
    margin: 0;
    display: flex;
    min-width: 320px;
    min-height: 100vh;
  }

  #root {
    width: 100%;
  }
  "@ | Out-File -FilePath "src/index.css" -Encoding UTF8

  # src/types/dataset.ts
  @"
  export interface DatasetMetadata {
    filename: string
    row_count: number
    column_count: number
    columns: string[]
    dtypes: Record<string, string>
  }

  export interface DatasetPreview {
    head: Record<string, unknown>[]
    tail: Record<string, unknown>[]
  }

  export interface Dataset {
    id: string
    metadata: DatasetMetadata
    preview: DatasetPreview
  }

  export interface UploadResponse {
    dataset: Dataset
    message: string
  }
  "@ | Out-File -FilePath "src/types/dataset.ts" -Encoding UTF8

  # src/lib/api.ts
  @"
  import axios from 'axios'
  import type { UploadResponse } from '../types/dataset'

  const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000'

  export const api = axios.create({
    baseURL: API_BASE_URL,
    headers: {
      'Content-Type': 'application/json',
    },
  })

  export async function uploadDataset(file: File): Promise<UploadResponse> {
    const formData = new FormData()
    formData.append('file', file)

    const response = await api.post<UploadResponse>('/api/datasets', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    })

    return response.data
  }
  "@ | Out-File -FilePath "src/lib/api.ts" -Encoding UTF8

  # src/stores/dataStore.ts
  @"
  import { create } from 'zustand'
  import type { Dataset } from '../types/dataset'

  interface DataState {
    dataset: Dataset | null
    setDataset: (dataset: Dataset | null) => void
  }

  export const useDataStore = create<DataState>((set) => ({
    dataset: null,
    setDataset: (dataset) => set({ dataset }),
  }))
  "@ | Out-File -FilePath "src/stores/dataStore.ts" -Encoding UTF8

  # src/components/controls/FileUpload.tsx
  @"
  import { useRef, useState } from 'react'
  import { useMutation } from '@tanstack/react-query'
  import { uploadDataset } from '../../lib/api'
  import { useDataStore } from '../../stores/dataStore'

  export function FileUpload() {
    const fileInputRef = useRef<HTMLInputElement>(null)
    const [selectedFile, setSelectedFile] = useState<File | null>(null)
    const setDataset = useDataStore((state) => state.setDataset)

    const uploadMutation = useMutation({
      mutationFn: uploadDataset,
      onSuccess: (data) => {
        setDataset(data.dataset)
        setSelectedFile(null)
        if (fileInputRef.current) {
          fileInputRef.current.value = ''
        }
      },
    })

    const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
      const file = event.target.files?.[0]
      if (file) {
        setSelectedFile(file)
      }
    }

    const handleUpload = () => {
      if (selectedFile) {
        uploadMutation.mutate(selectedFile)
      }
    }

    return (
      <div className="space-y-4">
        <div className="flex items-center gap-4">
          <input
            ref={fileInputRef}
            type="file"
            accept=".csv"
            onChange={handleFileChange}
            className="block w-full text-sm text-gray-500
              file:mr-4 file:py-2 file:px-4
              file:rounded-md file:border-0
              file:text-sm file:font-semibold
              file:bg-blue-50 file:text-blue-700
              hover:file:bg-blue-100
              cursor-pointer"
          />
          <button
            onClick={handleUpload}
            disabled={!selectedFile || uploadMutation.isPending}
            className="px-6 py-2 bg-blue-600 text-white rounded-md font-medium
              hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500
              disabled:opacity-50 disabled:cursor-not-allowed
              transition-colors"
          >
            {uploadMutation.isPending ? 'Uploading...' : 'Upload'}
          </button>
        </div>

        {uploadMutation.isError && (
          <div className="p-4 bg-red-50 border border-red-200 rounded-md">
            <p className="text-sm text-red-800">
              Error uploading file:{' '}
              {uploadMutation.error instanceof Error
                ? uploadMutation.error.message
                : 'Unknown error'}
            </p>
          </div>
        )}

        {uploadMutation.isSuccess && (
          <div className="p-4 bg-green-50 border border-green-200 rounded-md">
            <p className="text-sm text-green-800">
              Dataset uploaded successfully!
            </p>
          </div>
        )}
      </div>
    )
  }
  "@ | Out-File -FilePath "src/components/controls/FileUpload.tsx" -Encoding UTF8

  # tailwind.config.js
  @"
  /** @type {import('tailwindcss').Config} */
  export default {
    content: [
      "./index.html",
      "./src/**/*.{js,ts,jsx,tsx}",
    ],
    theme: {
      extend: {},
    },
    plugins: [],
  }
  "@ | Out-File -FilePath "tailwind.config.js" -Encoding UTF8

  # postcss.config.js
  @"
  export default {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  }
  "@ | Out-File -FilePath "postcss.config.js" -Encoding UTF8

  # .env.example
  @"
  # API Configuration
  VITE_API_URL=http://localhost:8000
  "@ | Out-File -FilePath ".env.example" -Encoding UTF8

  # .gitignore
  @"
  # Logs
  logs
  *.log
  npm-debug.log*
  yarn-debug.log*
  yarn-error.log*
  pnpm-debug.log*
  lerna-debug.log*

  node_modules
  dist
  dist-ssr
  *.local

  # Editor directories and files
  .vscode/*
  !.vscode/extensions.json
  .idea
  .DS_Store
  *.suo
  *.ntvs*
  *.njsproj
  *.sln
  *.sw?

  # Environment variables
  .env
  .env.local
  "@ | Out-File -FilePath ".gitignore" -Encoding UTF8

  Write-Host "`nFrontend files created successfully!" -ForegroundColor Green
  Write-Host "`nNext steps:" -ForegroundColor Yellow
  Write-Host "1. npm install" -ForegroundColor Cyan
  Write-Host "2. npm install -D tailwindcss postcss autoprefixer" -ForegroundColor Cyan
  Write-Host "3. npm run dev" -ForegroundColor Cyan
