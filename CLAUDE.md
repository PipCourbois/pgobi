# pgobi - Modern GGobi Clone

**Multi-dimensional data visualization for exploring high-dimensional datasets**

A web-based reimplementation of [GGobi](http://ggobi.org/), the classic interactive data visualization tool, using modern web technologies.

---

## Quick Start

### First Time Setup

```bash
# Backend setup
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt

# Frontend setup
cd ../frontend
npm install
```

### Development Server

```bash
# Terminal 1: Start Python backend
cd backend
source venv/bin/activate  # Windows: venv\Scripts\activate
uvicorn main:app --reload
# Backend API: http://localhost:8000

# Terminal 2: Start React frontend
cd frontend
npm run dev
# Frontend UI: http://localhost:5173
```

---

## Current Status

**Phase**: Foundation (Phase 1) - 🏗️ **IN PROGRESS**

| Phase | Status | Progress |
|-------|--------|----------|
| Phase 1: Foundation & Data Pipeline | 🏗️ In Progress | 0% |
| Phase 2: Basic Scatterplot with Brushing | ⏳ Pending | 0% |
| Phase 3: Linked Visualizations | ⏳ Pending | 0% |
| Phase 4: Projection & Tour Tools | ⏳ Pending | 0% |
| Phase 5: Advanced Features & Polish | ⏳ Pending | 0% |

**Last Updated**: 2024-10-09

### Current Tasks
- [ ] Backend: FastAPI project structure
- [ ] Backend: CSV upload endpoint
- [ ] Backend: Data parsing with Pandas/NumPy
- [ ] Frontend: React + Vite + TypeScript setup
- [ ] Frontend: File upload component
- [ ] Frontend: Basic state management with Zustand

---

## Architecture

### Tech Stack

**Backend**:
- Python 3.11+
- FastAPI (API server)
- Pandas (data manipulation)
- NumPy (numerical computing)
- scikit-learn (PCA, projections)

**Frontend**:
- TypeScript
- React 18
- Vite (build tool)
- D3.js v7 (custom visualizations)
- Plotly.js (standard charts)
- Zustand (state management)
- Tailwind CSS (styling)

### Project Structure

```
pgobi/
├── backend/              # Python FastAPI server
│   ├── app/
│   │   ├── api/
│   │   │   └── routes/   # API endpoints
│   │   ├── core/         # Config, models
│   │   └── services/     # Business logic
│   ├── main.py           # FastAPI app entry
│   └── requirements.txt
├── frontend/             # React TypeScript app
│   ├── src/
│   │   ├── components/   # React components
│   │   │   ├── plots/    # Visualization components
│   │   │   ├── controls/ # UI controls
│   │   │   └── layout/   # Layout components
│   │   ├── stores/       # Zustand state stores
│   │   ├── lib/          # Utilities, API client
│   │   └── hooks/        # Custom React hooks
│   ├── package.json
│   └── vite.config.ts
├── docs/                 # Documentation
│   ├── session-notes.md  # Session log
│   └── architecture.md   # Design decisions
├── CLAUDE.md             # This file
└── README.md             # User-facing readme
```

---

## Key Features (Planned)

### Core GGobi Features
- ✅ CSV data import
- ✅ 2D scatterplots with zoom/pan
- ✅ Brushing (rectangular selection)
- ✅ Parallel coordinates plots
- ✅ Scatterplot matrices (SPLOM)
- ✅ Linked brushing across multiple plots
- ✅ Color and glyph encoding
- ✅ Grand tour (automated projection exploration)
- ✅ PCA and dimensionality reduction

### Modern Additions
- ✅ Web-based (no installation)
- ✅ Responsive UI
- ✅ Dark/light themes
- ✅ Export visualizations
- ✅ Session save/load
- ✅ WebGL rendering for large datasets

---

## Development Workflow

### Build Commands

```bash
# Backend
cd backend
source venv/bin/activate
python -m pytest                    # Run tests
uvicorn main:app --reload           # Dev server

# Frontend
cd frontend
npm run dev                         # Dev server
npm run build                       # Production build
npm run test                        # Run tests
npm run lint                        # ESLint
npm run type-check                  # TypeScript check
```

### Testing

```bash
# Backend tests
cd backend
pytest tests/

# Frontend tests
cd frontend
npm test
```

---

## Session Continuity

### Starting a New Session

When resuming work after a break:

1. **Check project status**:
   ```bash
   git log -3                    # See recent commits
   cat CLAUDE.md                 # Current status
   cat docs/session-notes.md     # Detailed log
   ```

2. **Say to Claude**: _"Continuing pgobi project - what's our status?"_

3. **Review current phase** (see status table above)

4. **Start development servers** (see Quick Start)

### Ending a Session

Before stopping work:

1. **Update `CLAUDE.md`**:
   - Change phase status (✅/🏗️/⏳)
   - Update progress percentage
   - Add current tasks to list

2. **Add session note** to `docs/session-notes.md`

3. **Commit your work**:
   ```bash
   git add .
   git commit -m "feat: [what you completed]

   - Bullet points of changes
   - What's working
   - What's next

   Next session: [clear next step]"
   ```

4. **Optional**: Use `/ck save` if Context Keeper is available

---

## Next Steps

**Immediate (Phase 1)**:
1. Set up backend FastAPI structure
2. Implement CSV upload endpoint
3. Create React frontend scaffold
4. Build file upload UI component
5. Connect frontend to backend API

**After Phase 1**:
- Phase 2: Basic scatterplot with D3.js
- Phase 3: Multiple linked plots
- Phase 4: Grand tour animations
- Phase 5: Polish and performance

---

## References

- **Original GGobi**: http://ggobi.org/
- **GGobi GitHub**: https://github.com/ggobi/ggobi
- **GGobi Documentation**: http://ggobi.org/docs/manual.pdf

---

## Notes

- **Local-first design**: Works offline, no auth required
- **Cloud-ready**: Architecture supports future multi-user deployment
- **Session-based**: Multiple session development expected
- **Git-driven**: Manual commits for full control

---

**Project Start Date**: 2024-10-09
**Current Session**: Session 1
**Total Sessions**: 1
