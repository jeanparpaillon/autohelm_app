# GitHub Issues Breakdown

This document contains the detailed breakdown of issues to be created for the MVP implementation.

---

## Issue #1: Setup Flutter project structure

**Type**: feature  
**Priority**: High  
**Dependencies**: None  
**Blocks**: #2, #6, #7, #9, #4

### Description
Initialize the Flutter project with proper structure and dependencies for the Autohelm app.

### Tasks
- [ ] Run `flutter create autohelm_app` 
- [ ] Configure `pubspec.yaml` with required dependencies
- [ ] Set up directory structure (lib/models, lib/services, lib/ui, lib/utils)
- [ ] Configure iOS and Android targets
- [ ] Add `.gitignore` for Flutter projects
- [ ] Verify project builds on both platforms

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  # State management (choose one)
  provider: ^6.0.0  # or riverpod, bloc
  # Networking
  http: ^1.1.0
  # Settings persistence
  shared_preferences: ^2.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  mockito: ^5.4.0
```

### Acceptance Criteria
- Project builds successfully on iOS
- Project builds successfully on Android
- All base directories are created
- Dependencies are properly configured

---

## Issue #2: Create architecture documentation

**Type**: documentation  
**Priority**: High  
**Dependencies**: #1  
**Blocks**: #17

### Description
Document the application architecture, including components, data flow, and design decisions.

### Tasks
- [ ] Create architecture overview diagram
- [ ] Document layer separation (UI, Business Logic, Data)
- [ ] Define state management approach
- [ ] Document data flow for COG updates
- [ ] Document data flow for commands
- [ ] Create module dependency diagram

### Deliverables
- `docs/architecture.md` with diagrams (Mermaid)
- Component responsibility definitions
- State management strategy

### Acceptance Criteria
- Architecture is clearly documented
- All major components are identified
- Data flow is illustrated
- Diagrams are clear and useful

---

## Issue #3: Document NMEA0183 protocol requirements

**Type**: documentation  
**Priority**: High  
**Dependencies**: None  
**Blocks**: #5

### Description
Research and document the NMEA0183 protocol requirements specific to autopilot control and COG adjustment.

### Tasks
- [ ] Research NMEA0183 autopilot sentences
- [ ] Identify specific sentences for COG reading (likely HDG, HDM, or HDT)
- [ ] Identify specific sentences for autopilot commands
- [ ] Document Yacht Device Gateway communication specifics
- [ ] Document message format and checksums
- [ ] Create example messages for each operation
- [ ] Document error codes and handling

### Deliverables
- `docs/nmea0183-protocol.md`
- Example NMEA sentences
- Protocol state machine diagram

### Acceptance Criteria
- All required NMEA sentences are documented
- Message formats are clearly specified
- Checksum calculation is documented
- Connection parameters are specified

---

## Issue #4: Implement WiFi connection manager

**Type**: feature  
**Priority**: High  
**Dependencies**: #1  
**Blocks**: #5

### Description
Create a service to manage TCP/IP connections to the Yacht Device WiFi Gateway.

### Tasks
- [ ] Create `ConnectionService` class
- [ ] Implement TCP socket connection
- [ ] Add connection state management (disconnected, connecting, connected, error)
- [ ] Implement auto-reconnect logic
- [ ] Add connection timeout handling
- [ ] Implement heartbeat/keepalive
- [ ] Add connection status notifications

### Files to Create
- `lib/services/connection_service.dart`
- `lib/models/connection_state.dart`

### Acceptance Criteria
- Can connect to specified IP and port
- Connection state is properly tracked
- Auto-reconnection works after disconnect
- Errors are properly handled and reported
- Unit tests pass

---

## Issue #5: Implement NMEA0183 protocol handler

**Type**: feature  
**Priority**: High  
**Dependencies**: #3, #4  
**Blocks**: #11, #12

### Description
Implement parsing and generation of NMEA0183 messages for autopilot control.

### Tasks
- [ ] Create `NMEAParser` class
- [ ] Implement NMEA sentence parsing
- [ ] Implement checksum validation
- [ ] Implement COG extraction from NMEA sentences
- [ ] Create `NMEACommandBuilder` class
- [ ] Implement COG adjustment command generation
- [ ] Add message queue for outgoing commands
- [ ] Implement response/acknowledgment handling

### Files to Create
- `lib/services/nmea_parser.dart`
- `lib/services/nmea_command_builder.dart`
- `lib/models/nmea_message.dart`

### Acceptance Criteria
- Can parse valid NMEA sentences
- Checksum validation works correctly
- Can extract COG from relevant sentences
- Can generate valid COG adjustment commands
- Invalid messages are rejected
- Unit tests pass (>80% coverage)

---

## Issue #6: Create data models

**Type**: feature  
**Priority**: High  
**Dependencies**: #1  
**Blocks**: #10

### Description
Define the core data models used throughout the application.

### Tasks
- [ ] Create `COG` model (value, timestamp, status)
- [ ] Create `ConnectionStatus` model
- [ ] Create `AutopilotCommand` model
- [ ] Create `AppSettings` model
- [ ] Add JSON serialization/deserialization
- [ ] Add model validation

### Files to Create
- `lib/models/cog.dart`
- `lib/models/connection_status.dart`
- `lib/models/autopilot_command.dart`
- `lib/models/app_settings.dart`

### Acceptance Criteria
- All models are properly defined
- Models include necessary validation
- Models support serialization if needed
- Models are immutable where appropriate

---

## Issue #7: Design UI matching Autohelm remote

**Type**: feature  
**Priority**: Medium  
**Dependencies**: #1  
**Blocks**: #8

### Description
Design the user interface to match the physical Autohelm remote control appearance and layout.

### Tasks
- [ ] Analyze docs/real.jpg for layout and styling
- [ ] Create UI wireframes
- [ ] Define color palette matching original
- [ ] Design button layout and sizes
- [ ] Design COG display area
- [ ] Create asset files (if needed)
- [ ] Document UI specifications

### Deliverables
- UI wireframes/mockups
- Color palette documentation
- Asset files
- `docs/ui-design.md`

### Acceptance Criteria
- UI design matches original remote layout
- All buttons and displays are specified
- Design is feasible for implementation
- Design works on various screen sizes

---

## Issue #8: Implement main control screen

**Type**: feature  
**Priority**: High  
**Dependencies**: #7, #6  
**Blocks**: #11, #13

### Description
Build the main control screen with COG display and adjustment buttons.

### Tasks
- [ ] Create `MainScreen` widget
- [ ] Implement COG display widget
- [ ] Create +1 degree button
- [ ] Create -1 degree button
- [ ] Create +10 degree button
- [ ] Create -10 degree button
- [ ] Add button press visual feedback
- [ ] Add connection status indicator
- [ ] Implement responsive layout

### Files to Create
- `lib/ui/screens/main_screen.dart`
- `lib/ui/widgets/cog_display.dart`
- `lib/ui/widgets/adjustment_button.dart`
- `lib/ui/widgets/connection_indicator.dart`

### Acceptance Criteria
- Screen matches UI design
- All buttons are functional
- COG display updates properly
- Layout is responsive
- Visual feedback is clear

---

## Issue #9: Implement settings screen

**Type**: feature  
**Priority**: Medium  
**Dependencies**: #1  
**Blocks**: #11

### Description
Create a settings screen for configuring the WiFi gateway connection and app preferences.

### Tasks
- [ ] Create `SettingsScreen` widget
- [ ] Add IP address/hostname input field
- [ ] Add port number input field
- [ ] Add connection timeout setting
- [ ] Implement settings persistence (SharedPreferences)
- [ ] Add validation for inputs
- [ ] Add save/cancel buttons
- [ ] Add navigation from main screen

### Files to Create
- `lib/ui/screens/settings_screen.dart`
- `lib/services/settings_service.dart`

### Acceptance Criteria
- Settings can be entered and saved
- Settings persist across app restarts
- Input validation works
- Navigation works properly

---

## Issue #10: Implement state management

**Type**: feature  
**Priority**: High  
**Dependencies**: #6  
**Blocks**: #11

### Description
Set up state management to handle app state, COG data, and connection status.

### Tasks
- [ ] Choose state management solution (Provider recommended)
- [ ] Create `AppState` class
- [ ] Create `COGProvider`
- [ ] Create `ConnectionProvider`
- [ ] Create `CommandProvider`
- [ ] Implement state update logic
- [ ] Add state persistence where needed
- [ ] Document state management patterns

### Files to Create
- `lib/providers/cog_provider.dart`
- `lib/providers/connection_provider.dart`
- `lib/providers/command_provider.dart`
- `lib/state/app_state.dart`

### Acceptance Criteria
- State updates propagate correctly
- UI reacts to state changes
- State management is efficient
- No unnecessary rebuilds

---

## Issue #11: Integrate UI with protocol layer

**Type**: feature  
**Priority**: High  
**Dependencies**: #8, #5, #10  
**Blocks**: #14, #15

### Description
Connect the UI components to the NMEA protocol layer and state management.

### Tasks
- [ ] Connect button presses to NMEA commands
- [ ] Wire up COG display to NMEA parser
- [ ] Implement command feedback display
- [ ] Add error handling and user notifications
- [ ] Implement loading states
- [ ] Add retry logic for failed commands
- [ ] Test end-to-end flow

### Acceptance Criteria
- Button presses send correct NMEA commands
- COG display updates from NMEA data
- Errors are displayed to user
- Command feedback is clear
- App handles disconnections gracefully

---

## Issue #12: Add unit tests for protocol layer

**Type**: feature  
**Priority**: High  
**Dependencies**: #5

### Description
Create comprehensive unit tests for the NMEA protocol parsing and command generation.

### Tasks
- [ ] Test NMEA sentence parsing with valid data
- [ ] Test NMEA sentence parsing with invalid data
- [ ] Test checksum calculation and validation
- [ ] Test COG extraction
- [ ] Test command generation
- [ ] Test error handling
- [ ] Achieve >80% code coverage

### Files to Create
- `test/services/nmea_parser_test.dart`
- `test/services/nmea_command_builder_test.dart`

### Acceptance Criteria
- All protocol functions have tests
- Edge cases are covered
- Code coverage >80%
- All tests pass

---

## Issue #13: Add widget tests for UI

**Type**: feature  
**Priority**: Medium  
**Dependencies**: #8

### Description
Create widget tests for all UI components.

### Tasks
- [ ] Test main screen widget
- [ ] Test COG display widget
- [ ] Test button widgets
- [ ] Test settings screen
- [ ] Test navigation
- [ ] Test visual states (loading, error, success)

### Files to Create
- `test/ui/screens/main_screen_test.dart`
- `test/ui/widgets/cog_display_test.dart`
- `test/ui/widgets/adjustment_button_test.dart`

### Acceptance Criteria
- All widgets have tests
- User interactions are tested
- Visual states are verified
- All tests pass

---

## Issue #14: Add integration tests

**Type**: feature  
**Priority**: Medium  
**Dependencies**: #11

### Description
Create integration tests for complete user flows.

### Tasks
- [ ] Test complete COG adjustment flow
- [ ] Test connection flow
- [ ] Test settings flow
- [ ] Test error recovery flows
- [ ] Test reconnection scenarios
- [ ] Use mock NMEA server for testing

### Files to Create
- `integration_test/cog_adjustment_test.dart`
- `integration_test/connection_test.dart`
- `test/mocks/mock_nmea_server.dart`

### Acceptance Criteria
- Key user flows are tested
- Tests run reliably
- All tests pass

---

## Issue #15: Manual testing with hardware

**Type**: bug  
**Priority**: High  
**Dependencies**: #11

### Description
Perform manual testing with actual Yacht Device Gateway hardware on physical devices.

### Tasks
- [ ] Test connection to Yacht Device Gateway
- [ ] Verify NMEA commands are accepted
- [ ] Verify COG adjustments work correctly
- [ ] Test all button functions (+1, -1, +10, -10)
- [ ] Test on Android device
- [ ] Test on iOS device
- [ ] Test various network conditions
- [ ] Document any issues found

### Deliverables
- Test report with findings
- Screenshots/videos of app in action
- List of any bugs discovered

### Acceptance Criteria
- App connects successfully to hardware
- All COG adjustments work correctly
- No critical bugs found
- Performance is acceptable

---

## Issue #16: Create user documentation

**Type**: documentation  
**Priority**: Medium  
**Dependencies**: #15

### Description
Create end-user documentation for installation and usage.

### Tasks
- [ ] Write installation instructions (iOS)
- [ ] Write installation instructions (Android)
- [ ] Write initial setup guide
- [ ] Write usage instructions
- [ ] Create troubleshooting guide
- [ ] Add screenshots
- [ ] Document Yacht Device Gateway setup
- [ ] Create FAQ section

### Deliverables
- `docs/user-guide.md`
- `docs/installation.md`
- `docs/troubleshooting.md`
- Screenshots

### Acceptance Criteria
- Documentation is clear and complete
- All features are documented
- Screenshots are included
- Troubleshooting covers common issues

---

## Issue #17: Create developer documentation

**Type**: documentation  
**Priority**: Medium  
**Dependencies**: #2

### Description
Create documentation for developers who will maintain or contribute to the project.

### Tasks
- [ ] Document development environment setup
- [ ] Document build process
- [ ] Document testing process
- [ ] Add code documentation/comments
- [ ] Create contributing guidelines
- [ ] Document release process
- [ ] Add API documentation

### Deliverables
- `docs/development.md`
- `docs/contributing.md`
- `docs/api.md`
- Inline code documentation

### Acceptance Criteria
- New developers can set up environment
- Build and test processes are clear
- Code is well-documented
- Contributing guidelines exist

---

## Issue #18: Build release artifacts

**Type**: feature  
**Priority**: Medium  
**Dependencies**: #15

### Description
Configure and create release builds for iOS and Android.

### Tasks
- [ ] Create app icon
- [ ] Configure Android release build
- [ ] Configure iOS release build
- [ ] Set up app signing (if applicable)
- [ ] Build Android APK/AAB
- [ ] Build iOS IPA
- [ ] Test release builds
- [ ] Document build process

### Deliverables
- Release APK/AAB for Android
- Release IPA for iOS
- App icons
- Build documentation

### Acceptance Criteria
- Release builds work correctly
- App icons are properly configured
- Build process is documented
- Artifacts are ready for distribution
