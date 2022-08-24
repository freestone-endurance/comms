## Protocols ##

_In general, when this document says “message” or “text”, we mean to text via Discord, falling back to an iPhone with cell service or inReach device._

**Every message must be confirmed!** Always send “Confirmed” back after receiving any new information. CommsHQ will do this too! (On Discord, we can use message reactions. Use thumbs up for confirmation.)


Please use the 24-hour clock for all time recordings. This makes it easier to correct any errors. We will try to set all devices to 24-hour clocks so that it is easier. If you’re using a personal device, we suggest you set the device to 24 hour clock for the duration of your shift.


### Aid Station Setup

- [ ] Initiate text communication with CommsHQ early
- [ ] Set up data connection (if applicable)
- [ ] Perform Roster Update (Refresh Data in OST Remote) to test connection (if data connection)
- [ ] Send message to CommsHQ in Discord (if data connection**

If your aid station has no data connection, please try to update the roster before leaving cellular service. If for some reason, you cannot update the rosters, new runners will show up as “Bib not found”. This is OK and will not affect times upon upload.

### Dropped and Time-Cut Runners

**Drops**: If a runner decides to drop at your aid station, you must send them to the Aid Station Captain. Always record their inbound time normally. Only the captain can officially drop a runner. The captain should fill out a drop form and pin the runner's bib to it. They should store the drop form in the Comms binder. Record the runner's drop time as outbound and setting the status to Done.

**Time-Cuts**: Runners coming in after the cutoff have a 2 minute grace period at the discretion of the Captain. All runners that are time-cut must have a drop form filled out. Record their inbound time with a status as Done.

In either case send a message to CommsHQ with the following information:

```
Drop <bib#> <time dropped> <first name> <last name> at <aid name>
```

When a runner drops at a previous aid station, CommsHQ will send you a message for each one. Please record these for later use.

### First Runner

When the first runner reaches the previous aid station, CommsHQ will notify you of the ETA for the first runner. When the first runner reaches your aid station, please send a message to CommsHQ notifying them (and who the runner is**. CommsHQ will confirm the message and send a message to the next aid station.

### Reconciliation and Closing Down Aid Stations

When there are only a few runners left to reach your aid station, CommsHQ will reconcile the OST records against your records. This is an important process to ensure that both CommsHQ and the Comms Team at the aid station agree on exactly which runners are left out on the course prior to their aid station.

Sweepers will be carrying inReach devices so that CommsHQ can track their location. Once the last runners pass through your aid station, CommsHQ will tell you that you can start packing up, but please leave out enough food and supplies for the sweepers, as they will have just run quite a distance on the course. Once sweepers and all runners are through, CommsHQ will let you know that you can close down.


**Do not close your aid station until CommsHQ has reconciled your runner tracking and all runners and sweepers have passed through. CommsHQ is responsible for ensuring all runners and sweepers have dropped or passed through your aid station before you can close down.**

This whole exchange may look something like this:

> CommsHQ: “I’ve got 3 runners left to reach you, #71 #15 #100. Please Confirm you have the same.”
> Aid: “#15 came through already. I forgot to record it in OST. Confirm #71 and #100 still not here. I have #22 still out too.”
> CommsHQ: “Please send #15 times in/out and I’ll correct. #22 is a DNS. Last runners are #71 and #100.”
> Aid: “#15 Joe Schmoe 15:11 in 15:45 out. Confirm #22 is DNS.”
> CommsHQ: “Confirm #15. Ok you can start packing up once #71 and #100 are thru. Sweepers are 1 hour out.”

### Secondary Runner Tracking

In the event of a data transmission failure, we must fall back to our secondary runner tracking protocol: texting every runner’s in/out time to CommsHQ.

Once a runner has left your aid station and you have recorded it in your runner tracking form, send a text to CommsHQ. You can wait for a lull in the runners to do this, but please do not wait more than 15 minutes to send any runner information. Please mark your runner tracking form to indicate you have relayed the information to CommsHQ.

```
Runner #<bib> <runner name> <time in> in <time out> out [w/pacer]
```

Examples:
```
Runner #101 Jessica Schmoe 2159 in 2230 out
Runner #15 Joe Schmoe 2245 in 2253 out w/pacer
```
