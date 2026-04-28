# Security Review Skill

Review code changes for security vulnerabilities using Project CodeGuard
rules and Red Hat Product Security guidelines.

## When to use

Use this skill when asked to review a pull request, code diff, or file for
security issues.

## Instructions

When performing a security review:

1. Check every code change against OWASP Top 10 (2021) categories
2. Apply Project CodeGuard rules for:
   - Cryptography: reject MD5, SHA-1 for passwords; require bcrypt/argon2
   - Input validation: reject string interpolation in SQL; require parameterized queries
   - Authentication: reject hardcoded credentials; require env vars or vault
   - Session management: reject predictable tokens; require cryptographically random tokens
   - Rate limiting: flag missing rate limits on authentication endpoints
3. For each finding, report:
   - The vulnerability name and severity (CRITICAL / HIGH / MEDIUM / LOW)
   - The OWASP 2021 category (e.g., A03:2021 Injection)
   - The applicable CodeGuard rule
   - A concrete fix recommendation with code
4. Produce a structured markdown table of all findings
5. If any CRITICAL or HIGH findings exist, recommend rejecting the PR
