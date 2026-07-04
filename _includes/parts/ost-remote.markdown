## Tracking Runners with OST Remote

**[Tracking runners with OST Remote Youtube Video](https://youtu.be/hL4ECiygmpU)**

We track runners when they come in, when they leave, and when and where they drop. We also track whether they have a pacer or not. We do this two ways at once: in **OST Remote**, an iOS app that syncs runner times to the cloud, and on a **paper Runner Tracking Form** as a backup. The paper form is not optional — devices, data, and power all fail, and the paper record is what keeps us tracking when they do.

### Setting Up Your Tracking Team

At most aid stations, tracking is a **two-person job**:

- **One person runs the iPad**, entering each runner's bib and time in OST Remote.
- **One person keeps the paper form and spots** — calling out bib numbers as runners arrive and leave, and writing every one down. This person is your backup and your second set of eyes.

Post up right where runners check in. If runners come in and leave at **different spots** (separate in/out chutes), set up a person or a pair at each. At later aid stations, once the runners are more spread out, one experienced person can often handle both jobs.

Whatever the setup, **every runner goes on paper as well as in the app.** When the app and the paper disagree, sort it out at the next sync while it's still fresh.

### Logging In

When you receive your iOS device(s) from CommsHQ, it will be logged into our account with the `tracking@freestoneendurance.com` account. If it isn’t, go ahead and log in. The credentials will be in the binder.

### Selecting Aid Station

In most cases, this will be done for you by CommsHQ prior to the race. If you have to change aid stations, or if it was done incorrectly, you may have to reselect the aid station to setup the app for entry. Do so in the Utils panel.

### Live Entry

Live Entry is the main view you’ll need to enter runner’s times. When a runner comes in, enter their bib number. Once you’ve selected a bib number, the runner’s name should show up. Double check it’s the correct name with the runner (or the runner tracking sheet). If they have a pacer with them, toggle the Pacer/No Pacer selection. Finally, hit the **[Aid Name] In** button to commit their entry.

When a runner is leaving your aid, do the same as above, selecting the [Aid Name] Out button to commit their entry.

If a runner decides to drop at your aid station (See Drops section), you’ll enter the drop by typing in their bib number, toggling the Continuing/Done selection, and tapping the **[Aid Name] Out** button to commit the drop entry.

Once the **[Aid Name] In** or **[Aid Name] Out** buttons are tapped, the view will reset, preparing you to enter the next runner.

The image below (left) show the Live Entry view for the Raspberry 1 Aid Station. The image below (center left) shows the Live Entry view after typing a bib number in, but before hitting the Raspberry 1 In button. The image below (center right) shows the entry for a runner right after tapping the Raspberry 1 In button, where you can easily tap to make changes, or start typing in another bib number. The final image (right shows that you can enter a time for bib number even if it isn’t on the roster.

<div style="display:flex; gap: 1em;">
    <img src="{{site.baseurl}}/img/parts/ost-remote/live-entry-1.png" width="20%" style="margin-left:10%"/>
    <img src="{{site.baseurl}}/img/parts/ost-remote/live-entry-2.png" width="20%"/>
    <img src="{{site.baseurl}}/img/parts/ost-remote/live-entry-3.png" width="20%"/>
    <img src="{{site.baseurl}}/img/parts/ost-remote/live-entry-4.png" width="20%"/>
</div>

### Syncing

You must sync OST Remote in order to upload the runner tracking times to the cloud (and CommsHQ). To get to the Sync page, tap the “Hamburger Menu” in the top right corner, which shows the sidebar menu (image below, left. From there, select Review / Sync to go to the Sync view. If you have unsynced entries, a small red badge will show how many entries are unsynced. See the images below.

<div style="display:flex; gap: 1em;">
    <img src="{{site.baseurl}}/img/parts/ost-remote/sync-1.png" width="20%" style="margin-left:20%"/>
    <img src="{{site.baseurl}}/img/parts/ost-remote/sync-2.png" width="20%"/>
    <img src="{{site.baseurl}}/img/parts/ost-remote/sync-3.png" width="20%"/>
</div>

Once on the Sync view, you will see your unsynced entries (see image above, right). Here, you should review the entries to cross check with your Runner Tracking Form to make sure you have the correct bib numbers, pacer, drops, and times (time accuracy within a few minutes). Now is the easiest time to correct a mistake. If anything is wrong, simply select the entry that you’d like to correct and edit the entry directly. Note the red text says that a Bib was not found. This is not necessarily an error; it could be a new runner and your OST Remote has not had it’s roster updated.


Once you’ve confirmed the data is correct, hit the Sync button. If you get a Success! screen (shown above, right), all those entries are now synced and you can return to the Live Entry screen to prepare for the next runner.

How often should you sync?
* If you are on a good data connection (cellular, Starlink), sync as often as possible!
* If you are on a low/Satellite data connection (iSavi), please sync every 5-15 minutes.

### Roster Update / Refresh Data

As you get your aid station setup with your data connection, part of your getting ready process will be to update the roster (after the race starts. Simply tap the Menu, then Utilities, then Refresh Data.

### What To Do If... (iPad & App)

- **Always Be Charging (ABC):** Keep the iPad plugged in whenever you can. It's far better to top off at 90% than to discover a charging problem at 20%. A full battery buys you time to fix a power issue.
- **The iPad is slow or frozen:** Reboot it — hold the power button for ~5 seconds, tap Power Off, wait 10 seconds, and power it back on. Rebooting does **not** log you out of OST Remote.
- **An iCloud login prompt appears:** Just dismiss it. Some older iPads ask repeatedly — keep dismissing, there's nothing else to do.
- **Do not log out of OST Remote.** Logging back in requires an internet connection, so if the connection is down you'll be stuck on paper until it returns. Unless CommsHQ tells you to, never log out.
- **Keep the iPad dry.** Wet touchscreens behave unpredictably. A gallon zip bag or a sheet protector taped over the screen makes a fine rain shield.
- **Cold or direct sun:** Cold drains the battery fast — tuck the iPad into an insulating layer during lulls. Direct sun can overheat it — move it into the shade to cool.
- **Lost data connection:** Keep recording every runner on paper and keep entering them in OST if you can. Relay bib numbers and times to CommsHQ (see Secondary Runner Tracking in the Protocols section). Sync everything once the connection returns.
- **Total equipment failure:** Fall back to the paper form, relay runner info to CommsHQ, and keep tracking until you've reconciled and been released — replacement equipment or instructions may come from CommsHQ.
