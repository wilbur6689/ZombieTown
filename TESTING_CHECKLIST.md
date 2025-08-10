# ZombieTown RPG - Testing Checklist

## ❌ CURRENT STATUS: NOT READY TO RUN
The app needs critical fixes before it can be tested.

## 🚨 CRITICAL BLOCKERS

### 1. Flutter SDK Missing
**Status**: ❌ Not installed
**Fix**: Install Flutter SDK first
```bash
sudo snap install flutter --classic
```

### 2. JSON Serialization Code Missing  
**Status**: ❌ All model .g.dart files missing
**Impact**: App won't compile
**Fix**: 
```bash
flutter packages pub run build_runner build
```

### 3. Provider Integration Incomplete
**Status**: ❌ Screens not connected to state management
**Impact**: Navigation and data flow won't work properly
**Fix**: Requires code integration work

## 🔧 IMMEDIATE FIXES NEEDED

Before you can run `flutter run`, these must be completed:

### Fix 1: Install Flutter SDK
```bash
# Install Flutter
sudo snap install flutter --classic

# Verify installation
flutter --version
flutter doctor
```

### Fix 2: Generate Model Code
```bash
cd /home/pwillis/Projects/ZombieTown
flutter pub get
flutter packages pub run build_runner build
```

### Fix 3: Check Compilation
```bash
flutter analyze
```

## 🧪 TESTING WORKFLOW

### Phase 1: Basic Compilation Test
```bash
# 1. Navigate to project
cd /home/pwillis/Projects/ZombieTown

# 2. Install dependencies
flutter pub get

# 3. Generate model serialization code
flutter packages pub run build_runner build

# 4. Check for compilation errors
flutter analyze

# 5. Attempt to run (may have runtime errors)
flutter run --debug
```

### Phase 2: Navigation Test
**Expected Result**: App launches but may crash when navigating between screens
**Test**: 
1. Launch app - should show home screen
2. Tap "New Game" - may crash due to missing Provider integration
3. Check console for error messages

### Phase 3: Integration Fixes
**If app crashes**: Need to connect screens to Provider state management
**Common errors**:
- Provider not found errors
- Asset loading errors (expected - many images don't exist)
- JSON serialization errors

## 🎯 MINIMUM WORKING VERSION

To get a basic working version quickly, we need to:

1. ✅ Generate all .g.dart files
2. ⚠️ Fix Provider integration in screens
3. ⚠️ Add error handling for missing assets
4. ⚠️ Create placeholder data for testing

## 📱 EXPECTED BEHAVIOR

### What SHOULD Work:
- App launches and shows home screen
- Basic navigation between screens
- UI layouts display correctly

### What WON'T Work Yet:
- Data persistence between screens
- Game state management  
- Image assets (many missing)
- Full game mechanics

## 🚀 QUICK START COMMANDS

Once Flutter is installed:

```bash
cd /home/pwillis/Projects/ZombieTown
flutter pub get
flutter packages pub run build_runner build
flutter run --debug
```

## ⚠️ KNOWN ISSUES

1. **Missing Images**: Many asset references will show broken image icons
2. **Provider Errors**: Screens may crash when trying to access game state
3. **Navigation Issues**: Data won't persist between screen transitions
4. **Database Errors**: SQLite operations may fail without proper initialization

## 📋 SUCCESS CRITERIA

### Minimal Success:
- [ ] App compiles without errors
- [ ] Home screen displays
- [ ] Can navigate to at least one other screen

### Basic Success:
- [ ] All screens accessible
- [ ] No critical crashes during navigation
- [ ] UI elements display correctly

### Full Success:
- [ ] Complete user journey works
- [ ] Data persists between screens
- [ ] Game mechanics functional

---

**RECOMMENDATION**: Install Flutter SDK first, then run the compilation test. The app structure is complete but needs integration work to be fully functional.