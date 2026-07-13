---
layout: manual
race: hilo
title: CommsHQ - High Lonesome 100 Comms Manual
aids:
  - raspberry1
  - antero
  - stelmo1
  - cottonwood
  - stelmo2
  - tincup
  - hancock
  - lwh
  - purgatory
  - monarch
  - fooses
  - shavano
  - blanks
  - raspberry2
  - finish
parts:
    - protocols
    - discord
---

### What CommsHQ Does

CommsHQ is the central hub of the Communications Team. While each aid station tracks the runners passing through it, CommsHQ keeps the whole picture: which stations are open, where the runners are, and whether the live data is correct. Aid stations reach us on Discord in **#comms** by mentioning **@CommsHQTeam**.

Our core responsibilities:

- **Maintain communication with every open aid station** — know who is on the air, relay information between stations, and make sure no station goes quiet unnoticed.
- **Relay the field between stations** — pass first-runner ETAs forward, and relay drops so downstream stations stop expecting runners who are no longer on course.
- **Keep the live data correct** — watch OpenSplitTime (OST) for bad or questionable times and get them fixed by confirming the real time with the aid station.
- **Close aid stations safely** — reconcile each station's records against ours and confirm every runner and sweeper is accounted for before any station packs up.

CommsHQ is a team, not one person. Agree up front on who is watching Discord, who is watching OST, and who owns closing each station, and hand these off cleanly at shift changes.

### Maintaining Communication with Aid Stations

- **Keep a station status board.** For each aid station, track: open / closed, whether it has a data connection or is on [secondary tracking](#secondary-runner-tracking), the device/handle to reach it on Discord, and the last time you heard from it.
- **Confirm every message.** React with 👍 to every message an aid station sends you, and expect the same back on everything you send. Silence is not confirmation — if you do not see a 👍, assume it was not received and follow up.
- **Relay the first runner forward.** When a station reports its first runner (per gender), confirm it, then message the *next* station with a heads-up and an ETA so they know when to expect the front of the field.
- **Post drops to #race-drops.** When a runner drops or is time-cut, post it in the **#race-drops** channel so downstream stations stop expecting that runner. Use the format from the [Protocols](#protocols) section: `Drop <bib#> <time dropped> <first name> <last name> at <aid name>`. Every comms volunteer monitors #race-drops, so a single post reaches all downstream stations at once.
- **Watch for stations that need data connectivity.** Some stations have no cell or Starlink and fall back to [Secondary Runner Tracking](#secondary-runner-tracking) — texting every in/out time to CommsHQ. Enter those into OST on their behalf and confirm receipt so no runner is dropped from the live data.

### Fixing Bad Runner Times

OST evaluates every time against the expected pace for that segment and flags anything that does not fit. A time can be flagged as **questionable** (yellow) or **bad** (red) — for example, an "out" time earlier than the "in" time, or a segment that is impossibly fast or slow. Your job is to find these and resolve each one with the correct time from the aid station, not with a guess.

**Monitor for problems.** Check **Admin > Problems** in OST regularly throughout the day. Also watch the **Live Entry** screen: times that came in over the network but could not be auto-posted wait there for review, and the blue **Pull Times** button shows how many are waiting. Pull and review them.

**Get the real time from the station.** When a time is flagged, message the aid station on Discord and ask them to read the runner's actual in/out time off their runner tracking form. Do not overwrite a flagged time with a value you inferred — the whole point of the tracking form is to have ground truth to correct against.

**Prefer Live Entry over Direct Edit.** When you enter or correct a time through the **Live Entry** screen, OST keeps a Raw Time record, so there is an audit trail of what changed. Editing an Effort's times directly (**Actions > Edit Times of Day**) is faster for fixing several blank or wrong times at once, but leaves *no* audit trail — use it sparingly.

**Confirm a time you know is right.** Sometimes a time is genuinely correct but still trips OST's pace tolerances (a runner who napped, got lost, or ran an unusually fast segment). If the station verifies the time is accurate, open the runner's Effort screen and click the **Confirm** (thumbs-up) button next to that split. Confirming overrides OST's analysis and marks the time valid.

**When it is not obvious which time is wrong.** A bad segment can mean either end of it is off. If you cannot tell, ask the stations on both ends to check their forms, or wait for the runner's next split — once the following station reports, it usually becomes clear which time was faulty. The **Analyze Times** tab on the Effort screen compares each segment against expected pace and helps pinpoint the bad split.

### Closing Down Aid Stations

**No aid station closes without CommsHQ's OK.** A station is only clear to pack up once we have reconciled its records against ours and confirmed every runner and sweeper is through or accounted for.

As a station nears its cutoff and only a few runners are left to reach it, run the reconciliation:

1. **Identify who is still out.** From OST and your records, list the bibs that have left the previous station but have not yet reached this one.
2. **Send the list to the station and ask them to confirm.** They may have runners you are missing (came through but was not recorded) or you may be tracking runners they never saw (a drop or DNS upstream).
3. **Resolve every discrepancy.** For runners the station has but OST does not, get their in/out times and enter them. For runners neither of you can account for, work upstream to determine whether they dropped, were a DNS, or are genuinely still on course.
4. **Track the sweepers.** Sweepers carry inReach devices so you can see their location. The last runners are ahead of the sweepers — the station is not empty until the sweepers are through.
5. **Give the all-clear in stages.** Once the last runner is through, tell the station they can start packing up but to leave out food and supplies for the sweepers. Once the sweepers are through as well, tell them they are clear to close down.

The reconciliation exchange in the [Protocols](#reconciliation-and-closing-down-aid-stations) section below shows what this looks like on Discord — from the aid station's side of the same conversation you are running from CommsHQ.

### Emergencies

For any emergency reported to you, escalate immediately by mentioning **@Jon Eisen (Comms Director)**, **@Caleb Efta (Race Director)**, and **@CommsHQ**. Keep the reporting station on the line and relay clearly; do not let an emergency get buried in a busy channel.
