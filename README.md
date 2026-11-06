# visual-event-modeling

Public agent skill. It blueprints a system with Adam Dymitruk's Event Modeling, writes Event Modeling HCL (`.em.hcl`, specification v0.7.0), and renders the canvas with `emhcl diagram`.

The skill folder is [`.grok/skills/visual-event-modeling`](.grok/skills/visual-event-modeling). Opening this repository is enough for Grok to find it. The same folder is linked from `.agents/skills`, `.hermes/skills`, `.cursor/skills`, and `.claude/skills`.

`scripts/emhcl.sh` downloads [emhcl v0.16.0](https://github.com/event-modeling-hcl/eventmodeling-hcl/releases/tag/v0.16.0) on first use. The HCL notes under `references/` are from that project and stay under the Apache-2.0 license in `references/EMHCL-LICENSE`.
