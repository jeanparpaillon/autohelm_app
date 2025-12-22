# MVP Implementation - Quick Reference

## Project Overview
**Goal**: Create a cross-platform mobile app (Flutter) that emulates the Autohelm remote control for adjusting vessel COG via NMEA0183 over WiFi.

## Critical Path Issues (Must be completed in order)

1. **#1** - Setup Flutter project → Blocks everything
2. **#3** - Document NMEA protocol → Blocks #5
3. **#4** - WiFi connection manager → Blocks #5
4. **#5** - NMEA protocol handler → Blocks #11
5. **#6** - Data models → Blocks #10
6. **#7** - UI design → Blocks #8
7. **#8** - Main screen → Blocks #11
8. **#10** - State management → Blocks #11
9. **#11** - Integration → Blocks #14, #15
10. **#15** - Hardware testing → Blocks #16, #18

## Parallel Work Streams

### Stream A: Protocol & Communication
- #1 → #3 → #4 → #5 → #12

### Stream B: UI Development
- #1 → #7 → #8 → #13
- #1 → #9

### Stream C: Architecture & Models
- #1 → #2
- #1 → #6 → #10

### Stream D: Integration & Testing
- (#5 + #8 + #10) → #11 → #14 → #15

### Stream E: Documentation & Release
- #15 → #16
- #2 → #17
- #15 → #18

## Team Assignment Recommendations

### Flutter Developer
- Issues: #1, #7, #8, #9, #13
- Skills: Flutter, UI/UX, Widget development

### Backend/Protocol Developer
- Issues: #3, #4, #5, #12
- Skills: Networking, protocols, TCP/IP

### Full-Stack Developer
- Issues: #6, #10, #11, #14
- Skills: State management, integration

### QA/Tester
- Issues: #15
- Skills: Manual testing, hardware testing

### Technical Writer
- Issues: #2, #16, #17
- Skills: Documentation, technical writing

### DevOps/Release Engineer
- Issues: #18
- Skills: Build systems, app signing

## Key Milestones

### Milestone 1: Foundation (Week 1)
- ✅ Complete #1, #2, #3
- **Deliverable**: Working project structure + documentation

### Milestone 2: Core Features (Week 2)
- ✅ Complete #4, #5, #6, #7
- **Deliverable**: Protocol layer + UI design

### Milestone 3: Implementation (Week 2-3)
- ✅ Complete #8, #9, #10, #11
- **Deliverable**: Working app (without hardware)

### Milestone 4: Testing (Week 3)
- ✅ Complete #12, #13, #14, #15
- **Deliverable**: Tested app with hardware validation

### Milestone 5: Release (Week 4)
- ✅ Complete #16, #17, #18
- **Deliverable**: Release-ready MVP

## Risk Items

⚠️ **High Risk**:
- #3: NMEA protocol specifications may be unclear
- #5: NMEA implementation may need hardware for validation
- #15: Hardware availability for testing

⚠️ **Medium Risk**:
- #11: Integration complexity
- #18: App store signing/distribution

## Daily Standup Format

**Yesterday**: What was completed (issue numbers)  
**Today**: What will be worked on (issue numbers)  
**Blockers**: Any blocked issues (with dependencies)

## Definition of Done

For each issue:
- [ ] Code is written and follows project style
- [ ] Tests are written and passing
- [ ] Code is reviewed (if applicable)
- [ ] Documentation is updated
- [ ] Issue is closed with appropriate labels

## Quick Commands

```bash
# Create new Flutter project
flutter create autohelm_app

# Run app
flutter run

# Run tests
flutter test

# Build Android
flutter build apk

# Build iOS
flutter build ios

# Check dependencies
flutter pub get

# Analyze code
flutter analyze
```

## Contact Points

- **NMEA Protocol Questions**: Refer to #3 documentation
- **UI/UX Questions**: Refer to docs/real.jpg and #7 design
- **Architecture Questions**: Refer to #2 documentation
- **Hardware Access**: Coordinate for #15 testing

## Links

- [Flutter Documentation](https://flutter.dev/docs)
- [NMEA0183 Protocol](https://en.wikipedia.org/wiki/NMEA_0183)
- [Yacht Device Gateway](https://www.yachtd.com/products/wifi_0183_gateway.html)
- [Project Rationale](./rationale.md)
- [Full Implementation Plan](./mvp-implementation-plan.md)
- [Detailed Issues](./issues-breakdown.md)
