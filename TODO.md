# Branch Newspaper - TODO List

This document outlines improvements, missing tests, documentation gaps, and technical debt identified during the repository migration and analysis.

## Priority Legend
- **P0** - Critical: Blocks deployment or has security implications
- **P1** - High: Important for production readiness
- **P2** - Medium: Improves quality and maintainability
- **P3** - Low: Nice to have improvements

---

## Security Issues (P0)

### Database Files in Repository
- [ ] **Remove SQLite database files from version control**
  - Files: `branch_newspaper_dev.db`, `branch_newspaper_dev.db-shm`, `branch_newspaper_dev.db-wal`
  - Impact: May contain sensitive test data, increases repository size
  - Fix: Add to `.gitignore`, remove from history using `git filter-branch` or BFG

### Binary Files in Repository
- [ ] **Remove Kubo binary tarball from repository**
  - File: `kubo_v0.24.0_linux-amd64.tar.gz`
  - Impact: Large binary, version-specific, increases clone time
  - Fix: Document download instructions, add to `.gitignore`, use CI to fetch

### Secrets Configuration
- [ ] **Configure production secrets properly**
  - Ensure `SECRET_KEY_BASE` is set via environment variable
  - Verify IPFS endpoint configuration is externalized
  - Add secrets documentation for deployment

---

## Missing Tests (P1)

### Services Layer
- [ ] **Add tests for `BranchNewspaper.Services.IpfsClient`**
  - File: `lib/branch_newspaper/services/ipfs_client.ex`
  - Coverage needed:
    - `add_content/1` - success and error cases
    - `get_content/1` - content retrieval and not found
    - `pin_content/1` - pinning behavior
  - Consider: Mock Tesla adapter for unit tests

### Web Layer
- [ ] **Add tests for remaining controllers**
  - Review coverage in `test/branch_newspaper_web/controllers/`
  - Ensure API endpoints have integration tests

### Application Layer
- [ ] **Add tests for `BranchNewspaper.Application`**
  - Verify supervision tree starts correctly
  - Test graceful shutdown behavior

---

## Missing Documentation (P1)

### User Documentation
- [ ] **Update README.md with comprehensive setup instructions**
  - Current README is minimal boilerplate
  - Add: Prerequisites, environment setup, configuration
  - Add: IPFS/Kubo setup instructions
  - Add: Development workflow

### API Documentation
- [ ] **Document IPFS integration**
  - Expected IPFS node configuration
  - Content addressing scheme
  - Pin management strategy

### Architecture Documentation
- [ ] **Create ARCHITECTURE.md**
  - System components overview
  - Data flow diagrams
  - IPFS integration patterns
  - Phoenix LiveView patterns used

---

## Code Quality Improvements (P2)

### Static Analysis
- [ ] **Add Credo for static code analysis**
  ```elixir
  # Add to mix.exs deps
  {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
  ```

- [ ] **Add Dialyxir for type checking**
  ```elixir
  {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
  ```

- [ ] **Add Sobelow for security scanning**
  ```elixir
  {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false}
  ```

### Code Coverage
- [ ] **Add ExCoveralls for coverage reporting**
  ```elixir
  {:excoveralls, "~> 0.18", only: :test}
  ```

### Error Handling
- [ ] **Improve IPFS client error handling**
  - Add retry logic for transient failures
  - Add timeout configuration
  - Implement circuit breaker pattern

---

## CI/CD Enhancements (P2)

### GitHub Actions
- [ ] **Enable coverage reporting to Codecov/Coveralls**
- [ ] **Add Dialyzer to CI pipeline** (after adding dialyxir)
- [ ] **Add release publishing workflow** for tagged releases
- [ ] **Configure branch protection rules**
  - Require CI to pass before merge
  - Require code review

### Performance
- [ ] **Optimize CI caching strategy**
  - Cache PLT files for Dialyzer
  - Consider using GitHub Actions cache v4 features

### Security Scanning
- [ ] **Enable GitHub Advanced Security features**
  - CodeQL is configured but verify it runs correctly
  - Add secret scanning alerts

---

## Feature Improvements (P3)

### IPFS Integration
- [ ] **Add content verification after IPFS upload**
- [ ] **Implement content deduplication**
- [ ] **Add IPFS cluster support for redundancy**

### UI/UX
- [ ] **Add loading states for IPFS operations**
- [ ] **Implement optimistic updates in LiveView**
- [ ] **Add pagination for minutes listing**

### API
- [ ] **Add REST API for external integrations**
- [ ] **Implement GraphQL endpoint** (optional)
- [ ] **Add rate limiting**

---

## Infrastructure (P3)

### Deployment
- [ ] **Create Docker configuration**
  - Multi-stage Dockerfile for minimal image
  - docker-compose for local development with IPFS

- [ ] **Add Kubernetes manifests** (if needed)
  - Deployment, Service, ConfigMap, Secret templates

### Monitoring
- [ ] **Add Prometheus metrics export**
- [ ] **Configure structured logging**
- [ ] **Add health check endpoints**

---

## Repository Housekeeping (P3)

### Git History
- [ ] **Clean up large binary files from history**
  - Use BFG Repo-Cleaner or git filter-repo
  - Affects: kubo tarball, SQLite files

### Documentation Files
- [ ] **Review and update CODE_OF_CONDUCT.md**
- [ ] **Update SECURITY.md with vulnerability reporting process**
- [ ] **Add CONTRIBUTING.md**

### Workflows
- [ ] **Remove unused workflow files**
  - Review `jekyll-gh-pages.yml` necessity

---

## Completed Items

- [x] Set up GitHub Actions CI workflow
- [x] Set up GitLab CI configuration
- [x] Configure Dependabot for dependency updates
- [x] Create shared CI scripts
- [x] Set up push mirroring workflow
- [x] Add mirror verification script
- [x] Configure CodeQL security scanning

---

## Notes

### GitLab Migration Status
The original repository is at `gitlab.com/maa-framework/3-applications/branch-newspaper`. The migration to GitHub is configured for event-driven push mirroring.

**Important**: GitLab currently blocks HTTP git access. To complete the code migration:
1. Configure SSH deploy key on GitLab
2. Run manual sync using `ci-scripts/mirror-push.sh`
3. Verify with `ci-scripts/verify-mirror.sh`

### Elixir Version Compatibility
- **Minimum**: Elixir 1.15.0 / OTP 25.3
- **Primary**: Elixir 1.15.7 / OTP 26.2
- **Latest tested**: Elixir 1.16.0 / OTP 26.2

---

*Generated during repository migration on $(date +%Y-%m-%d)*
*Last updated: 2025-12-08*
