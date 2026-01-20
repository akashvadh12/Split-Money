# Create Events Module - Centralized Flow Architecture

## Overview

The Create Events module has been refactored to use a **centralized flow controller** that manages the entire event creation process across three screens.

## Architecture

### Centralized Controller

**File**: `create_event_flow_controller.dart`

This controller manages:

- **Step tracking** (currentStep: 1-3)
- **All form data** across all screens
- **Navigation logic** between screens
- **Validation** for each step
- **Data persistence** throughout the flow

### Three Screens

#### 1. CreateEventScreen (Step 1)

**Purpose**: Basic Event Information

- Event title
- Category selection (Trip, Party, Gift, Other)
- Description (optional)

**Navigation**: `controller.goToStep2()` when validated

#### 2. WhenWhereScreen (Step 2)

**Purpose**: Event Details

- Date selection
- Start and end time
- Location

**Navigation**: `controller.goToStep3()` to proceed

#### 3. CompleteEventSetupScreen (Step 3)

**Purpose**: Amount and Contribution Setup

- Total amount
- Vendor name
- Payment deadline
- Participant slots
- Split type (Fixed per person / Split equally)

**Navigation**: `controller.completeFlow()` to finish

## Usage

### Starting the Flow

Instead of navigating directly to `CreateEventScreen`, use the wrapper:

```dart
// Navigate to create event flow
Get.to(() => const CreateEventFlowScreen());
```

This ensures the `CreateEventFlowController` is properly initialized.

### Flow Management

The controller provides these navigation methods:

```dart
controller.goToStep1()  // Navigate to step 1
controller.goToStep2()  // Navigate to step 2 (validates step 1)
controller.goToStep3()  // Navigate to step 3
controller.goToPreviousStep()  // Go back one step
controller.completeFlow()  // Complete the event creation
controller.resetFlow()  // Reset all data and go to step 1
```

### Step Indicators

All three screens now have **synchronized step indicators** that show:

- Current step (longer bar)
- Completed steps (primary color)
- Upcoming steps (gray)

The indicators automatically update based on `controller.currentStep.value`.

### Data Access

All form data is stored in the centralized controller:

```dart
// Access from any screen
final controller = Get.find<CreateEventFlowController>();

// Step 1 data
controller.eventTitleController.text
controller.selectedCategory.value
controller.descriptionController.text

// Step 2 data
controller.selectedDate.value
controller.startTime.value
controller.endTime.value
controller.locationController.text

// Step 3 data
controller.totalAmountController.text
controller.vendorNameController.text
controller.selectedSplitType.value
controller.participantSlots.value
```

## Benefits

### Before (Separate Controllers)

- ❌ Each screen had its own controller
- ❌ Data scattered across multiple controllers
- ❌ Step indicators out of sync
- ❌ Hard to share data between screens
- ❌ Inconsistent navigation logic

### After (Centralized Controller)

- ✅ Single source of truth for all data
- ✅ Consistent step tracking across screens
- ✅ Easy data sharing between screens
- ✅ Centralized validation logic
- ✅ Better state management
- ✅ Simplified navigation flow

## Validation

Each step has its own validation method:

```dart
controller.canContinueStep1  // Validates event title and category
controller.canContinueStep2  // Always true (optional fields)
controller.canContinueStep3  // Validates split type selection
```

## Cleanup

The old individual controllers are deprecated:

- ~~`create_events_controller.dart`~~ (replaced by flow controller)
- ~~`when&where_controller.dart`~~ (replaced by flow controller)
- ~~`amount_and_split_controller.dart`~~ (replaced by flow controller)

These files can be safely deleted.

## File Structure

```
create_events/
├── create_event_flow_controller.dart  ← Centralized controller
├── create_event_flow_screen.dart      ← Entry point wrapper
├── create_events.dart                 ← Step 1 screen
├── when&where/
│   └── when&where.dart                ← Step 2 screen
└── amount_and_split/
    └── amount_and_split_screen.dart   ← Step 3 screen
```

## Testing

To test the flow:

1. Navigate to `CreateEventFlowScreen`
2. Fill in event title and select category
3. Click "Continue" → Goes to step 2
4. Set date, time, location (optional)
5. Click "Next Step" → Goes to step 3
6. Set amount, vendor, participants, and split type
7. Click "Complete Event" → Shows success and exits flow

## Future Enhancements

Possible improvements:

- Add form persistence (save to local storage)
- Add "Save as Draft" functionality
- Add progress percentage indicator
- Add ability to skip optional steps
- Add confirmation dialog before exiting mid-flow
