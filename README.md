# Prevent - Staff Monitoring System

## 📋 Description

Prevent is a resource (mod) for **Multi Theft Auto: San Andreas** designed to facilitate player monitoring by the administration team. The system provides advanced surveillance and spectating tools for staff members.

**Author:** Rougue#8075  
**Version:** 1.0  
**Type:** System Script

---

## 🎯 Main Features

### 1. **Wall Hack (See-Through-Walls Vision)**
- Displays player names, health, and armor even when out of sight
- Shows relative player position relative to camera
- Displays nearby vehicles with their distance
- Available only for staff members (Admin and Console)
- Real-time camera position synchronization

### 2. **Advanced Spectate Mode (/spec)**
- Watch other players in real-time
- Player name search with partial name matching
- Automatic freezing of staff member during spectate
- Full vehicle spectate support
- Synchronized camera system between staff and target

### 3. **Utility Features**
- `/name` - Copy targeted player's name to clipboard
- Automatic command help on resource start
- Server activity logging
- Clipboard integration for convenient name copying

---

## 📝 Available Commands

| Command | Description |
|---------|-----------|
| `/wall` | Activate wall hack (see-through-walls vision) |
| `/spec [player]` | Start spectating a player |
| `/spec` | Stop spectating |
| `/name` | Copy spectated player's name to clipboard |
| `/spechelp` | Show all available commands |

---

## 🔐 Access Permissions

All commands are restricted to:
- Members of the **Admin** group (ACL)
- Members of the **Console** group (ACL)

Unauthorized users will receive no response when attempting commands.

---

## 📂 File Structure

```
Prevent/
├── c_prevent.lua      # Client-side script (runs on player's computer)
├── s_prevent.lua      # Server-side script (manages permissions & sync)
├── meta.xml           # Resource metadata file
├── Lato-Thin.ttf      # Custom font for UI rendering
└── README.md          # This file
```

---

## ⚙️ Technical Details

### Client-Side (c_prevent.lua)
- Player information rendering with health, armor, and distance display
- Real-time camera event handling
- Camera position synchronization (20ms intervals)
- Screen-space coordinate calculations
- Player spawn event handling to reset wall hack state
- Clipboard integration for player name copying

### Server-Side (s_prevent.lua)
- ACL-based permission management
- Command validation and execution
- Player name search functionality with partial matching
- Camera synchronization between staff and spectated players
- Player freezing during spectate mode
- Server-side logging of all staff actions

### Core Functions

**Client:**
- `wall()` - Main rendering loop for player/vehicle information
- `ligar()` - Toggle wall hack on/off
- `camera()` - Handle camera position updates
- `staffCam()` - Set camera target position
- `copiarNome()` - Copy player name to clipboard

**Server:**
- `getPlayerFromPartialName()` - Search players by partial name
- `AtivaWall()` - Toggle wall hack on server
- `spec()` - Spectate command handler
- `staffCam()` - Server-side camera coordinator

### Minimum Requirements
- MTA San Andreas 1.5.6-9.18728 (Server and Client)

---

## 🚀 Installation

1. Place the `Prevent` folder in:
   ```
   server/mods/deathmatch/resources/
   ```

2. Start the server or execute:
   ```
   /start Prevent
   ```

3. The resource will load automatically and commands will be available for staff members

---

## 📊 Performance

- **Update Interval:** 20ms (configurable via `INTERVAL` constant)
- **Vision Range:** 500 meters
- **Rendering:** Only for elements within range

To improve performance, increase the `INTERVAL` value in `c_prevent.lua`.

---

## 🎮 Usage Examples

### Using Walls
```
/wall              // Enable walls - now see all players within 500m
```

### Spectating Players
```
/spec Player       // Start spectating "Player" or partial name match
/spec              // Stop spectating and return to normal view
/spechelp          // Show command list
```

### Copying Player Names
```
/spec SomePlayer   // Start spectating
/name              // Copy "SomePlayer" to clipboard (Ctrl+V)
```

---

## 📌 Important Notes

⚠️ **This is an administrative script intended only for legitimate player monitoring.**

- Use only with proper server authorization
- Respect player privacy
- Maintain proper usage records
- Notify your community about monitoring tools in use
- This resource should be audited regularly for abuse

---

## 🐛 Troubleshooting

### Commands not working
- Verify your account is in the correct ACL group (Admin or Console)
- Confirm the resource is started: `/status`
- Check server console for error messages

### Wall hack shows no players
- Ensure `Prevent` resource is active
- Verify there are players within 500 meters
- Check that wall hack is toggled on with `/wall`

### Spectate not working
- Use partial player names (e.g., `/spec playerpart`)
- Ensure you're not trying to spectate yourself
- Verify the target player is online

### Performance issues
- Increase `INTERVAL` value in `c_prevent.lua` for less frequent updates
- Reduce the 500-meter range if needed
- Consider reducing update frequency on high-player servers

---

## 🔧 Configuration

### Adjustable Parameters

In `c_prevent.lua`:
```lua
local INTERVAL = 20  -- Update interval in milliseconds (increase for better performance)
local fontSize = 1   -- Text size for player information display
```

In `s_prevent.lua`:
```lua
-- Vision range is hardcoded to 500 meters in the wall() function
-- Modify getElementsWithinRange calls to change this value
```

---

## 📞 Support

For questions or issues, contact the developer:
- **Discord:** Rougue#8075

---

**Last Updated:** February 2026
