# Method

The file you write is `.em.hcl`. The four workflow blocks are `state_change`, `state_view`, and `automation`. A translation is an `automation` whose source event belongs to a `bounded_context` with `external = true`. There is no `translation` keyword. Syntax is in `language-v0.7.md`. This page is the workshop, not the grammar.

Event Modeling (Adam Dymitruk) is a blueprint of an information system over time. It is not a domain model, not a UML diagram, and not event storming's big-picture orange storm — though the events feel related. The point is that a designer, a developer, and the person who does the job can point at the same sticky and mean the same fact.

Time goes left to right because that is how the business is experienced. Vertical lanes are who is involved. A column (a slice) is one small story that can be specified and built on its own.

## The four patterns

Every column is exactly one pattern. Picking the pattern first stops people from hiding a queue or an automation inside a vague "the system updates".

### State change

Someone needs information, sends an intention, and a fact is recorded if the rules pass.

Typical column, top to bottom, in that actor's lane:

1. Screen they are looking at (filled by some earlier view).
2. Command they issue.
3. Event recorded when the command is accepted.
4. View that now shows the new fact (often the next screen).

The command is allowed to be rejected. Each rejection is its own slice and its own spec ("Stay declined"), tied to that command. It is not an exception diamond and not a missing event. A command usually has more than one spec: the path that stores the event, and each refusal.

### State view

The system is informing someone, not changing. The column has a screen and the green view that fills it. There is no command. Given / when / then still exists: when they open Tuesday, then no event is stored, and the screen shows these rows. This pattern is where "reports" and "what's on today's list" live — until someone acts, and that action is a different slice.

### Translation

A fact in one place causes an intention somewhere else, with no person in between. The processor sticky is the policy, written as when / then:

- When: Room reserved
- Then: Charge stay

The command and the resulting event sit in the lane of the system that acts (payments, mail, a partner). The processor explains why a command appeared with no screen above it. Do not draw a translation as a state change performed by a fictional user named "System" clicking a button, and do not draw it as an event with no command.

### To-do list

Work accumulates. The green view is the queue (rows still open). A command completes one row. An event records the completion. The view is "outstanding work" — rebuilt as events arrive and completion events remove rows. Check-out creating a room to clean, moderation creating a review, a claim waiting on an adjuster: these are to-do lists, not a bag of flags on an entity.

## Naming

Say the words the actor would say.

| Sticky | Prefer | Avoid |
|---|---|---|
| Event | Room reserved, Guest checked out, Tool borrowed | Reserve room, Room reservation, Update room |
| Command | Reserve room, Check in, Mark room ready | RoomReserved, Submit, Handle booking |
| View | Open calendar, Arrivals, Rooms to service | RoomReadModel, BookingDTO, v_arrivals |
| Screen | Find a room, Today's arrivals | BookingPage, HotelController |
| Processor | Charge on reserve | PaymentService, ReservationSaga |

Events are past tense because they already happened and will not be edited. Commands are intentions because they might be refused. If a sticky's name could be either, the wall is lying and the software built from it will store intentions as if they were facts.

Fields are example values from one scenario carried across the whole blueprint (the same guest, the same id, the same amount). Types ("string", "guid") do not specify a system; "ML-1042" and "$420" do. A reader should be able to trace one story with a finger.

## The seven moves

Use them as a sequence of attention, not as seven meetings. This is the order in Dymitruk's article.

1. **Brainstorm events.** "What will have happened?" Ignore screens, databases, and order. Write past tense. "Guest viewed calendar" is not an event: looking is not a stored fact. Include the awkward facts (payment declined, request withdrawn) as their own events.
2. **Timeline.** Arrange one plausible path left to right, with no branching. The column order *is* the timeline. Do not number steps inside a title.
3. **Storyboard.** Each actor gets a rough screen at the moment they look, and every field is on it. Boxes and labels are enough. A screen with no view feeding it is a picture of a guess. Do not stack screens on one column.
4. **Commands.** For each event, "who asked for this, and what did they ask?" Put that command above the event, in their lane. A command is an intention the system may reject.
5. **Views.** For each screen, "what did they need to see?" That is the green sticky. It must be derivable from events already on the wall. A view informs. It cannot reject an event.
6. **Swimlanes.** Group by actor, a person or an outside system, so a team could own the lane. This is Conway's Law applied to the wall, not a service map.
7. **Specifications.** Given-When-Then for a command or an automation. Given-Then for a view: they open the screen, and no event is stored. Each spec is tied to exactly one command or one view. Then the completeness check: every field has an origin and a destination.

Where nobody clicks, say which pattern it is. A to-do list is a queue, a processor, and a command that completes one row. A translation turns outside data into our events, or sends a command in another lane because an event happened. Do not invent a user named "System" to click a button.

## Slices are the unit of work

A slice is a vertical cut: one pattern, one outcome, small enough to implement and test alone. The spec is the contract with the neighboring slices, and nothing else. Do not merge "reserve", "pay", and "check in" into one slice to save space. Changing the fields of an event is a new version of that slice. The loop "screen, command, event, view, screen" is a practitioner's description of a state change, not Dymitruk's name for it.

Keep one scenario to a handful of slices (usually 4–8), and add a slice for each rejection the business actually enforces. A blueprint of forty columns is a novel. Split a second blueprint per coherent outcome ("a stay", "a shift", "a claim") rather than one wall for the company.

A view does not prescribe storage. It names the events that feed it, the fields it shows, and one Given-Then spec. A flat table, a join, or a query over the write model is an implementation choice, made later, in `event-sourcing`.

## What this is not

- Not event storming. Storming is a workshop that discovers events. Modeling arranges events, commands, views, and screens into a blueprint with specs.
- Not a data model. No aggregates, no tables, no "User has many Bookings" as the spine. Those can be derived later, and only if someone asks.
- Not a service map. Lanes are actors, not deployables.
- Not high-fidelity UI. The wireframe exists so the view has a place to appear.

## A note on the classic hotel

Dymitruk's teaching example is a hotel stay: price a night, reserve, charge, see arrivals, check in, check out, turn the room. It is an illustration of the four patterns, not a template to copy into unrelated domains. Borrow the *shape* (one scenario, real values, one pattern per column). Do not borrow the rooms unless the system is actually a stay.
