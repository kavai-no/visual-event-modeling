---
name: visual-event-modeling
description: "Blueprint a system with Adam Dymitruk's Event Modeling as Event Modeling HCL (.em.hcl, specification v0.7.0) and render the canvas with emhcl diagram. Use for event modeling, a blueprint, what happens when, or a note that should become a specification. Not for CQRS, event stores, projections, or process managers. Finish the model yourself."
type: workflow
lifecycle: active
user-invocable: true
metadata:
  short-description: Blueprint a system as an event model and draw the wall
  hermes:
    tags: [EventModeling, Specification, Domain]
    category: engineering
---

# Visual event modeling

Blueprint the system the way a wall of stickies does. Time moves left to right. The only words on the wall are ones a person in the business would say out loud.

The notation is Event Modeling HCL. The picture is that notation's renderer, `emhcl diagram`. Do not emit eventmodeling text, Mermaid, or a hand-drawn SVG.

Read [references/language-v0.7.md](references/language-v0.7.md) before you write HCL. Read [references/patterns.md](references/patterns.md) when a workflow shape is unclear, and [references/method.md](references/method.md) for the workshop order. If those disagree with the HCL file, the HCL specification wins.

## How to work

The user may hand you a paragraph, a ticket, or a half-finished model. Model the system. Do not open with a questionnaire.

Ask at most one question, and only when you cannot tell what is inside the system versus outside it. If the boundary is clear enough to draw a happy path, draw it.

Finish the blueprint yourself. Participation is optional: after the artifacts, invite a correction in one sentence. Apply a correction by editing the model, not by starting over. Do not hand the work to another bot.

Do these seven moves in order. They are Dymitruk's workshop. Read [references/method.md](references/method.md) if a pattern or a name is unclear.

1. **Events.** Brainstorm the facts that will have happened, past tense, ignoring screens and order. "Guest viewed calendar" is not an event. A refusal is another event, not a diamond.
2. **Timeline.** Plot one plausible path left to right. No branching. The column order is the timeline.
3. **Screens.** Storyboard the wireframe each actor is looking at. Show every field. Do not stack screens; each state change is its own column.
4. **Commands.** Name the intention that asks for each event. A command may be rejected, so it is not a fact.
5. **Views.** Name what the screen shows. A view is rebuilt from events. A view informs; it cannot reject an event.
6. **Swimlanes.** Group the stickies by actor, a person or an outside system, so a team could own a lane. Not "database", "API", "backend", or "frontend".
7. **Specifications.** A `scenario` on the workflow. State change: given events, when one command, then an event or `error`. State view: given events, then a read model, and no when. Automation: given, when one processor or command, then an event or an error. Each scenario is tied to one command or one read model. A command usually has the success path and each rejection. A rejection that stores nothing is `then { error = "..." }`. A rejection that stores a different fact is its own event.

Then run the completeness check. Every field has an origin (a screen input or an earlier event) and a destination (a view, a later command, or a report). Trace one example ("Ada Marlowe", "ML-1042") across the wall with a finger. A field you cannot trace is unfinished.

## What is allowed on the wall

The HCL block name is what you write. There is no `translation` block.

| HCL block | What it is for |
|---|---|
| `state_change` | A screen sends a command, and an event is stored if the rules allow. |
| `state_view` | Events feed a read model, which fills a screen. This workflow stores nothing. The scenario has no when. |
| `automation` | A read model of work still open, a processor, a command, and the event that records the result. |
| `automation` on an external event | Outside data, from a `bounded_context` with `external = true`, becomes an event in our language. The canvas shows that as a translation. Do not invent a `translation` block and do not invent a person who clicked. |

Building blocks, and why the tense matters: a room can only share a wall they can read aloud.

- **Event** (orange). Past tense. Immutable. The system's memory. "Room reserved", never "Reserve room".
- **Command** (blue). An intention in the present. "Reserve room". It can fail, so it is not history.
- **View** (green). What someone reads in order to act. Name the decision, not a table.
- **Screen.** The wireframe that shows a view. It is not a new store of state.
- **Processor** (dashed). A policy: when this event, send that command. Not a service class.

Swimlanes are actors — a person or an outside system that sends commands. Do not make lanes for "database", "API", "backend", or "frontend".

## Shape

- One workflow per pattern. Do not put a state change and a state view in the same block.
- `state_change`: `screen.to` the command, `command.to` the event. A stored refusal is another event. A refusal that stores nothing is `then { error = "..." }`.
- `state_view`: `readmodel.from` the events, `readmodel.to` the screen. Scenario has given and then, no when.
- `automation`: read model or processor, then command, then event. An external source event makes it a translation. The keyword is still `automation`.
- Events live in a `bounded_context`, past tense, with `field` blocks whose `example` is a real value ("Ada Marlowe"), not a type name alone.
- Actors are `actor` blocks, a person or an outside system. Not "database", "API", "backend", or "frontend".
- One `board` lists the workflows in business time. A workflow left off the board is not part of the story.
- Every field has an origin and a destination. A field you cannot trace is unfinished.
- Do not choose a table or a database. A read model is an information contract: `question`, `from` events, fields, one scenario.
- Stay on the boundary. Do not model the inside of a card network; model the event you record when it answers.

## Output

Write one `.em.hcl` file, specification v0.7.0. In a repo, `model.em.hcl`. In chat, one `hcl` fence. Do not invent a private schema.

Then render with `emhcl` v0.16.0 or newer. This skill does not vendor the binary. `scripts/emhcl.sh` downloads the official release for the current machine on first use, then runs it. On Hermes the skill directory is `${HERMES_SKILL_DIR}`.

```bash
"$SKILL_DIR/scripts/emhcl.sh" validate model.em.hcl
"$SKILL_DIR/scripts/emhcl.sh" diagram model.em.hcl -o model.html
```

`diagram` validates before it draws. If validate fails, fix the HCL and run it again. Do not draw a substitute SVG. The HTML is the picture: Model, Compact, Storming, Slides, and Context Map in one file.

If the download fails, use `emhcl` from `PATH` when `emhcl version` reports v0.16.0 or newer. If neither exists, still hand over the `.em.hcl` and say the canvas was not rendered. Do not fake the diagram.

Then stop. Add at most four sentences: what this system remembers, and one invitation to change a slice. Do not add a class diagram, an aggregate list, or a technology choice unless asked.

## When this is the wrong skill

This skill stops at the blueprint. Streams, snapshots, projections, tests, and process managers are event sourcing, not a picture of the wall. Do not pick a database here.

## Working an existing model

If the user pastes `.em.hcl`, or a file that starts with `board` or `state_change`, change only what they asked. Run validate, then diagram, and show both again.

A v0.4.0 file (no `board`, or a `translation` block) is converted first: `scripts/emhcl.sh migrate -w model.em.hcl`. Review the result. Do not leave the old keyword in place.

Slice-based Event Modeling JSON is a draft only: `scripts/emhcl.sh import file.json -o model.em.hcl`, then review it. Import does not invent missing targets.
