# Secrets Configuration

This document lists all secrets required for the Branch Newspaper application and CI/CD pipelines.

## GitHub Secrets

Configure these in: **Settings → Secrets and variables → Actions**

### Required Secrets

| Secret Name | Description | Used By | How to Obtain |
|-------------|-------------|---------|---------------|
| `GITLAB_SSH_KEY` | SSH private key for GitLab push access | `mirror-sync.yml`, `ci.yml` | See [GitLab SSH Key Setup](#gitlab-ssh-key-setup) |

### Optional Secrets (for enhanced features)

| Secret Name | Description | Used By | How to Obtain |
|-------------|-------------|---------|---------------|
| `CODECOV_TOKEN` | Token for uploading coverage reports | `ci.yml` (if coverage enabled) | [codecov.io](https://codecov.io) → Settings |
| `DOCKERHUB_USERNAME` | Docker Hub username for image publishing | Deployment workflows | [hub.docker.com](https://hub.docker.com) account |
| `DOCKERHUB_TOKEN` | Docker Hub access token | Deployment workflows | Docker Hub → Account Settings → Security |

---

## GitLab CI/CD Variables

Configure these in: **Settings → CI/CD → Variables**

### Required Variables

| Variable Name | Description | Protected | Masked |
|---------------|-------------|-----------|--------|
| `GITHUB_MIRROR_TOKEN` | GitHub PAT for pull mirroring (if used) | Yes | Yes |

### Optional Variables

| Variable Name | Description | Protected | Masked |
|---------------|-------------|-----------|--------|
| `DEPLOY_SSH_KEY` | SSH key for deployment servers | Yes | Yes |
| `STAGING_HOST` | Staging server hostname | No | No |
| `PRODUCTION_HOST` | Production server hostname | Yes | No |

---

## Application Secrets

These should be set as environment variables in your deployment environment.

### Required for Production

| Environment Variable | Description | Example |
|---------------------|-------------|---------|
| `SECRET_KEY_BASE` | Phoenix secret key (64+ chars) | Generate with `mix phx.gen.secret` |
| `DATABASE_URL` | Database connection string (if using external DB) | `ecto://user:pass@host/db` |
| `PHX_HOST` | Production hostname | `branch-newspaper.example.com` |
| `PORT` | HTTP port to listen on | `4000` |

### IPFS Configuration

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `IPFS_API_URL` | IPFS node API endpoint | `http://localhost:5001/api/v0` |
| `IPFS_GATEWAY_URL` | IPFS gateway for content retrieval | `http://localhost:8080/ipfs` |

---

## Setup Instructions

### GitLab SSH Key Setup

This is required for the GitHub → GitLab mirror sync to work.

1. **Generate a new SSH key pair** (or use an existing one):
   ```bash
   ssh-keygen -t ed25519 -C "github-to-gitlab-mirror" -f gitlab_deploy_key
   ```

2. **Add the PUBLIC key to GitLab**:
   - Go to: [gitlab.com/maa-framework/3-applications/branch-newspaper](https://gitlab.com/maa-framework/3-applications/branch-newspaper)
   - Navigate to: Settings → Repository → Deploy keys
   - Click "Add deploy key"
   - Paste the contents of `gitlab_deploy_key.pub`
   - **Enable "Grant write permissions to this key"**

3. **Add the PRIVATE key to GitHub**:
   - Go to: [github.com/hyperpolymath/branch-newspaper](https://github.com/hyperpolymath/branch-newspaper)
   - Navigate to: Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `GITLAB_SSH_KEY`
   - Value: Paste the entire contents of `gitlab_deploy_key` (the private key file)

4. **Verify the setup**:
   - Go to Actions tab in GitHub
   - Manually trigger "Mirror Sync" workflow
   - Check the workflow logs

### Generating Phoenix Secret Key

```bash
# In a terminal with Elixir installed:
mix phx.gen.secret

# Or using OpenSSL:
openssl rand -base64 64
```

### Database URL Format

For different database backends:

```bash
# SQLite (default for development)
# No DATABASE_URL needed - uses local file

# PostgreSQL
DATABASE_URL=ecto://username:password@hostname:5432/database_name

# MySQL
DATABASE_URL=ecto://username:password@hostname:3306/database_name
```

---

## Security Best Practices

1. **Never commit secrets to version control**
   - Use `.env` files locally (add to `.gitignore`)
   - Use CI/CD secret management features

2. **Rotate secrets regularly**
   - `SECRET_KEY_BASE`: Rotate quarterly or after personnel changes
   - `GITLAB_SSH_KEY`: Rotate annually or after suspected compromise

3. **Use the principle of least privilege**
   - Deploy keys should have minimal required permissions
   - API tokens should be scoped appropriately

4. **Monitor for exposed secrets**
   - Enable GitHub secret scanning
   - Use pre-commit hooks to prevent accidental commits

---

## Troubleshooting

### Mirror sync fails with "Permission denied"
- Verify `GITLAB_SSH_KEY` is set correctly
- Ensure the deploy key has write permission on GitLab
- Check that the key format is correct (full private key including headers)

### CI fails to fetch dependencies
- Check if `HEX_API_KEY` is needed for private packages
- Verify network access from CI runners

### Deployment fails with "SECRET_KEY_BASE not set"
- Ensure all required environment variables are configured
- Check deployment platform's secret management

---

*Last updated: 2025-12-08*
