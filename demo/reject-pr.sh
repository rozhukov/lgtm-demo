#!/usr/bin/env bash
# Demo: reject the PR with a security review (Act 3)
# Usage: bash demo/reject-pr.sh <PR_NUMBER>
#
# Requires: gh cli authenticated (gh auth login)
#
# NOTE: --request-changes won't work on your own PR.
# Use --comment for self-owned PRs (demo), or use a bot account
# for the full --request-changes experience.

PR_NUMBER="${1:-1}"
MODE="${2:---comment}"  # --comment (own PR) or --request-changes (bot account)

gh pr review "$PR_NUMBER" "$MODE" --body "$(cat <<'EOF'
## Security Review — Changes Requested

This PR was reviewed using [Project CodeGuard](https://project-codeguard.org)
and [prodsec-skills](https://github.com/RedHatProductSecurity/prodsec-skills).

**5 security vulnerabilities found:**

| # | Finding | Severity | OWASP | CodeGuard Rule |
|---|---------|----------|-------|----------------|
| 1 | SQL injection via f-string interpolation | **CRITICAL** | A03:2021 Injection | `input-validation-injection` |
| 2 | MD5 used for password hashing | **HIGH** | A02:2021 Cryptographic Failures | `additional-cryptography` |
| 3 | Hardcoded database credential (`DB_PASSWORD`) | **HIGH** | A07:2021 Auth Failures | `hardcoded-credentials` |
| 4 | Predictable session token (MD5 of username) | **MEDIUM** | A02:2021 Cryptographic Failures | `session-management` |
| 5 | No rate limiting on authentication endpoint | **MEDIUM** | A07:2021 Auth Failures | `authentication-mfa` |

**Dear contributor**, we recommend completing the
[OpenSSF Secure AI/ML-Driven Software Development (LFEL1012)](https://training.linuxfoundation.org/training/secure-ai-ml-driven-software-development-lfel1012/)
course and configuring your AI assistant with security-focused instructions per the
[OpenSSF Guide](https://best.openssf.org/Security-Focused-Guide-for-AI-Code-Assistant-Instructions).

_With love, your AI-assisted security reviewer_ :shield:
EOF
)"

echo ""
echo "PR #$PR_NUMBER rejected with security review."
