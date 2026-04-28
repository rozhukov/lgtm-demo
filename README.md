# lgtm-demo

A minimal Flask app used to demonstrate AI-assisted security code review
with [Red Hat Product Security SKILLS](https://github.com/RedHatProductSecurity/prodsec-skills).

Part of the talk **"Looks Good to Me": A Practical Guide to Handling
AI-Generated Code** at [NDC Toronto 2026](https://ndctoronto.com).

## Quick start

```bash
pip install -r requirements.txt
python -m pytest tests/
python -m flask --app app.main run
```

## Security rules

This project uses [Red Hat Product Security SKILLS](https://github.com/RedHatProductSecurity/prodsec-skills)
rules to guide AI coding assistants toward secure
code generation and review.
