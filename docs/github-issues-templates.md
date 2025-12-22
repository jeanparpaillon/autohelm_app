# GitHub Issues Template for Bulk Creation

This file contains templates for creating all 18 issues identified in the MVP implementation plan. These can be used to create issues programmatically or copied manually into GitHub.

---

## Labels to Create First

Create these labels in the GitHub repository:
- `feature` (color: #0e8a16) - New functionality
- `documentation` (color: #0075ca) - Documentation tasks
- `bug` (color: #d73a4a) - Bug fixes or testing
- `blocked` (color: #d93f0b) - Waiting on dependencies
- `blocking` (color: #fbca04) - Blocks other issues
- `phase-1` (color: #c2e0c6) - Foundation phase
- `phase-2` (color: #bfd4f2) - Protocol layer phase
- `phase-3` (color: #f9d0c4) - UI phase
- `phase-4` (color: #fef2c0) - Integration phase
- `phase-5` (color: #d4c5f9) - Testing phase
- `phase-6` (color: #c5def5) - Documentation/Release phase

---

## Issue Templates

### Issue #1: Setup Flutter project structure

```markdown
**Labels**: feature, phase-1, blocking
**Milestone**: Foundation
**Assignee**: Flutter Developer

### Description
Initialize the Flutter project with proper structure and dependencies for the Autohelm app.

### Tasks
- [ ] Run `flutter create autohelm_app`
- [ ] Configure `pubspec.yaml` with required dependencies
- [ ] Set up directory structure (lib/models, lib/services, lib/ui, lib/utils)
- [ ] Configure iOS and Android targets
- [ ] Add `.gitignore` for Flutter projects
- [ ] Verify project builds on both platforms

### Dependencies to Add
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  http: ^1.1.0
  shared_preferences: ^2.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  mockito: ^5.4.0
```

### Acceptance Criteria
- [ ] Project builds successfully on iOS
- [ ] Project builds successfully on Android
- [ ] All base directories are created
- [ ] Dependencies are properly configured

### Blocks
#2, #4, #6, #7, #9
```

---

### Issue #2: Create architecture documentation

```markdown
**Labels**: documentation, phase-1
**Milestone**: Foundation
**Assignee**: Software Architect / Technical Writer

### Description
Document the application architecture, including components, data flow, and design decisions.

### Dependencies
Blocked by: #1

### Tasks
- [ ] Create architecture overview diagram
- [ ] Document layer separation (UI, Business Logic, Data)
- [ ] Define state management approach
- [ ] Document data flow for COG updates
- [ ] Document data flow for commands
- [ ] Create module dependency diagram

### Deliverables
- `docs/architecture.md` with Mermaid diagrams
- Component responsibility definitions
- State management strategy

### Acceptance Criteria
- [ ] Architecture is clearly documented
- [ ] All major components are identified
- [ ] Data flow is illustrated with diagrams
- [ ] Diagrams are clear and useful

### Blocks
#17
```

---

### Issue #3: Document NMEA0183 protocol requirements

```markdown
**Labels**: documentation, phase-1, blocking
**Milestone**: Foundation
**Assignee**: Backend Developer / Protocol Specialist

### Description
Research and document the NMEA0183 protocol requirements specific to autopilot control and COG adjustment.

### Tasks
- [ ] Research NMEA0183 autopilot sentences
- [ ] Identify specific sentences for COG reading (HDG, HDM, or HDT)
- [ ] Identify specific sentences for autopilot commands
- [ ] Document Yacht Device Gateway communication specifics
- [ ] Document message format and checksums
- [ ] Create example messages for each operation
- [ ] Document error codes and handling

### Resources
- [NMEA0183 Reference](https://en.wikipedia.org/wiki/NMEA_0183)
- [Yacht Device Gateway Docs](https://www.yachtd.com/products/wifi_0183_gateway.html)

### Deliverables
- `docs/nmea0183-protocol.md`
- Example NMEA sentences
- Protocol state machine diagram

### Acceptance Criteria
- [ ] All required NMEA sentences are documented
- [ ] Message formats are clearly specified
- [ ] Checksum calculation is documented
- [ ] Connection parameters are specified

### Blocks
#5
```

---

### Issue #4: Implement WiFi connection manager

```markdown
**Labels**: feature, phase-2, blocking
**Milestone**: Core Features
**Assignee**: Backend Developer

### Description
Create a service to manage TCP/IP connections to the Yacht Device WiFi Gateway.

### Dependencies
Blocked by: #1

### Tasks
- [ ] Create `ConnectionService` class
- [ ] Implement TCP socket connection
- [ ] Add connection state management (disconnected, connecting, connected, error)
- [ ] Implement auto-reconnect logic
- [ ] Add connection timeout handling
- [ ] Implement heartbeat/keepalive
- [ ] Add connection status notifications
- [ ] Write unit tests

### Files to Create
- `lib/services/connection_service.dart`
- `lib/models/connection_state.dart`
- `test/services/connection_service_test.dart`

### Acceptance Criteria
- [ ] Can connect to specified IP and port
- [ ] Connection state is properly tracked
- [ ] Auto-reconnection works after disconnect
- [ ] Errors are properly handled and reported
- [ ] Unit tests pass

### Blocks
#5
```

---

### Issue #5: Implement NMEA0183 protocol handler

```markdown
**Labels**: feature, phase-2, blocking
**Milestone**: Core Features
**Assignee**: Backend Developer

### Description
Implement parsing and generation of NMEA0183 messages for autopilot control.

### Dependencies
Blocked by: #3, #4

### Tasks
- [ ] Create `NMEAParser` class
- [ ] Implement NMEA sentence parsing
- [ ] Implement checksum validation
- [ ] Implement COG extraction from NMEA sentences
- [ ] Create `NMEACommandBuilder` class
- [ ] Implement COG adjustment command generation
- [ ] Add message queue for outgoing commands
- [ ] Implement response/acknowledgment handling
- [ ] Write comprehensive unit tests

### Files to Create
- `lib/services/nmea_parser.dart`
- `lib/services/nmea_command_builder.dart`
- `lib/models/nmea_message.dart`
- `test/services/nmea_parser_test.dart`
- `test/services/nmea_command_builder_test.dart`

### Acceptance Criteria
- [ ] Can parse valid NMEA sentences
- [ ] Checksum validation works correctly
- [ ] Can extract COG from relevant sentences
- [ ] Can generate valid COG adjustment commands
- [ ] Invalid messages are rejected
- [ ] Unit tests pass (>80% coverage)

### Blocks
#11, #12
```

---

### Issue #6: Create data models

```markdown
**Labels**: feature, phase-2, blocking
**Milestone**: Core Features
**Assignee**: Full-Stack Developer

### Description
Define the core data models used throughout the application.

### Dependencies
Blocked by: #1

### Tasks
- [ ] Create `COG` model (value, timestamp, status)
- [ ] Create `ConnectionStatus` model
- [ ] Create `AutopilotCommand` model
- [ ] Create `AppSettings` model
- [ ] Add JSON serialization/deserialization if needed
- [ ] Add model validation
- [ ] Write unit tests

### Files to Create
- `lib/models/cog.dart`
- `lib/models/connection_status.dart`
- `lib/models/autopilot_command.dart`
- `lib/models/app_settings.dart`
- `test/models/` (test files)

### Acceptance Criteria
- [ ] All models are properly defined
- [ ] Models include necessary validation
- [ ] Models support serialization if needed
- [ ] Models are immutable where appropriate
- [ ] Tests pass

### Blocks
#10
```

---

### Issue #7: Design UI matching Autohelm remote

```markdown
**Labels**: feature, phase-3, blocking
**Milestone**: User Interface
**Assignee**: Flutter Developer / UI Designer

### Description
Design the user interface to match the physical Autohelm remote control appearance and layout.

### Dependencies
Blocked by: #1

### Tasks
- [ ] Analyze `docs/real.jpg` for layout and styling
- [ ] Create UI wireframes/mockups
- [ ] Define color palette matching original
- [ ] Design button layout and sizes (+1, -1, +10, -10)
- [ ] Design COG display area
- [ ] Create asset files if needed
- [ ] Document UI specifications

### Reference
See `docs/real.jpg` for the physical remote control

### Deliverables
- UI wireframes/mockups
- Color palette documentation
- Asset files
- `docs/ui-design.md`

### Acceptance Criteria
- [ ] UI design matches original remote layout
- [ ] All buttons and displays are specified
- [ ] Design is feasible for implementation
- [ ] Design works on various screen sizes

### Blocks
#8
```

---

### Issue #8: Implement main control screen

```markdown
**Labels**: feature, phase-3, blocking
**Milestone**: User Interface
**Assignee**: Flutter Developer

### Description
Build the main control screen with COG display and adjustment buttons.

### Dependencies
Blocked by: #7, #6

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
- [ ] Write widget tests

### Files to Create
- `lib/ui/screens/main_screen.dart`
- `lib/ui/widgets/cog_display.dart`
- `lib/ui/widgets/adjustment_button.dart`
- `lib/ui/widgets/connection_indicator.dart`
- `test/ui/screens/main_screen_test.dart`

### Acceptance Criteria
- [ ] Screen matches UI design from #7
- [ ] All buttons are functional
- [ ] COG display updates properly
- [ ] Layout is responsive
- [ ] Visual feedback is clear
- [ ] Widget tests pass

### Blocks
#11, #13
```

---

### Issue #9: Implement settings screen

```markdown
**Labels**: feature, phase-3
**Milestone**: User Interface
**Assignee**: Flutter Developer

### Description
Create a settings screen for configuring the WiFi gateway connection and app preferences.

### Dependencies
Blocked by: #1

### Tasks
- [ ] Create `SettingsScreen` widget
- [ ] Add IP address/hostname input field
- [ ] Add port number input field
- [ ] Add connection timeout setting
- [ ] Implement settings persistence (SharedPreferences)
- [ ] Add validation for inputs
- [ ] Add save/cancel buttons
- [ ] Add navigation from main screen
- [ ] Write widget tests

### Files to Create
- `lib/ui/screens/settings_screen.dart`
- `lib/services/settings_service.dart`
- `test/ui/screens/settings_screen_test.dart`

### Acceptance Criteria
- [ ] Settings can be entered and saved
- [ ] Settings persist across app restarts
- [ ] Input validation works
- [ ] Navigation works properly
- [ ] Tests pass

### Blocks
#11
```

---

### Issue #10: Implement state management

```markdown
**Labels**: feature, phase-4, blocking
**Milestone**: Integration
**Assignee**: Full-Stack Developer

### Description
Set up state management to handle app state, COG data, and connection status.

### Dependencies
Blocked by: #6

### Tasks
- [ ] Set up Provider state management
- [ ] Create `AppState` class
- [ ] Create `COGProvider`
- [ ] Create `ConnectionProvider`
- [ ] Create `CommandProvider`
- [ ] Implement state update logic
- [ ] Add state persistence where needed
- [ ] Document state management patterns
- [ ] Write tests

### Files to Create
- `lib/providers/cog_provider.dart`
- `lib/providers/connection_provider.dart`
- `lib/providers/command_provider.dart`
- `lib/state/app_state.dart`
- `test/providers/` (test files)

### Acceptance Criteria
- [ ] State updates propagate correctly
- [ ] UI reacts to state changes
- [ ] State management is efficient
- [ ] No unnecessary rebuilds
- [ ] Tests pass

### Blocks
#11
```

---

### Issue #11: Integrate UI with protocol layer

```markdown
**Labels**: feature, phase-4, blocking
**Milestone**: Integration
**Assignee**: Full-Stack Developer

### Description
Connect the UI components to the NMEA protocol layer and state management.

### Dependencies
Blocked by: #8, #5, #10

### Tasks
- [ ] Connect button presses to NMEA commands
- [ ] Wire up COG display to NMEA parser
- [ ] Implement command feedback display
- [ ] Add error handling and user notifications
- [ ] Implement loading states
- [ ] Add retry logic for failed commands
- [ ] Test end-to-end flow
- [ ] Write integration tests

### Acceptance Criteria
- [ ] Button presses send correct NMEA commands
- [ ] COG display updates from NMEA data
- [ ] Errors are displayed to user
- [ ] Command feedback is clear
- [ ] App handles disconnections gracefully
- [ ] Integration tests pass

### Blocks
#14, #15
```

---

### Issue #12: Add unit tests for protocol layer

```markdown
**Labels**: feature, phase-5
**Milestone**: Testing
**Assignee**: Backend Developer / QA

### Description
Create comprehensive unit tests for the NMEA protocol parsing and command generation.

### Dependencies
Blocked by: #5

### Tasks
- [ ] Test NMEA sentence parsing with valid data
- [ ] Test NMEA sentence parsing with invalid data
- [ ] Test checksum calculation and validation
- [ ] Test COG extraction
- [ ] Test command generation
- [ ] Test error handling
- [ ] Achieve >80% code coverage
- [ ] Run tests in CI if available

### Files to Create/Update
- `test/services/nmea_parser_test.dart`
- `test/services/nmea_command_builder_test.dart`

### Acceptance Criteria
- [ ] All protocol functions have tests
- [ ] Edge cases are covered
- [ ] Code coverage >80%
- [ ] All tests pass
```

---

### Issue #13: Add widget tests for UI

```markdown
**Labels**: feature, phase-5
**Milestone**: Testing
**Assignee**: Flutter Developer / QA

### Description
Create widget tests for all UI components.

### Dependencies
Blocked by: #8

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
- `test/ui/screens/settings_screen_test.dart`

### Acceptance Criteria
- [ ] All widgets have tests
- [ ] User interactions are tested
- [ ] Visual states are verified
- [ ] All tests pass
```

---

### Issue #14: Add integration tests

```markdown
**Labels**: feature, phase-5
**Milestone**: Testing
**Assignee**: Full-Stack Developer / QA

### Description
Create integration tests for complete user flows.

### Dependencies
Blocked by: #11

### Tasks
- [ ] Test complete COG adjustment flow
- [ ] Test connection flow
- [ ] Test settings flow
- [ ] Test error recovery flows
- [ ] Test reconnection scenarios
- [ ] Create mock NMEA server for testing
- [ ] Run tests on both platforms

### Files to Create
- `integration_test/cog_adjustment_test.dart`
- `integration_test/connection_test.dart`
- `test/mocks/mock_nmea_server.dart`

### Acceptance Criteria
- [ ] Key user flows are tested
- [ ] Tests run reliably on iOS and Android
- [ ] All tests pass
```

---

### Issue #15: Manual testing with hardware

```markdown
**Labels**: bug, phase-5, blocking
**Milestone**: Testing
**Assignee**: QA / Tester

### Description
Perform manual testing with actual Yacht Device Gateway hardware on physical devices.

### Dependencies
Blocked by: #11

### Tasks
- [ ] Obtain access to Yacht Device Gateway
- [ ] Test connection to Yacht Device Gateway
- [ ] Verify NMEA commands are accepted
- [ ] Verify COG adjustments work correctly
- [ ] Test all button functions (+1, -1, +10, -10)
- [ ] Test on Android device
- [ ] Test on iOS device
- [ ] Test various network conditions
- [ ] Document any issues found
- [ ] Create bug reports for issues

### Deliverables
- Test report with findings
- Screenshots/videos of app in action
- List of any bugs discovered

### Acceptance Criteria
- [ ] App connects successfully to hardware
- [ ] All COG adjustments work correctly
- [ ] No critical bugs found
- [ ] Performance is acceptable
- [ ] Test report is complete

### Blocks
#16, #18
```

---

### Issue #16: Create user documentation

```markdown
**Labels**: documentation, phase-6
**Milestone**: Documentation & Release
**Assignee**: Technical Writer

### Description
Create end-user documentation for installation and usage.

### Dependencies
Blocked by: #15

### Tasks
- [ ] Write installation instructions (iOS)
- [ ] Write installation instructions (Android)
- [ ] Write initial setup guide
- [ ] Write usage instructions
- [ ] Create troubleshooting guide
- [ ] Add screenshots from #15
- [ ] Document Yacht Device Gateway setup
- [ ] Create FAQ section

### Deliverables
- `docs/user-guide.md`
- `docs/installation.md`
- `docs/troubleshooting.md`
- Screenshots and/or videos

### Acceptance Criteria
- [ ] Documentation is clear and complete
- [ ] All features are documented
- [ ] Screenshots are included
- [ ] Troubleshooting covers common issues
```

---

### Issue #17: Create developer documentation

```markdown
**Labels**: documentation, phase-6
**Milestone**: Documentation & Release
**Assignee**: Technical Writer / Lead Developer

### Description
Create documentation for developers who will maintain or contribute to the project.

### Dependencies
Blocked by: #2

### Tasks
- [ ] Document development environment setup
- [ ] Document build process
- [ ] Document testing process
- [ ] Add inline code documentation/comments
- [ ] Create contributing guidelines
- [ ] Document release process
- [ ] Add API documentation

### Deliverables
- `docs/development.md`
- `docs/contributing.md`
- `docs/api.md`
- Inline code documentation

### Acceptance Criteria
- [ ] New developers can set up environment
- [ ] Build and test processes are clear
- [ ] Code is well-documented
- [ ] Contributing guidelines exist
```

---

### Issue #18: Build release artifacts

```markdown
**Labels**: feature, phase-6
**Milestone**: Documentation & Release
**Assignee**: DevOps / Release Engineer

### Description
Configure and create release builds for iOS and Android.

### Dependencies
Blocked by: #15

### Tasks
- [ ] Create app icon (1024x1024)
- [ ] Configure Android release build
- [ ] Configure iOS release build
- [ ] Set up app signing (if applicable)
- [ ] Build Android APK/AAB
- [ ] Build iOS IPA
- [ ] Test release builds on devices
- [ ] Document build process

### Deliverables
- Release APK/AAB for Android
- Release IPA for iOS
- App icons (all sizes)
- Build documentation

### Acceptance Criteria
- [ ] Release builds work correctly
- [ ] App icons are properly configured
- [ ] Build process is documented
- [ ] Artifacts are ready for distribution
```

---

## Milestones to Create

1. **Foundation** (Week 1)
   - Issues: #1, #2, #3
   - Goal: Project setup and documentation

2. **Core Features** (Week 2)
   - Issues: #4, #5, #6, #7
   - Goal: Protocol layer and UI design

3. **User Interface** (Week 2-3)
   - Issues: #8, #9
   - Goal: UI implementation

4. **Integration** (Week 3)
   - Issues: #10, #11
   - Goal: Connect all layers

5. **Testing** (Week 3-4)
   - Issues: #12, #13, #14, #15
   - Goal: Comprehensive testing

6. **Documentation & Release** (Week 4)
   - Issues: #16, #17, #18
   - Goal: Release-ready MVP

---

## Issue Creation Order

Create issues in this order to maintain dependencies:

**Day 1**: #1, #2, #3  
**Day 2**: #4, #6, #7  
**Day 3**: #5, #9  
**Day 4**: #8, #10  
**Day 5**: #11, #12, #13, #14  
**Day 6**: #15, #16, #17, #18
