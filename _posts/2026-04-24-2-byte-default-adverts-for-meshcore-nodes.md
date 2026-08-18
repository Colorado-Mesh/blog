---
layout: post
title:  "2-Byte Default Adverts for MeshCore Nodes"
date:   2026-04-24
description: Colorado Mesh MeshCore now using 2-byte adverts
tags:
  - meshcore
  - announcements
---

## 2-Byte Default Adverts for MeshCore Nodes

On **April 24, 2026**, the Colorado Mesh community has officially required all MeshCore nodes (companions, repeaters, room servers) to switch to using 2-byte adverts to prevent close-proximity message collisions on the network.

Please update your repeaters and set `path.hash.mode` to `1`.

#### Relevant Commands:

- `get path.hash.mode`
- `set path.hash.mode 1`

Nodes running firmware v1.14+ will automatically default to this. This has also been set as a statewide default in MeshMapper.

For reference:

- `path.hash.mode 0` = 1-byte
- `path.hash.mode 1` = 2-byte
- `path.hash.mode 2` = 3-byte

Please see our `#meshcore` channel in the [Discord][discord] for more information.

[discord]: https://discord.coloradomesh.org