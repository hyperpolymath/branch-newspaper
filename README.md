# Branch Newspaper

[![CI](https://github.com/hyperpolymath/branch-newspaper/actions/workflows/ci.yml/badge.svg)](https://github.com/hyperpolymath/branch-newspaper/actions/workflows/ci.yml)
[![Mirror Sync](https://github.com/hyperpolymath/branch-newspaper/actions/workflows/mirror-sync.yml/badge.svg)](https://github.com/hyperpolymath/branch-newspaper/actions/workflows/mirror-sync.yml)
[![CodeQL](https://github.com/hyperpolymath/branch-newspaper/actions/workflows/codeql.yml/badge.svg)](https://github.com/hyperpolymath/branch-newspaper/actions/workflows/codeql.yml)

A Phoenix LiveView application for managing and distributing meeting minutes with IPFS integration for decentralized content storage.

## Features

- **Meeting Minutes Management** - Create, edit, and organize meeting minutes
- **IPFS Integration** - Store content on IPFS for decentralized, immutable storage
- **Real-time UI** - Phoenix LiveView for instant updates without page reloads
- **Tag Organization** - Categorize minutes with tags for easy discovery

## Tech Stack

| Component | Technology |
|-----------|------------|
| Language | Elixir ~> 1.15 |
| Framework | Phoenix 1.8.1 |
| Real-time | Phoenix LiveView 1.1.0 |
| Database | SQLite3 (dev) / PostgreSQL (prod) |
| Storage | IPFS (Kubo) |
| CSS | Tailwind CSS v4 |

## Prerequisites

- Elixir 1.15+ and Erlang/OTP 25+
- Node.js 18+ (for asset compilation)
- IPFS node (Kubo) running locally or accessible

## Getting Started

### Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/hyperpolymath/branch-newspaper.git
   cd branch-newspaper
   ```

2. **Install dependencies and setup database**
   ```bash
   mix setup
   ```

3. **Start the IPFS daemon** (in a separate terminal)
   ```bash
   ipfs daemon
   ```

4. **Start the Phoenix server**
   ```bash
   mix phx.server
   # Or with interactive Elixir shell:
   iex -S mix phx.server
   ```

5. **Visit the application**

   Open [http://localhost:4000](http://localhost:4000) in your browser.

### Running Tests

```bash
# Run all tests
mix test

# Run with coverage
mix test --cover

# Run the precommit checks (format, compile warnings, tests)
mix precommit
```

### Code Quality

```bash
# Check formatting
mix format --check-formatted

# Run all lint checks
./ci-scripts/lint.sh
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SECRET_KEY_BASE` | Phoenix secret key | (generated) |
| `DATABASE_URL` | Database connection string | SQLite file |
| `PHX_HOST` | Production hostname | localhost |
| `PORT` | HTTP port | 4000 |
| `IPFS_API_URL` | IPFS API endpoint | http://localhost:5001/api/v0 |

See [SECRETS.md](SECRETS.md) for complete secrets documentation.

## Project Structure

```
branch-newspaper/
├── assets/              # Frontend assets (JS, CSS)
├── ci-scripts/          # Shared CI/CD scripts
├── config/              # Application configuration
├── lib/
│   ├── branch_newspaper/        # Business logic
│   │   ├── content/            # Content domain
│   │   └── services/           # External services (IPFS)
│   └── branch_newspaper_web/    # Web interface
│       ├── components/         # UI components
│       ├── controllers/        # HTTP controllers
│       └── live/               # LiveView modules
├── priv/                # Private application files
└── test/                # Test files
```

## Documentation

- [ROADMAP.adoc](ROADMAP.adoc) - Development roadmap and MVP plan
- [TODO.md](TODO.md) - Task backlog and improvements
- [SECRETS.md](SECRETS.md) - Secrets and configuration guide
- [AGENTS.md](AGENTS.md) - AI coding guidelines

## CI/CD

This project uses unified CI/CD that runs on both GitHub Actions and GitLab CI:

- **Lint** - Code formatting and static analysis
- **Test** - ExUnit tests across multiple Elixir versions
- **Build** - Release compilation for deployment
- **Mirror** - Automatic sync between GitHub and GitLab

### Test Matrix

| Elixir | OTP | Status |
|--------|-----|--------|
| 1.15.0 | 25.3 | Minimum supported |
| 1.15.7 | 26.2 | Primary |
| 1.16.0 | 26.2 | Latest |

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Run the precommit checks (`mix precommit`)
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## Repository Mirrors

- **Primary (GitHub)**: https://github.com/hyperpolymath/branch-newspaper
- **Mirror (GitLab)**: https://gitlab.com/maa-framework/3-applications/branch-newspaper

Changes pushed to GitHub are automatically mirrored to GitLab.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Phoenix Framework](https://phoenixframework.org/)
- [IPFS](https://ipfs.tech/)
- Part of the [MAA Framework](https://gitlab.com/maa-framework) project
