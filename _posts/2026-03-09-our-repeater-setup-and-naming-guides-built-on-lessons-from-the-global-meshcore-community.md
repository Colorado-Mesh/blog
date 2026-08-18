---
layout: post
title: "Our Repeater Setup and Naming Guides: Built on Lessons from the Global MeshCore Community"
date: 2026-03-09
description: How Colorado Mesh developed a scalable naming convention
tags:
  - meshcore
---

If you've used our [naming standard wizard][repeater_naming_tool], you might wonder where this stuff comes from. It
didn't appear out of thin air. These guides are built on real-world experience from mesh communities around the world,
and we want to give credit where it's due.

### The Australian Connection

The MeshCore community in New South Wales, Australia was one of the first to tackle a problem every growing mesh network
eventually faces: how do you keep dozens of repeaters from stepping on each other?

MeshCore itself was created by **Scott Powell** of [Ripple Radios](https://rippleradios.wordpress.com/) in Melbourne,
Australia, so it's no surprise that some of the earliest and most sophisticated deployment guides came from Australian
operators.

The [MeshSydney](https://meshsydney.com/wiki) community and the broader [NSW Mesh Users Group](https://nswmesh.au/), a
collection of experimenters, bushwalkers, emergency-comms enthusiasts, and tinkerers around the Sydney metro area, built
out a network of repeaters across varying terrain. Hills, harbors, suburbs, dense urban cores. Sound familiar? Swap the
harbor for the Front Range and you've got Denver.

Their [NSW Meshcore Configuration Guide](https://meshsydney.com/wiki) was one of the first to develop **elevation-based
delay profiles** for MeshCore repeaters, a systematic approach to configuring `txdelay` and `rxdelay` values based on
where a node sits in the network hierarchy. They established role-based profiles: BACKBONE, CRITICAL, LINK, STANDARD,
LOCAL, and MOBILE, each tuned for a specific type of deployment with values like `txdelay 2.0` for hilltop nodes and
`txdelay 0.3` for local ground-level installations.

We adapted their profiles for Colorado's geography, renaming CRITICAL to HILLTOP, LINK to FOOTHILLS, etc. The txdelay
values are nearly identical because the physics doesn't change between hemispheres, the strategy of making higher nodes
wait longer works everywhere.

### Why Repeater Tuning Matters

When you have a single repeater on a hilltop, configuration is simple. But when you have a network of repeaters at
different elevations covering overlapping areas, you need a strategy. Without one, here's what happens:

- **Packet collisions**: Multiple repeaters hear the same message and retransmit simultaneously, corrupting each other's
  signals.
- **Wasted airtime**: A high-elevation backbone repeater retransmits a message that a local rooftop node already
  delivered to the recipient.
- **Unreliable delivery**: Messages bounce around unpredictably instead of taking clean paths through the mesh.

The solution is deceptively simple: **make higher nodes wait longer before retransmitting**.

#### txdelay: The Polite Pause

The `txdelay` setting controls how long a repeater waits before retransmitting a flood packet it received. The actual
delay is randomized within a window proportional to the setting, so two nodes with the same txdelay won't always
collide.

A hilltop backbone repeater with `txdelay 2` creates a wider random window than a rooftop edge node with `txdelay 0.8`.
The edge node is statistically more likely to retransmit first. Both nodes will still retransmit the packet once —
MeshCore does not cancel queued retransmissions — but the staggered timing reduces the chance of collisions. Combined
with `rxdelay`, which can cause weaker copies to be dropped as duplicates before they're ever queued for retransmission,
the net effect is that local nodes tend to handle local traffic while backbone nodes provide coverage for longer-range
hops.

#### rxdelay: Signal-Quality Filtering

The `rxdelay` setting adds a processing delay to flood packets based on signal quality (SNR). Strong signals get
processed immediately. Weak signals get delayed, and often dropped as duplicates before they're ever retransmitted.

The effect: the mesh naturally prefers the strongest, cleanest paths without any manual routing. All Denver repeaters
use `rxdelay 3`.

#### agc.reset.interval: Radio Deafness Prevention

One setting that doesn't get enough attention is `agc.reset.interval`. The SX1262 LoRa chip's Automatic Gain Control can
lock up when exposed to strong out-of-band RF interference (think broadcast towers, cell sites, or other transmitters
near your repeater). When this happens, the noise floor clamps at -120 dBm and the repeater goes "deaf," unable to hear
weaker signals until it's physically rebooted.

The fix is simple: `agc.reset.interval` periodically resets the AGC so the radio can recover automatically. The AGC is
also reset after every transmission, so this mainly matters for repeaters that go long periods without transmitting —
exactly the behavior you want from a well-tuned hilltop node with a high txdelay.

The MeshCore FAQ recommends a value of `4` (seconds) for the most aggressive recovery, while MeshSydney uses `500` (~8
minutes) for a conservative approach that minimizes any chance of packet loss. All Denver repeaters use
`agc.reset.interval 500`, matching the Sydney recommendation.

#### The Five Profiles

Our guide defines five profiles adapted from the Australian model:

|  Profile  | txdelay |                    Best For                     |
|:---------:|:-------:|:-----------------------------------------------:|
|  HILLTOP  |   2.0   |      Mountain peaks, towers. The backbone.      |
| FOOTHILLS |   1.5   |   Mid-elevation. Bridges hilltops to suburbs.   |
| SUBURBAN  |   0.8   |            Typical rooftop install.             |
|   LOCAL   |   0.3   |      Indoor, ground-level. Few neighbors.       |
|  MOBILE   |   3.0   | Vehicles, hiking. Always defers to fixed nodes. |

### The Naming Standard

As the network grows, so does the need to know what you're looking at. When you see a node on the mesh, its name should
tell you where it is, what it does, and how to identify it.

Our [naming standard][naming_standard] was developed by the Colorado Mesh community and is used by
the [Colorado Mesh utilities site][utilities_site]:

```markdown
[REGION]-[CITY]-[LANDMARK]-[TYPE]-[PUBKEY]
```

Each piece serves a purpose:

- **REGION** uses [IATA airport codes](https://en.wikipedia.org/wiki/List_of_airports_in_Colorado) (DEN, COS, FNL,
  etc.), universally recognized identifiers that immediately tell you the general area.
- **CITY** is a 1-5 character abbreviation (DENVR, GLDN, LKWD). Can be dropped if the landmark is prominent enough on
  its own.
- **LANDMARK** is where the node physically sits, a park, intersection, mountain, or building (CHSPK, RDRKS, SLOAN).
- **TYPE** identifies the node's role: RC (core repeater), RD (distribution), RE (edge), RM (mobile), TS (room server),
  TM (mobile room), or TR (room + repeat).
- **PUBKEY** is the first 4 hex characters of the node's public key, guaranteeing uniqueness across the mesh.

A name like `DEN-GLDN-LKOUT-RC-4D0C` tells you everything at a glance: Denver region, Golden, Lookout Mountain, core
repeater, public key prefix 4D0C.

#### Why Not Just Name It Whatever?

Without a standard, you get names like "Bob's Node" and "test123" and "Repeater2." When you're troubleshooting a routing
issue or trying to figure out why a message took 6 hops instead of 3, those names tell you nothing. A consistent naming
convention lets operators and community members:

- Identify node location without looking up a map
- Understand node role from the type code
- Trace routes using the public key prefix
- Avoid conflicts since the pubkey suffix guarantees uniqueness

#### Companion Naming

Personal carry nodes (companions) use a different format:

```markdown
[EMOJI] [HANDLE] [SUFFIX]
```

Like `M3SHGHST 01` or `SQRLNUT F4`. The emoji is your personal identifier across all your devices, the handle is your
mesh alias (never your real name since nodes broadcast GPS), and the suffix identifies the specific device by number,
role, or public key prefix.

Our [companion naming wizard][companion_naming_tool] handles both infrastructure and companion naming with an
interactive builder that validates against the standard in real time.

### Standing on Shoulders

Mesh networking is inherently collaborative. The whole point is that the network gets stronger with every node. The same
applies to the knowledge behind it.

The [MeshSydney](https://meshsydney.com/wiki) community figured out elevation-based delay profiles through real-world
testing across Sydney's
terrain. [W6HS](https://w6hs.net/meshcore-repeater-deployment-timing-considerations-for-wide-area-networks/) wrote an
excellent deep dive on the timing math behind repeater deployment. Other Australian communities
like [Mesh Brisbane (MBUG)](https://wiki.mbug.com.au/) and [HiveMesh](https://hivemesh.au/) continue to push the
boundaries of what community mesh networks can do. We brought these lessons together into guides that work for our
network.

If you're starting a mesh community in your area, you don't have to reinvent this. Take what works, adapt it to your
geography, and share what you learn. The [LetsMesh forum](https://forum.letsmesh.net/) maintains a list of MeshCore
communities worldwide if you want to connect with others doing the same thing.

[utilities_site]: https://tools.meshcore.coloradomesh.org
[repeater_naming_tool]: https://tools.meshcore.coloradomesh.org/repeater_name_tool/
[companion_naming_tool]: https://tools.meshcore.coloradomesh.org/companion_name_tool/
[naming_standard]: https://github.com/Colorado-Mesh/organization/blob/master/Standards/MeshCore/naming/Current.md