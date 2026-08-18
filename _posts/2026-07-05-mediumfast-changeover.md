---
layout: post
title:  "MediumFast Changeover"
date:   2026-07-05
description: Denver Metro area has changed to MediumFast on Meshtastic
tags:
  - meshtastic
  - announcements
---

Our Denver Metro local Meshtastic network has grown beyond just a handful of nodes. We're starting to experience issues like delayed message delivery, network congestion, or inconsistent results, and the problem is our LoRa radio preset. Specifically, we have outgrown the default preset: LongFast.

While LongFast is an excellent general-purpose preset for many users, it may not be the optimal choice for larger or denser meshes.

Please see this Meshtastic page on [Understanding LoRa Presets](https://meshtastic.org/blog/why-your-mesh-should-switch-from-longfast/#understanding-lora-presets).

### The Issue with LongFast

While LongFast offers great range, it has drawbacks that become increasingly problematic as your mesh grows, including:

- **Increased Airtime**: LongFast messages stay "on the air" longer than some of the faster presets, consuming precious channel time. With slower data rates, each transmission occupies the channel longer, preventing other nodes from transmitting during this window.
- **Higher Collision Probability**: When multiple nodes try to transmit in a busy network, the chance of packet collisions increases dramatically with slower presets because each transmission blocks the channel for longer.
- **Reduced Throughput**: The combination of the aforementioned factors leads to lower effective throughput across your entire mesh, even though LongFast seems like it should deliver messages reliably. In a larger or denser network, this can result in service interruption and frustrations for users.

Benefits of higher bandwidth presets include:

- **Reduced Airtime**: Messages are transmitted faster, freeing up the channel for other nodes to communicate. 
- **Lower Collision Probability**: With shorter transmission times, there's less chance that two nodes will try to transmit simultaneously.
- **Better Scalability**: Higher bandwidth presets are designed to handle more nodes and higher message volumes, making them more suitable for larger deployments. In dense networks, the improved throughput often more than compensates for the slightly reduced range, resulting in better overall message delivery.
- **Lower Latency**: Messages travel through the mesh more quickly, reducing delays that can be frustrating for users.

MediumFast strikes an excellent balance between range and speed, offering 3-4 times the data rate of LongFast while still maintaining respectable range.

### Making the Change
Switching presets is straightforward but requires updating all nodes in your mesh:

- **Web UI**: Navigate to `Radio > LoRa` and change the "Modem Preset" dropdown
- **Meshtastic CLI**: Use the command `meshtastic --set lora.modem_preset MEDIUM_FAST` or similar
- **Android/iOS App**: Go to `Settings > Radio > LoRa > Modem Preset`

Remember: All nodes in your mesh should use the same preset in order to remain in the network.

Please see our `#meshtastic` channel on [Discord][discord] for more information, or any assistance needed with making the switch. The general idea is that the Colorado Mesh community will still maintain some nodes on the default LongFast preset, that will direct newcomers to make the switch to MediumFast.

[discord]: [https://jekyllrb.com/docs/home](https://discord.coloradomesh.org)