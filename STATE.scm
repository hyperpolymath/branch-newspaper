;;; STATE.scm - Branch Newspaper Project State
;;; A checkpoint file for AI conversation continuity using Guile Scheme
;;; Repository: https://github.com/hyperpolymath/branch-newspaper

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SECTION 1: METADATA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-module (state branch-newspaper)
  #:export (state-version
            created-at
            updated-at
            project-focus
            project-catalog
            critical-actions
            blockers
            questions))

(define state-version "1.0.0")
(define created-at "2025-12-08T00:00:00Z")
(define updated-at "2025-12-08T00:00:00Z")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SECTION 2: SESSION CONTEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define session-context
  '((session-id . "claude/create-state-scm-01H7kSozdV5DaE6siNXBBH7i")
    (branch . "claude/create-state-scm-01H7kSozdV5DaE6siNXBBH7i")
    (tokens-remaining . "high")
    (conversation-depth . "initial")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SECTION 3: CURRENT POSITION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define current-position
  '((phase . "pre-implementation")
    (completion . 15)  ; percentage
    (summary . "Infrastructure and CI/CD complete. Application code not yet scaffolded.")

    (completed-work
      ((item . "GitHub repository migration")
       (item . "CI/CD infrastructure (GitHub Actions + GitLab CI)")
       (item . "Comprehensive documentation (README, ROADMAP, TODO)")
       (item . "Dependabot configuration")
       (item . "CodeQL security scanning setup")
       (item . "GitHub <-> GitLab bi-directional mirror sync")
       (item . "Shared CI scripts (lint, test, build, setup)")))

    (not-yet-implemented
      ((item . "Phoenix application scaffolding (no lib/, test/, mix.exs)")
       (item . "Database models and migrations")
       (item . "IPFS client integration")
       (item . "LiveView UI components")
       (item . "API endpoints")
       (item . "Test suite")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SECTION 4: ROUTE TO MVP v1.0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define mvp-roadmap
  '((target-version . "1.0.0")
    (estimated-phases . 4)

    (phase-1
      ((name . "Foundation Setup")
       (status . "pending")
       (tasks
         ((task . "Initialize Phoenix application with mix phx.new")
          (priority . "P0"))
         ((task . "Configure mix.exs with dependencies (Phoenix 1.8.1, LiveView 1.1.0)")
          (priority . "P0"))
         ((task . "Set up SQLite3 for development, PostgreSQL config for production")
          (priority . "P0"))
         ((task . "Remove database files and Kubo binary from git history")
          (priority . "P0"))
         ((task . "Add Credo, Dialyxir, Sobelow to mix.exs")
          (priority . "P1"))
         ((task . "Configure ExCoveralls for coverage reporting")
          (priority . "P1")))))

    (phase-2
      ((name . "Core Features")
       (status . "pending")
       (tasks
         ((task . "Implement Content domain (Minutes schema, context)")
          (priority . "P0"))
         ((task . "Build IPFS client service with retry logic")
          (priority . "P0"))
         ((task . "Create LiveView pages for Minutes CRUD")
          (priority . "P0"))
         ((task . "Implement tag organization system")
          (priority . "P1"))
         ((task . "Add basic search functionality")
          (priority . "P1"))
         ((task . "Date filtering for minutes")
          (priority . "P2")))))

    (phase-3
      ((name . "Production Readiness")
       (status . "pending")
       (tasks
         ((task . "Docker containerization (multi-stage Dockerfile)")
          (priority . "P1"))
         ((task . "Health check endpoints (/health/live, /health/ready)")
          (priority . "P1"))
         ((task . "Structured JSON logging")
          (priority . "P2"))
         ((task . "Prometheus metrics export")
          (priority . "P2"))
         ((task . "Database migration strategy")
          (priority . "P1")))))

    (phase-4
      ((name . "Launch Preparation")
       (status . "pending")
       (tasks
         ((task . "Security audit")
          (priority . "P0"))
         ((task . "Performance testing (<200ms p95 target)")
          (priority . "P1"))
         ((task . "80%+ test coverage")
          (priority . "P0"))
         ((task . "Complete documentation (IPFS guide, API docs)")
          (priority . "P1"))
         ((task . "Production environment setup")
          (priority . "P0")))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SECTION 5: BLOCKERS & ISSUES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define blockers
  '((critical
      ((id . "BLOCK-001")
       (title . "No Phoenix application exists")
       (description . "Repository has CI/CD but no actual application code. Need to run mix phx.new to scaffold.")
       (impact . "Cannot proceed with any feature development")
       (resolution . "Initialize Phoenix project with proper configuration"))

      ((id . "BLOCK-002")
       (title . "Security: Database files in repository")
       (description . "SQLite development files should be removed from git history")
       (impact . "Potential data exposure, repository bloat")
       (resolution . "Use git filter-branch or BFG to clean history")))

    (high
      ((id . "ISSUE-001")
       (title . "Security: Binary files in repository")
       (description . "Kubo IPFS tarball committed to repo instead of downloaded in CI")
       (impact . "Repository bloat, version management issues")
       (resolution . "Remove from history, download in CI setup script"))

      ((id . "ISSUE-002")
       (title . "Missing test infrastructure")
       (description . "No tests exist for any component")
       (impact . "Cannot verify functionality, CI test jobs will fail")
       (resolution . "Write tests as features are implemented")))

    (medium
      ((id . "ISSUE-003")
       (title . "Code quality tools not in mix.exs")
       (description . "Credo, Dialyxir, Sobelow configured in CI but not in project")
       (impact . "CI lint jobs may fail")
       (resolution . "Add dependencies when mix.exs is created"))

      ((id . "ISSUE-004")
       (title . "IPFS error handling incomplete")
       (description . "Need retry logic, timeouts, circuit breaker pattern")
       (impact . "Unreliable IPFS operations")
       (resolution . "Implement robust error handling in IPFS client")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SECTION 6: QUESTIONS FOR PROJECT OWNER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define questions-for-owner
  '((architectural
      ((id . "Q-001")
       (question . "Should the Phoenix app be named BranchNewspaper or something else?")
       (context . "Affects module naming, database tables, and all internal references")
       (default-assumption . "BranchNewspaper"))

      ((id . "Q-002")
       (question . "Preferred IPFS pinning strategy - local node only or also use pinning services (Pinata, web3.storage)?")
       (context . "Affects reliability and cost. Local-only is free but single point of failure.")
       (default-assumption . "Local node with optional pinning service backup"))

      ((id . "Q-003")
       (question . "Should we implement authentication in MVP v1.0 or defer to v1.1?")
       (context . "README mentions deferring auth, but public minutes may need some protection")
       (default-assumption . "Defer to v1.1 per roadmap")))

    (technical
      ((id . "Q-004")
       (question . "Preferred deployment target for MVP - Fly.io, Railway, Render, or self-hosted?")
       (context . "Affects Dockerfile configuration and CI/CD deployment jobs")
       (default-assumption . "Fly.io based on documentation"))

      ((id . "Q-005")
       (question . "Should minutes support rich text (Markdown/HTML) or plain text only for MVP?")
       (context . "Rich text adds complexity but improves usability")
       (default-assumption . "Markdown support for MVP"))

      ((id . "Q-006")
       (question . "Database preference for production - PostgreSQL (standard) or keep SQLite (simpler)?")
       (context . "SQLite works for small scale, PostgreSQL better for growth")
       (default-assumption . "PostgreSQL for production per documentation")))

    (process
      ((id . "Q-007")
       (question . "What is the target launch date or timeline constraint?")
       (context . "Helps prioritize features and make trade-off decisions")
       (default-assumption . "No hard deadline, quality over speed"))

      ((id . "Q-008")
       (question . "Is there an existing IPFS node to integrate with or should we bundle Kubo?")
       (context . "Affects deployment complexity and infrastructure requirements")
       (default-assumption . "Bundle Kubo in Docker, configurable external node")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SECTION 7: LONG-TERM ROADMAP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define long-term-roadmap
  '((v1.0
      ((name . "MVP - Core Meeting Minutes")
       (status . "in-progress")
       (completion . 15)
       (features
         ("Meeting Minutes CRUD operations"
          "IPFS storage integration"
          "LiveView real-time UI"
          "Tag organization"
          "Basic search"
          "Date filtering"))))

    (v1.1
      ((name . "Authentication & Access Control")
       (status . "planned")
       (completion . 0)
       (features
         ("User authentication (phx.gen.auth)"
          "Role-based access control"
          "Audit logging"
          "User preferences"
          "Session management"))))

    (v1.2
      ((name . "Collaboration Features")
       (status . "planned")
       (completion . 0)
       (features
         ("Real-time collaborative editing"
          "Comments and discussions"
          "Email notifications"
          "Mention system"
          "Activity feeds"))))

    (v1.3
      ((name . "API & Integrations")
       (status . "planned")
       (completion . 0)
       (features
         ("REST API"
          "Webhooks"
          "Export formats (PDF, DOCX, HTML)"
          "Calendar integration"
          "Slack/Discord notifications"))))

    (v2.0
      ((name . "Enterprise Features")
       (status . "future")
       (completion . 0)
       (features
         ("Multi-tenancy"
          "Custom branding"
          "Advanced analytics"
          "SSO integration"
          "Compliance features (GDPR, SOC2)"))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SECTION 8: CRITICAL NEXT ACTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define critical-next-actions
  '(((priority . 1)
     (action . "Initialize Phoenix application")
     (command . "mix phx.new branch_newspaper --live --database sqlite3")
     (rationale . "Nothing can proceed without application scaffolding")
     (status . "pending"))

    ((priority . 2)
     (action . "Clean git history of sensitive/large files")
     (command . "Use BFG Repo-Cleaner or git filter-repo")
     (rationale . "Security and repository hygiene")
     (status . "pending"))

    ((priority . 3)
     (action . "Configure mix.exs dependencies")
     (dependencies . ("phoenix ~> 1.8.1"
                      "phoenix_live_view ~> 1.1.0"
                      "ecto_sqlite3 ~> 0.17"
                      "tailwind ~> 0.2"
                      "credo ~> 1.7 (dev)"
                      "dialyxir ~> 1.4 (dev)"
                      "sobelow ~> 0.13 (dev)"))
     (status . "pending"))

    ((priority . 4)
     (action . "Create Content domain")
     (tasks . ("Minutes schema with title, body, date, tags"
               "Content context module"
               "Database migrations"))
     (status . "pending"))

    ((priority . 5)
     (action . "Implement IPFS client service")
     (tasks . ("API wrapper for Kubo"
               "Add/pin/get/unpin operations"
               "Retry logic with exponential backoff"
               "Circuit breaker for resilience"))
     (status . "pending"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SECTION 9: PROJECT CATALOG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define project-catalog
  '((project
      ((name . "branch-newspaper")
       (description . "Decentralized meeting minutes management with IPFS integration")
       (repository . "https://github.com/hyperpolymath/branch-newspaper")
       (mirror . "https://gitlab.com/maa-framework/3-applications/branch-newspaper")
       (status . "in-progress")
       (phase . "pre-implementation")
       (completion . 15)
       (category . "web-application")
       (tech-stack . ("Elixir ~> 1.15"
                      "Phoenix 1.8.1"
                      "Phoenix LiveView 1.1.0"
                      "SQLite3 (dev) / PostgreSQL (prod)"
                      "IPFS (Kubo v0.24.0)"
                      "Tailwind CSS v4"))
       (blockers . ("BLOCK-001" "BLOCK-002"))
       (next-action . "Initialize Phoenix application")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SECTION 10: HISTORY & VELOCITY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define history
  '((snapshot
      ((date . "2025-12-08")
       (completion . 15)
       (milestone . "CI/CD infrastructure complete, STATE.scm created")
       (notes . "Repository migrated to GitHub. All documentation in place. Awaiting Phoenix scaffolding.")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SECTION 11: SUCCESS METRICS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define success-metrics
  '((mvp-criteria
      ((metric . "test-coverage")
       (target . "80%+")
       (current . "0%"))
      ((metric . "security-issues")
       (target . "0 critical/high")
       (current . "2 critical, 2 high"))
      ((metric . "documentation")
       (target . "complete")
       (current . "infrastructure docs complete, API docs pending"))
      ((metric . "uptime")
       (target . "99.5%")
       (current . "N/A - not deployed"))
      ((metric . "response-time-p95")
       (target . "<200ms")
       (current . "N/A"))
      ((metric . "ipfs-success-rate")
       (target . ">99%")
       (current . "N/A")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; USAGE INSTRUCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; To continue from this state in a new Claude session:
;; 1. Upload this file with message: "Continue from this state"
;; 2. Claude will parse the state and resume context
;;
;; To update state at end of session:
;; 1. Request: "Update STATE.scm with current progress"
;; 2. Claude will update completion percentages, blockers, and next actions
;; 3. Download updated file for next session
;;
;; Query examples (conceptual):
;; - (current-focus) -> Returns active project and phase
;; - (blocked-projects) -> Lists all blocked items with reasons
;; - (next-actions) -> Priority-sorted action list

;;; End of STATE.scm
