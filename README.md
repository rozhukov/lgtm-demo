# lgtm-demo

A minimal Flask app used to demonstrate AI-assisted security code review
with [Project CodeGuard](https://project-codeguard.org) and
[prodsec-skills](https://github.com/RedHatProductSecurity/prodsec-skills).

Part of the talk **"Looks Good to Me": A Practical Guide to Handling
AI-Generated Code** at [NDC Toronto 2026](https://ndctoronto.com).

## Quick start

```bash
pip install -r requirements.txt
python -m pytest tests/
python -m flask --app app.main run
```

## Security rules

This project uses [Project CodeGuard](https://project-codeguard.org)
rules in `.cursor/rules/` to guide AI coding assistants toward secure
code generation and review.
