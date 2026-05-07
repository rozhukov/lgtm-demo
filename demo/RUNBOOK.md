# Demo Runbook — "Looks Good to Me"

All commands assume you are in the `lgtm-demo/` repo root and `gh` is
authenticated (`gh auth status`).

Repo: <https://github.com/rozhukov/lgtm-demo>

---

## RESET — Run before every rehearsal / before the talk

```bash
# 1. Remove prodsec-skills from the repo (so you can re-install live)
rm -rf .cursor/skills/prodsec-skills

# 2. Close any open demo PR and delete the feature branch
gh workflow run "Bot: Reset demo (close PR, delete branch)"
#    ↳ wait ~30 s for the workflow to finish, then verify:
gh pr list
gh run list --workflow="Bot: Reset demo (close PR, delete branch)" --limit 1

# 3. Clean up local feature branch to avoid divergence errors
git checkout main
git branch -D feature/fix-auth-hashing 2>/dev/null || true
```

After reset the repo has: `main` branch only, no open PRs, no
prodsec-skills installed, no local feature branch. The security-review
SKILL.md is still there (it references prodsec-skills by path but they
won't exist yet).

---

## DEMO STEPS — Run live during the talk (~2 min)

### Step 1 — Create the vulnerable PR  [Browser]

Trigger the GitHub Actions bot to submit a PR as `github-actions[bot]`:

```bash
gh workflow run "Bot: Submit AI-generated PR"
```

Wait ~40 s, then get the PR number:

```bash
gh pr list
# note the PR number (e.g. 3)
```

Open in browser: `https://github.com/rozhukov/lgtm-demo/pull/<NUMBER>`

Show the audience:
- Friendly title: "Fix: resolve password hashing in login endpoint"
- Casual description: "LGTM? 🙏"
- CI is green
- One file changed, ~30 lines

> "Looks reasonable, right? Tests pass. CI green. One file. LGTM?"

---

### Step 2 — Install ProdSec Skills  [Terminal in Cursor]

```bash
git clone --depth 1 https://github.com/RedHatProductSecurity/prodsec-skills.git _tmp-prodsec
cp -r _tmp-prodsec/module/skills .cursor/skills/prodsec-skills
rm -rf _tmp-prodsec
```

> "128 security skills — crypto, web security, supply chain, auditing —
> installed in 5 seconds. These are plain markdown files that any AI
> assistant can read."

---

### Step 3 — Run security review  [Cursor Chat]

Checkout the PR branch so Cursor can see the vulnerable file:

```bash
git fetch origin
gh pr checkout <NUMBER>
# If you get a "diverged" error, run:
#   git reset --hard origin/feature/fix-auth-hashing
```

Then paste into Cursor chat:

```
Review the file `app/auth/login.py` for security vulnerabilities.
Use the security-review skill and prodsec-skills. For each finding,
provide: vulnerability name, severity, OWASP category, prodsec-skill
that detected it, add column with the link to vulnerable code so that I can click in GitHub and a fix. Format as a markdown table.
```

Wait for AI output — it will catch:

| # | Finding | Severity |
|---|---------|----------|
| 1 | SQL injection via f-string | CRITICAL |
| 2 | MD5 password hashing | HIGH |
| 3 | Hardcoded credential | HIGH |
| 4 | Predictable session token | MEDIUM |
| 5 | No rate limiting | MEDIUM |

> "Not so LGTM after all."

---

### Step 4 — Reject the PR  [Terminal in Cursor]

```bash
bash demo/reject-pr.sh <NUMBER> --request-changes
```

> "Done. One command."

---

### Step 5 — Show the rejected PR  [Browser]

Switch back to browser, refresh the PR page.

The audience sees:
- Red **"Changes requested"** badge
- Detailed review table with 5 findings, OWASP categories, prodsec-skill names
- The punchline: _"Dear contributor, we recommend completing the
  OpenSSF LFEL1012 course…"_

> "That took 30 seconds. prodsec-skills is open source. The repo is
> public — fork it after the talk."

---

## CLEANUP — After the talk

```bash
# Close the PR and delete the branch
gh workflow run "Bot: Reset demo (close PR, delete branch)"

# Optionally remove skills
rm -rf .cursor/skills/prodsec-skills
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `gh workflow run` fails | `gh auth refresh -h github.com -s workflow` |
| PR not appearing after trigger | Wait 60 s, check `gh run list --limit 1` |
| `--request-changes` fails | You're reviewing your own PR — use `--comment` or re-create with bot workflow |
| Cursor doesn't find skills | Verify `.cursor/skills/prodsec-skills/` exists with `ls .cursor/skills/prodsec-skills/` |
| Need to re-run without full reset | Dismiss review first: `gh api repos/rozhukov/lgtm-demo/pulls/<N>/reviews -q '.[0].id'` then dismiss |
| `gh pr checkout` says "diverged" | `git reset --hard origin/feature/fix-auth-hashing` |