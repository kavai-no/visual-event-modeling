# visual-event-modeling

A public agent skill. It blueprints a system with Adam Dymitruk's Event Modeling, writes Event Modeling HCL (`.em.hcl`, specification v0.7.0), and renders the canvas with `emhcl diagram`.

Install by copying this folder into a skill path:

- Grok: `.grok/skills/visual-event-modeling/` or `~/.grok/skills/visual-event-modeling/`
- Codex and other agents: `.agents/skills/visual-event-modeling/`
- Hermes: `.hermes/skills/visual-event-modeling/`

`scripts/emhcl.sh` downloads [emhcl v0.16.0](https://github.com/event-modeling-hcl/eventmodeling-hcl/releases/tag/v0.16.0) on first use. The HCL language notes under `references/` are from that project and stay under the Apache-2.0 license in `references/EMHCL-LICENSE`.
