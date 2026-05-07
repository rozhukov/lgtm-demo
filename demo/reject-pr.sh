#!/usr/bin/env bash
# Demo: reject the PR with a security review (Act 3)
# Usage: bash demo/reject-pr.sh <PR_NUMBER> [--request-changes|--comment]
#
# Requires: gh cli authenticated (gh auth login)
#
# NOTE: --request-changes won't work on your own PR.
# Use --comment for self-owned PRs, or --request-changes for bot PRs.

REPO="rozhukov/lgtm-demo"
BRANCH="feature/fix-auth-hashing"
FILE="app/auth/login.py"
BASE="https://github.com/${REPO}/blob/${BRANCH}/${FILE}"
SKILLS="https://github.com/RedHatProductSecurity/prodsec-skills/blob/main/skills"

PR_NUMBER="${1:-2}"
MODE="${2:---request-changes}"

gh pr review "$PR_NUMBER" "$MODE" --body "$(cat <<EOF
## :shield: Security Review — Changes Requested

This PR was reviewed using [prodsec-skills](https://github.com/RedHatProductSecurity/prodsec-skills) from Red Hat Product Security.

**5 security vulnerabilities found:**

| # | Vulnerability | Severity | OWASP | prodsec-skill | Vulnerable Code | Fix |
|---|--------------|----------|-------|---------------|-----------------|-----|
| 1 | SQL injection via f-string interpolation | **CRITICAL** | A03:2021 Injection | [\`input-validation-injection\`](${SKILLS}/secure_development/web-security/input-validation-injection.md) | [login.py:L23-25](${BASE}#L23-L25) | Use parameterized query: \`cur.execute("...WHERE username=? AND password=?", (username, hashed))\` |
| 2 | MD5 used for password hashing | **HIGH** | A02:2021 Cryptographic Failures | [\`algorithm-selection\`](${SKILLS}/secure_development/crypto/algorithm-selection.md) | [login.py:L18](${BASE}#L18) | Replace with \`bcrypt.hashpw(password.encode(), bcrypt.gensalt())\` |
| 3 | Hardcoded database credential (\`DB_PASSWORD = "admin123"\`) | **HIGH** | A07:2021 Auth Failures | [\`insecure-defaults\`](${SKILLS}/secure_development/secure-config/insecure-defaults.md) | [login.py:L8](${BASE}#L8) | Use \`os.environ["DB_PASSWORD"]\` (fail-secure) |
| 4 | Predictable session token (MD5 of username) | **MEDIUM** | A02:2021 Cryptographic Failures | [\`session-management-cookies\`](${SKILLS}/secure_development/web-security/session-management-cookies.md) | [login.py:L30](${BASE}#L30) | Use \`secrets.token_hex(32)\` for CSPRNG token |
| 5 | No rate limiting on auth endpoint | **MEDIUM** | A07:2021 Auth Failures | [\`defense-in-depth\`](${SKILLS}/secure_development/security-principles/defense-in-depth.md) | [login.py:L11](${BASE}#L11) | Add \`flask-limiter\` with \`@limiter.limit("5 per minute")\` |

**Dear contributor**, we recommend completing the
[OpenSSF Secure AI/ML-Driven Software Development (LFEL1012)](https://training.linuxfoundation.org/training/secure-ai-ml-driven-software-development-lfel1012/)
course and configuring your AI assistant with security-focused instructions per the
[OpenSSF Guide](https://best.openssf.org/Security-Focused-Guide-for-AI-Code-Assistant-Instructions).

_With love, your AI-assisted security reviewer_ :shield:
EOF
)"

echo ""
echo "PR #$PR_NUMBER rejected with security review."
