# NMEA0183 Protocol Documentation

## Overview

This document details the NMEA0183 protocol requirements for autopilot control and Course Over Ground (COG) adjustment in the Autohelm App. The application communicates with marine autopilot systems via a Yacht Device WiFi Gateway using standard NMEA0183 sentences over TCP/IP.

## Table of Contents

1. [NMEA0183 Background](#nmea0183-background)
2. [Message Format](#message-format)
3. [Checksum Calculation](#checksum-calculation)
4. [Heading Sentences](#heading-sentences)
5. [Autopilot Command Sentences](#autopilot-command-sentences)
6. [Yacht Device Gateway Specifics](#yacht-device-gateway-specifics)
7. [Protocol State Machine](#protocol-state-machine)
8. [Error Handling](#error-handling)
9. [Example Messages](#example-messages)
10. [Implementation Examples](#implementation-examples)

## NMEA0183 Background

NMEA0183 is a combined electrical and data specification for communication between marine electronics such as echo sounders, sonars, anemometers, gyrocompasses, autopilots, GPS receivers, and many other types of instruments.

### Key Characteristics

- **Protocol Type**: ASCII-based serial communication protocol
- **Data Rate**: Typically 4800 baud (default for most devices)
- **Data Format**: 8 data bits, no parity, 1 stop bit (8N1)
- **Line Termination**: Carriage Return + Line Feed (CR+LF, `\r\n`)
- **Maximum Sentence Length**: 82 characters (including $ and CR+LF)

## Message Format

### Standard Sentence Structure

All NMEA0183 sentences follow this general format:

```
$<Talker ID><Sentence ID>,<Data Field 1>,<Data Field 2>,...,<Data Field N>*<Checksum><CR><LF>
```

### Components

- **Start Delimiter**: `$` (ASCII 0x24)
- **Talker ID**: 2-character identifier indicating the source device
  - `GP` - Global Positioning System (GPS)
  - `HC` - Heading - Magnetic Compass
  - `HE` - Heading - North Seeking Gyro
  - `AP` - Autopilot (General)
  - `AG` - Autopilot (Heading Track Controller)
  - `II` - Integrated Instrumentation
- **Sentence ID**: 3-character sentence formatter identifier
- **Data Fields**: Comma-separated values (may be empty)
- **Checksum Delimiter**: `*` (ASCII 0x2A)
- **Checksum**: 2-digit hexadecimal value
- **Terminator**: `<CR><LF>` (ASCII 0x0D 0x0A)

### Example Breakdown

```
$GPHDG,270.5,,,0.5,E*30\r\n
│││└─┬─┘ └─┬─┘ └┬┘└┬┘│ │
││└──┘    │    │  │ │ └─ Line terminator (CR+LF)
││       │    │  │ └─── Checksum
│└──────┘    │  └───── Magnetic variation direction (E/W)
│           └──────── Magnetic variation in degrees
└─────────────────── Start delimiter and Talker/Sentence ID
```

## Checksum Calculation

The checksum is calculated as an 8-bit XOR of all characters between `$` and `*` (exclusive).

### Algorithm

1. Initialize checksum to 0
2. For each character between `$` and `*` (not including delimiters):
   - XOR the checksum with the ASCII value of the character
3. Convert the final checksum to a 2-digit hexadecimal string (uppercase)

### Example Calculation

For sentence: `$GPHDG,270.5,,,0.5,E*30`

```
Characters: GPHDG,270.5,,,0.5,E
Checksum calculation:
  'G' (0x47) XOR 0x00 = 0x47
  'P' (0x50) XOR 0x47 = 0x17
  'H' (0x48) XOR 0x17 = 0x5F
  ... (continue for all characters)
  Final result: 0x30
  Hexadecimal: "30"
```

### Validation

When receiving a sentence:
1. Extract the transmitted checksum (after `*`)
2. Calculate the checksum of the data
3. Compare: if they match, the sentence is valid

## Heading Sentences

These sentences provide the current heading/course information needed to display COG.

### HDG - Heading, Deviation & Variation

Reports magnetic sensor heading with deviation and variation.

**Format:**
```
$--HDG,x.x,x.x,a,x.x,a*hh<CR><LF>
```

**Fields:**
1. Magnetic sensor heading (0.0 to 359.9 degrees)
2. Magnetic deviation (degrees)
3. Magnetic deviation direction (E = East, W = West)
4. Magnetic variation (degrees)
5. Magnetic variation direction (E = East, W = West)
6. Checksum

**Example:**
```
$HCHDG,270.5,0.0,E,5.5,W*50
```
*Interpretation: Heading 270.5° magnetic, no deviation, 5.5° westerly variation*

### HDM - Heading, Magnetic

Vessel heading in degrees magnetic (simpler than HDG).

**Format:**
```
$--HDM,x.x,M*hh<CR><LF>
```

**Fields:**
1. Heading in degrees (0.0 to 359.9)
2. M = Magnetic

**Example:**
```
$HCHDM,265.0,M*28
```
*Interpretation: Heading 265.0° magnetic*

### HDT - Heading, True

Vessel heading in degrees true.

**Format:**
```
$--HDT,x.x,T*hh<CR><LF>
```

**Fields:**
1. Heading in degrees (0.0 to 359.9)
2. T = True

**Example:**
```
$HCHDT,259.5,T*22
```
*Interpretation: Heading 259.5° true*

### Recommended Usage for COG Display

For this application, **HDG or HDM** are recommended as they provide magnetic heading which is standard for autopilot systems. The app should:
1. Subscribe to HDG, HDM, and HDT sentences
2. Prefer HDG (most complete) if available
3. Fall back to HDM or HDT if HDG not available
4. Update COG display in real-time as sentences arrive

## Autopilot Command Sentences

These sentences control autopilot behavior and course changes.

### APB - Autopilot Sentence "B"

Provides autopilot cross-track error, waypoint arrival status, and course information.

**Format:**
```
$--APB,A,A,x.x,a,N,A,A,x.x,a,c--c,x.x,a,x.x,a,a*hh<CR><LF>
```

**Fields:**
1. Status: A = Data valid, V = Loran-C Blink or SNR warning
2. Status: A = Data valid, V = Loran-C Cycle Lock warning
3. Cross Track Error Magnitude
4. Direction to steer (L/R)
5. Cross Track Units (N = Nautical miles, K = Kilometers)
6. Status: A = Arrival circle entered
7. Status: A = Perpendicular passed at waypoint
8. Bearing origin to destination (degrees)
9. Bearing type (M = Magnetic, T = True)
10. Destination waypoint ID
11. Bearing, present position to destination (degrees)
12. Bearing type (M = Magnetic, T = True)
13. Heading to steer to destination (degrees)
14. Heading type (M = Magnetic, T = True)
15. Mode indicator (A = Autonomous, D = Differential, E = Estimated)

**Example:**
```
$GPAPB,A,A,0.10,R,N,V,V,011.5,M,DEST,280.5,M,281.0,M,A*4E
```

### RMB - Recommended Minimum Navigation Information

Provides recommended navigation to a waypoint.

**Format:**
```
$--RMB,A,x.x,a,c--c,c--c,llll.ll,a,yyyyy.yy,a,x.x,x.x,x.x,A,a*hh<CR><LF>
```

**Example:**
```
$GPRMB,A,0.66,L,003,004,4917.24,N,12309.57,W,001.3,052.5,000.5,V,A*4D
```

### Proprietary Autopilot Sentences

Many autopilot manufacturers use proprietary sentences for direct control. Common formats:

#### Raymarine/Autohelm Proprietary Commands

Raymarine autopilots typically use **$STALK** proprietary sentences for SeaTalk protocol, but when using NMEA0183, they accept standard course change commands through:

**Simrad/Navico Format:**
```
$PSRF,CMD,VALUE*hh
```

**Common Raymarine NMEA Commands:**

1. **Course Change Command** (simplified approach):
```
$APHDM,<new_heading>,M*hh
```
Where `<new_heading>` is the desired magnetic heading.

2. **Relative Course Change** (if supported):
```
$APXTE,+10*hh   # Turn +10 degrees
$APXTE,-01*hh   # Turn -1 degree
```

### Recommended Approach for COG Adjustment

For this application, the recommended approach is:

1. **Read current heading** from HDG/HDM/HDT sentences
2. **Calculate new heading**: 
   - For +1°: `new_heading = (current_heading + 1) % 360`
   - For -1°: `new_heading = (current_heading - 1 + 360) % 360`
   - For +10°: `new_heading = (current_heading + 10) % 360`
   - For -10°: `new_heading = (current_heading - 10 + 360) % 360`
3. **Send new heading command**:
   ```
   $APHDM,<new_heading>,M*<checksum>
   ```

**Note:** The exact command sentence may vary by autopilot manufacturer. During hardware testing (Issue #15), verify which command sentence the autopilot accepts.

## Yacht Device Gateway Specifics

### Connection Parameters

The Yacht Device NMEA 0183 WiFi Gateway provides a TCP/IP bridge to NMEA0183 devices.

**Default Network Settings:**
- **Protocol**: TCP/IP
- **Default IP**: 192.168.4.1 (Access Point mode) or DHCP-assigned (Client mode)
- **Default Port**: 1457 (TCP)
- **Baud Rate**: 4800, 38400, or 115200 (configurable)
- **WiFi Mode**: Access Point or WiFi Client

### Connection Modes

#### Access Point Mode (Default)
- Gateway creates its own WiFi network
- SSID: `ydwg-XXXXXX` (where XXXXXX is device serial)
- Default Password: Printed on device label
- Gateway IP: 192.168.4.1
- Mobile device connects to gateway WiFi

#### Client Mode
- Gateway connects to existing WiFi network
- Obtains IP via DHCP or static configuration
- Mobile device connects to same WiFi network
- Use gateway's assigned IP address

### Communication Flow

```
Mobile App <--TCP/IP--> Yacht Device Gateway <--NMEA0183--> Autopilot
           (Port 1457)                      (Serial)
```

### Data Transmission

- **Outgoing (App → Autopilot)**: Send NMEA sentences as ASCII strings via TCP socket
- **Incoming (Autopilot → App)**: Receive continuous stream of NMEA sentences
- **Sentence Rate**: Typically 1-10 Hz depending on sentence type
- **Buffer Management**: Implement circular buffer to handle bursts

### Configuration

Access gateway web interface at `http://<gateway-ip>` to configure:
- WiFi settings (AP or Client mode)
- TCP port (default 1457)
- Serial baud rate (match autopilot settings)
- NMEA0183 filters (which sentences to forward)

## Protocol State Machine

The application follows this state machine for NMEA communication:

```
┌─────────────┐
│ DISCONNECTED│◄─────────┐
└──────┬──────┘          │
       │ connect()       │ disconnect()
       ▼                 │ or error
┌─────────────┐          │
│ CONNECTING  │──────────┤
└──────┬──────┘  timeout │
       │ connected        │
       ▼                 │
┌─────────────┐          │
│  CONNECTED  │          │
└──────┬──────┘          │
       │ sentence         │
       │ received        │
       ▼                 │
┌─────────────┐          │
│  LISTENING  │──────────┤
└──────┬──────┘          │
       │                 │
       │ send command    │
       ▼                 │
┌─────────────┐          │
│  SENDING    │          │
└──────┬──────┘          │
       │ ack/timeout     │
       ▼                 │
┌─────────────┐          │
│  LISTENING  │──────────┘
└─────────────┘
```

### State Descriptions

1. **DISCONNECTED**: No connection to gateway
   - Actions: Display "Not Connected" status
   - Transitions: User initiates connection → CONNECTING

2. **CONNECTING**: Attempting TCP connection to gateway
   - Actions: Show "Connecting..." status
   - Transitions: 
     - Success → CONNECTED
     - Timeout/Error → DISCONNECTED

3. **CONNECTED**: TCP connection established
   - Actions: Start listening for NMEA sentences
   - Transitions: Immediate → LISTENING

4. **LISTENING**: Receiving and parsing NMEA sentences
   - Actions: 
     - Parse incoming sentences
     - Update COG display
     - Process autopilot status
   - Transitions:
     - User presses button → SENDING
     - Connection lost → DISCONNECTED

5. **SENDING**: Transmitting course change command
   - Actions:
     - Calculate new heading
     - Format NMEA command
     - Send via TCP socket
     - Wait for acknowledgment (optional)
   - Transitions:
     - Command sent → LISTENING
     - Timeout/Error → LISTENING (with error indicator)

### Message Flow Sequence

```
App                     Gateway                 Autopilot
 │                         │                         │
 ├─TCP Connect────────────►│                         │
 │◄─Connected──────────────┤                         │
 │                         │                         │
 │◄────HDG Sentence────────┤◄────HDG Sentence────────┤
 │  (continuous stream)    │  (continuous stream)    │
 │                         │                         │
 ├─User presses +10°       │                         │
 │  button                 │                         │
 ├─Calculate new heading   │                         │
 │  (current + 10)         │                         │
 ├─Format NMEA command─────►│─────NMEA command───────►│
 │  $APHDM,280,M*XX        │  $APHDM,280,M*XX        │
 │                         │                         │
 │◄────HDG Sentence────────┤◄────HDG Sentence────────┤
 │  (updated heading)      │  (updated heading)      │
 │                         │                         │
```

## Error Handling

### Error Types and Handling Strategies

#### 1. Connection Errors

**Error**: Cannot connect to gateway
- **Causes**: Wrong IP, gateway offline, network issues
- **Detection**: TCP connection timeout
- **Handling**: 
  - Display error message: "Cannot connect to gateway"
  - Retry with exponential backoff (1s, 2s, 4s, 8s, max 30s)
  - Prompt user to check settings
- **Recovery**: User corrects settings or gateway comes online

#### 2. Checksum Validation Errors

**Error**: Received sentence has invalid checksum
- **Causes**: Transmission errors, interference
- **Detection**: Calculated checksum ≠ received checksum
- **Handling**:
  - Log error with sentence details
  - Discard invalid sentence
  - Continue listening
  - If error rate > 10%, display warning
- **Recovery**: Individual sentence errors are normal; high rates indicate issues

#### 3. Malformed Sentence Errors

**Error**: Sentence doesn't follow NMEA format
- **Causes**: Corrupted data, non-NMEA traffic
- **Detection**: Parsing fails, missing delimiters, invalid fields
- **Handling**:
  - Log warning
  - Discard sentence
  - Continue listening
- **Recovery**: Auto-recovery by continuing to next sentence

#### 4. Timeout Errors

**Error**: No data received within expected timeframe
- **Causes**: Autopilot offline, gateway disconnected, cable issues
- **Detection**: No sentences received for >5 seconds
- **Handling**:
  - Display warning: "No data from autopilot"
  - Continue listening
  - Implement TCP keepalive
- **Recovery**: Data resumes when issue resolved

#### 5. Command Acknowledgment Timeout

**Error**: Course change command sent but no response
- **Causes**: Autopilot busy, command rejected, cable issues
- **Detection**: No heading change detected after 3 seconds
- **Handling**:
  - Display status: "Command may not have been accepted"
  - Log event
  - Allow retry
- **Recovery**: User can retry command

#### 6. Unexpected Disconnect

**Error**: TCP connection drops during operation
- **Causes**: Gateway reset, network issues, WiFi signal loss
- **Detection**: Socket error, connection closed
- **Handling**:
  - Display: "Connection lost"
  - Attempt automatic reconnection
  - Notify user if reconnection fails
- **Recovery**: Automatic reconnect or user-initiated

### Error Code Summary

| Code | Error | Action |
|------|-------|--------|
| E001 | Connection timeout | Retry with backoff |
| E002 | Invalid checksum | Discard sentence |
| E003 | Malformed sentence | Log and continue |
| E004 | Data timeout | Display warning |
| E005 | Command timeout | Allow retry |
| E006 | Unexpected disconnect | Auto-reconnect |
| E007 | Invalid heading value | Display error, reject |
| E008 | Gateway not found | Check settings |

## Example Messages

### Incoming Sentences (from Autopilot)

#### Example 1: Heading Information
```
$HCHDG,270.5,0.0,E,5.5,W*2A\r\n
```
**Meaning**: Current magnetic heading is 270.5°, with 5.5° westerly variation

#### Example 2: Magnetic Heading Only
```
$HCHDM,265.0,M*3F\r\n
```
**Meaning**: Current magnetic heading is 265.0°

#### Example 3: True Heading
```
$HCHDT,259.5,T*1B\r\n
```
**Meaning**: Current true heading is 259.5°

#### Example 4: GPS Position (context)
```
$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47\r\n
```
**Meaning**: GPS fix data (useful for debugging but not required for COG adjustment)

### Outgoing Commands (to Autopilot)

#### Example 1: Set Heading to 271° (from 270° +1°)
```
$APHDM,271.0,M*37\r\n
```
**Meaning**: Command autopilot to steer to 271.0° magnetic

#### Example 2: Set Heading to 269° (from 270° -1°)
```
$APHDM,269.0,M*3E\r\n
```
**Meaning**: Command autopilot to steer to 269.0° magnetic

#### Example 3: Set Heading to 280° (from 270° +10°)
```
$APHDM,280.0,M*39\r\n
```
**Meaning**: Command autopilot to steer to 280.0° magnetic

#### Example 4: Set Heading to 260° (from 270° -10°)
```
$APHDM,260.0,M*37\r\n
```
**Meaning**: Command autopilot to steer to 260.0° magnetic

#### Example 5: Wraparound Case - 359° +10° = 9°
```
$APHDM,9.0,M*3A\r\n
```
**Meaning**: Command autopilot to steer to 9.0° magnetic

#### Example 6: Wraparound Case - 5° -10° = 355°
```
$APHDM,355.0,M*30\r\n
```
**Meaning**: Command autopilot to steer to 355.0° magnetic

### Complete Session Example

```
# App connects to gateway
→ TCP Connect to 192.168.4.1:1457

# Gateway sends continuous heading updates
← $HCHDG,270.0,0.0,E,5.5,W*55\r\n
← $HCHDG,270.1,0.0,E,5.5,W*54\r\n
← $HCHDG,270.2,0.0,E,5.5,W*57\r\n

# User presses +10° button
# App calculates: 270.2 + 10 = 280.2
→ $APHDM,280.2,M*3B\r\n

# Gateway confirms with updated heading
← $HCHDG,270.5,0.0,E,5.5,W*50\r\n
← $HCHDG,272.0,0.0,E,5.5,W*57\r\n
← $HCHDG,275.5,0.0,E,5.5,W*55\r\n
← $HCHDG,278.0,0.0,E,5.5,W*5D\r\n
← $HCHDG,280.0,0.0,E,5.5,W*5A\r\n  # Reached target
← $HCHDG,280.1,0.0,E,5.5,W*5B\r\n
← $HCHDG,280.2,0.0,E,5.5,W*58\r\n  # Stabilized
```

## Implementation Examples

This section provides reference implementations in Rust demonstrating key NMEA0183 protocol operations.

### Example 1: Checksum Calculation

```rust
/// Calculate NMEA0183 checksum for a sentence
/// 
/// The checksum is the XOR of all bytes between '$' and '*' (exclusive)
/// 
/// # Arguments
/// * `sentence` - NMEA sentence without '$' prefix and '*XX' checksum suffix
/// 
/// # Returns
/// * Two-character hexadecimal checksum string (uppercase)
/// 
/// # Example
/// ```
/// let sentence = "GPHDG,270.5,,,0.5,E";
/// let checksum = calculate_checksum(sentence);
/// assert_eq!(checksum, "30");
/// ```
fn calculate_checksum(sentence: &str) -> String {
    let checksum = sentence
        .bytes()
        .fold(0u8, |acc, byte| acc ^ byte);
    
    format!("{:02X}", checksum)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_checksum_calculation() {
        assert_eq!(calculate_checksum("GPHDG,270.5,,,0.5,E"), "30");
        assert_eq!(calculate_checksum("HCHDM,265.0,M"), "28");
        assert_eq!(calculate_checksum("APHDM,280.0,M"), "39");
    }
}
```

### Example 2: Sentence Validation

```rust
/// Validate a complete NMEA0183 sentence
/// 
/// Checks for proper format and valid checksum
/// 
/// # Arguments
/// * `sentence` - Complete NMEA sentence including '$' and '*XX\r\n'
/// 
/// # Returns
/// * `Ok(())` if valid, `Err(String)` with error description if invalid
/// 
/// # Example
/// ```
/// let valid = "$HCHDM,265.0,M*3F\r\n";
/// assert!(validate_sentence(valid).is_ok());
/// 
/// let invalid = "$HCHDM,265.0,M*00\r\n";
/// assert!(validate_sentence(invalid).is_err());
/// ```
fn validate_sentence(sentence: &str) -> Result<(), String> {
    // Check minimum length
    if sentence.len() < 8 {
        return Err("Sentence too short".to_string());
    }
    
    // Check start delimiter
    if !sentence.starts_with('$') {
        return Err("Missing start delimiter '$'".to_string());
    }
    
    // Find checksum delimiter
    let checksum_pos = sentence.find('*')
        .ok_or("Missing checksum delimiter '*'")?;
    
    // Extract parts
    let data = &sentence[1..checksum_pos];
    let checksum_str = &sentence[checksum_pos + 1..checksum_pos + 3];
    
    // Calculate expected checksum
    let expected = calculate_checksum(data);
    
    // Validate checksum
    if checksum_str != expected {
        return Err(format!(
            "Invalid checksum: expected {}, got {}",
            expected, checksum_str
        ));
    }
    
    Ok(())
}

#[cfg(test)]
mod validation_tests {
    use super::*;

    #[test]
    fn test_valid_sentences() {
        assert!(validate_sentence("$HCHDM,265.0,M*28\r\n").is_ok());
        assert!(validate_sentence("$HCHDG,270.5,0.0,E,5.5,W*50\r\n").is_ok());
    }

    #[test]
    fn test_invalid_checksum() {
        assert!(validate_sentence("$HCHDM,265.0,M*00\r\n").is_err());
    }

    #[test]
    fn test_missing_delimiter() {
        assert!(validate_sentence("HCHDM,265.0,M*3F\r\n").is_err());
    }
}
```

### Example 3: Parse Heading from HDM Sentence

```rust
/// Parse heading value from HDM sentence
/// 
/// # Arguments
/// * `sentence` - Valid HDM sentence (e.g., "$HCHDM,265.0,M*3F")
/// 
/// # Returns
/// * `Ok(f64)` - Heading in degrees (0.0 to 359.9)
/// * `Err(String)` - Parse error description
/// 
/// # Example
/// ```
/// let heading = parse_hdm_heading("$HCHDM,265.0,M*3F\r\n")?;
/// assert_eq!(heading, 265.0);
/// ```
fn parse_hdm_heading(sentence: &str) -> Result<f64, String> {
    // Validate sentence first
    validate_sentence(sentence)?;
    
    // Extract data between $ and *
    let checksum_pos = sentence.find('*')
        .ok_or("Missing checksum delimiter")?;
    let data = &sentence[1..checksum_pos];
    
    // Split into fields
    let fields: Vec<&str> = data.split(',').collect();
    
    // Check sentence type
    if !fields[0].ends_with("HDM") {
        return Err(format!("Not an HDM sentence: {}", fields[0]));
    }
    
    // Parse heading (field 1)
    if fields.len() < 2 || fields[1].is_empty() {
        return Err("Missing heading value".to_string());
    }
    
    let heading: f64 = fields[1]
        .parse()
        .map_err(|e| format!("Invalid heading value: {}", e))?;
    
    // Validate range
    if heading < 0.0 || heading >= 360.0 {
        return Err(format!("Heading out of range: {}", heading));
    }
    
    Ok(heading)
}

#[cfg(test)]
mod parsing_tests {
    use super::*;

    #[test]
    fn test_parse_valid_hdm() {
        assert_eq!(parse_hdm_heading("$HCHDM,265.0,M*28\r\n").unwrap(), 265.0);
        assert_eq!(parse_hdm_heading("$HCHDM,0.0,M*29\r\n").unwrap(), 0.0);
        assert_eq!(parse_hdm_heading("$HCHDM,359.9,M*2F\r\n").unwrap(), 359.9);
    }

    #[test]
    fn test_parse_invalid_hdm() {
        assert!(parse_hdm_heading("$HCHDM,400.0,M*3F\r\n").is_err());
        assert!(parse_hdm_heading("$GPGGA,123519,N*00\r\n").is_err());
    }
}
```

### Example 4: Build Course Change Command

```rust
/// Build NMEA sentence to command new heading
/// 
/// # Arguments
/// * `new_heading` - Desired heading in degrees (0.0 to 359.9)
/// 
/// # Returns
/// * Complete NMEA sentence ready to send
/// 
/// # Example
/// ```
/// let command = build_heading_command(280.0);
/// assert_eq!(command, "$APHDM,280.0,M*33\r\n");
/// ```
fn build_heading_command(new_heading: f64) -> Result<String, String> {
    // Validate heading range
    if new_heading < 0.0 || new_heading >= 360.0 {
        return Err(format!("Heading out of range: {}", new_heading));
    }
    
    // Format data portion (without $ and checksum)
    let data = format!("APHDM,{:.1},M", new_heading);
    
    // Calculate checksum
    let checksum = calculate_checksum(&data);
    
    // Build complete sentence
    Ok(format!("${}*{}\r\n", data, checksum))
}

#[cfg(test)]
mod command_tests {
    use super::*;

    #[test]
    fn test_build_commands() {
        assert_eq!(
            build_heading_command(280.0).unwrap(),
            "$APHDM,280.0,M*39\r\n"
        );
        assert_eq!(
            build_heading_command(0.0).unwrap(),
            "$APHDM,0.0,M*33\r\n"
        );
    }

    #[test]
    fn test_invalid_heading() {
        assert!(build_heading_command(360.0).is_err());
        assert!(build_heading_command(-1.0).is_err());
    }
}
```

### Example 5: Calculate New Heading with Wraparound

```rust
/// Calculate new heading with proper wraparound
/// 
/// Handles wraparound at 0°/360° boundary
/// 
/// # Arguments
/// * `current_heading` - Current heading in degrees
/// * `adjustment` - Degrees to add (positive) or subtract (negative)
/// 
/// # Returns
/// * New heading in range [0.0, 360.0)
/// 
/// # Example
/// ```
/// assert_eq!(calculate_new_heading(270.0, 10.0), 280.0);
/// assert_eq!(calculate_new_heading(355.0, 10.0), 5.0);  // Wraparound
/// assert_eq!(calculate_new_heading(5.0, -10.0), 355.0); // Wraparound
/// ```
fn calculate_new_heading(current_heading: f64, adjustment: f64) -> f64 {
    let mut new_heading = current_heading + adjustment;
    
    // Handle wraparound
    while new_heading >= 360.0 {
        new_heading -= 360.0;
    }
    while new_heading < 0.0 {
        new_heading += 360.0;
    }
    
    new_heading
}

#[cfg(test)]
mod calculation_tests {
    use super::*;

    #[test]
    fn test_simple_additions() {
        assert_eq!(calculate_new_heading(270.0, 1.0), 271.0);
        assert_eq!(calculate_new_heading(270.0, 10.0), 280.0);
    }

    #[test]
    fn test_simple_subtractions() {
        assert_eq!(calculate_new_heading(270.0, -1.0), 269.0);
        assert_eq!(calculate_new_heading(270.0, -10.0), 260.0);
    }

    #[test]
    fn test_wraparound_forward() {
        assert_eq!(calculate_new_heading(355.0, 10.0), 5.0);
        assert_eq!(calculate_new_heading(359.0, 1.0), 0.0);
    }

    #[test]
    fn test_wraparound_backward() {
        assert_eq!(calculate_new_heading(5.0, -10.0), 355.0);
        assert_eq!(calculate_new_heading(0.0, -1.0), 359.0);
    }
}
```

### Example 6: Complete NMEA Client (Simplified)

```rust
use std::net::TcpStream;
use std::io::{BufReader, BufRead, Write};

/// Simple NMEA client for Yacht Device Gateway
struct NmeaClient {
    stream: Option<TcpStream>,
    gateway_address: String,
}

impl NmeaClient {
    /// Create new NMEA client
    fn new(gateway_ip: &str, port: u16) -> Self {
        NmeaClient {
            stream: None,
            gateway_address: format!("{}:{}", gateway_ip, port),
        }
    }
    
    /// Connect to gateway
    fn connect(&mut self) -> Result<(), String> {
        match TcpStream::connect(&self.gateway_address) {
            Ok(stream) => {
                self.stream = Some(stream);
                Ok(())
            }
            Err(e) => Err(format!("Connection failed: {}", e)),
        }
    }
    
    /// Send NMEA command
    fn send_command(&mut self, sentence: &str) -> Result<(), String> {
        match &mut self.stream {
            Some(stream) => {
                stream.write_all(sentence.as_bytes())
                    .map_err(|e| format!("Send failed: {}", e))
            }
            None => Err("Not connected".to_string()),
        }
    }
    
    /// Read next NMEA sentence
    /// 
    /// Note: This is a simplified example. In production, the BufReader
    /// should be stored as a struct field to maintain buffer state.
    fn read_sentence(&mut self) -> Result<String, String> {
        match &self.stream {
            Some(stream) => {
                let mut reader = BufReader::new(stream);
                let mut line = String::new();
                reader.read_line(&mut line)
                    .map_err(|e| format!("Read failed: {}", e))?;
                Ok(line)
            }
            None => Err("Not connected".to_string()),
        }
    }
    
    /// Adjust course by specified degrees
    /// 
    /// Note: This is a simplified example. In production, this should:
    /// - Filter for HDM/HDG sentences (not assume first sentence)
    /// - Handle multiple sentence types gracefully
    /// - Implement proper async reading with buffering
    fn adjust_course(&mut self, adjustment: f64) -> Result<(), String> {
        // Read current heading (simplified - should parse from HDM/HDG)
        let sentence = self.read_sentence()?;
        let current_heading = parse_hdm_heading(&sentence)?;
        
        // Calculate new heading
        let new_heading = calculate_new_heading(current_heading, adjustment);
        
        // Build and send command
        let command = build_heading_command(new_heading)?;
        self.send_command(&command)?;
        
        Ok(())
    }
}

// Example usage:
// let mut client = NmeaClient::new("192.168.4.1", 1457);
// client.connect()?;
// client.adjust_course(10.0)?;  // +10 degrees
```

## Testing Recommendations

### Unit Testing

Test each component independently:

1. **Checksum Calculation**: Test with known sentences
2. **Sentence Validation**: Test valid and invalid formats
3. **Parsing**: Test all supported sentence types
4. **Command Building**: Test all heading values including edge cases
5. **Heading Calculation**: Test wraparound scenarios

### Integration Testing

1. **Mock NMEA Server**: Create a test server that sends HDM/HDG sentences
2. **Command Echo**: Verify sent commands are properly formatted
3. **End-to-End Flow**: Simulate complete course change sequence

### Hardware Testing (Issue #15)

When testing with actual Yacht Device Gateway:

1. **Verify Sentences**: Confirm which heading sentences are sent by autopilot
2. **Test Commands**: Verify which command format the autopilot accepts
3. **Measure Latency**: Time from command to heading change
4. **Test Edge Cases**: Wraparound, rapid changes, simultaneous commands
5. **Network Reliability**: Test WiFi disconnections and reconnections

## References

1. **NMEA0183 Standard**: [Wikipedia - NMEA 0183](https://en.wikipedia.org/wiki/NMEA_0183)
2. **Yacht Device Gateway**: [Product Documentation](https://www.yachtd.com/products/wifi_0183_gateway.html)
3. **NMEA Sentence Reference**: [NMEA Data](http://www.nmea.de/)
4. **Autopilot Commands**: Manufacturer-specific documentation (Raymarine, Garmin, Simrad, etc.)

## Appendix: Quick Reference Tables

### Common NMEA Sentences

| Sentence | Description | Frequency | Priority |
|----------|-------------|-----------|----------|
| HDG | Heading, Deviation & Variation | 1 Hz | High |
| HDM | Heading, Magnetic | 1 Hz | High |
| HDT | Heading, True | 1 Hz | Medium |
| APB | Autopilot Sentence "B" | Variable | Low |
| RMB | Recommended Minimum Nav Info | Variable | Low |
| GGA | GPS Fix Data | 1 Hz | Low |
| VTG | Track & Speed | 1 Hz | Low |

### Button to Command Mapping

| Button | Current | Adjustment | New | Command |
|--------|---------|------------|-----|---------|
| +1° | 270.0 | +1.0 | 271.0 | `$APHDM,271.0,M*37` |
| -1° | 270.0 | -1.0 | 269.0 | `$APHDM,269.0,M*3E` |
| +10° | 270.0 | +10.0 | 280.0 | `$APHDM,280.0,M*39` |
| -10° | 270.0 | -10.0 | 260.0 | `$APHDM,260.0,M*37` |
| +10° | 355.0 | +10.0 | 5.0 | `$APHDM,5.0,M*36` |
| -10° | 5.0 | -10.0 | 355.0 | `$APHDM,355.0,M*30` |

### Connection Checklist

- [ ] Gateway powered on
- [ ] Mobile device connected to gateway WiFi (AP mode) or same network (Client mode)
- [ ] Gateway IP address configured in app
- [ ] Port 1457 accessible
- [ ] Autopilot connected to gateway via NMEA0183
- [ ] Autopilot powered on and in auto mode
- [ ] NMEA sentences flowing (verify with web interface)

---

**Document Version**: 1.0  
**Last Updated**: 2025-12-23  
**Author**: Protocol Specialist Agent  
**Status**: Draft - Pending Hardware Validation (Issue #15)
