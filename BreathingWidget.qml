import QtQuick
import QtQuick.Controls
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    pillRightClickAction: () => root.togglePause()

    readonly property real cellWidth: (root.popoutWidth - (root.gridSpacing * 2) - 16) / 2
    readonly property real cellHeight: 100
    readonly property real iconSize: 32
    readonly property real fontSize: 14
    readonly property int gridSpacing: 8

    readonly property var exercises: [
        {
            id: "deep",
            name: "Deep Breathing",
            description: "Slow deep breaths for relaxation",
            inhaleDuration: 4,
            holdDuration: 4,
            exhaleDuration: 4,
            cycles: 4,
            icon: "air"
        },
        {
            id: "478",
            name: "4-7-8 Breathing",
            description: "Calming technique for sleep",
            inhaleDuration: 4,
            holdDuration: 7,
            exhaleDuration: 8,
            cycles: 4,
            icon: "bedtime"
        },
        {
            id: "box",
            name: "Box Breathing",
            description: "Navy SEAL technique",
            inhaleDuration: 4,
            holdDuration: 4,
            exhaleDuration: 4,
            holdAfterExhale: 4,
            cycles: 4,
            icon: "crop_square"
        },
        {
            id: "equal",
            name: "Equal Breathing",
            description: "Equal inhale and exhale",
            inhaleDuration: 4,
            holdDuration: 0,
            exhaleDuration: 4,
            cycles: 6,
            icon: "sync_alt"
        },
        {
            id: "resonance",
            name: "Resonance",
            description: "5.5-5.5 breathing rhythm",
            inhaleDuration: 5.5,
            holdDuration: 0,
            exhaleDuration: 5.5,
            cycles: 6,
            icon: "waves"
        },
        {
            id: "alternate",
            name: "Alternate Nostril",
            description: "Balance left and right",
            inhaleDuration: 4,
            holdDuration: 0,
            exhaleDuration: 4,
            holdAfterExhale: 2,
            cycles: 6,
            icon: "swap_horiz"
        }
    ]

    property bool isRunning: false
    property bool isPaused: false
    property int currentExerciseIndex: -1
    property int currentCycle: 0
    property string breathPhase: ""
    property int phaseTimeRemaining: 0
    property int totalTimeRemaining: 0

    property bool enableHaptic: pluginData.enableHaptic !== undefined ? pluginData.enableHaptic : true
    property int selectedDuration: 5
    property int calculatedCycles: 0

    readonly property var timePresets: [
        { label: "1m", minutes: 1 },
        { label: "2m", minutes: 2 },
        { label: "3m", minutes: 3 },
        { label: "5m", minutes: 5 },
        { label: "10m", minutes: 10 },
        { label: "15m", minutes: 15 },
        { label: "20m", minutes: 20 },
        { label: "30m", minutes: 30 }
    ]

    function selectExercise(index) {
        currentExerciseIndex = index;
        currentCycle = 0;
        breathPhase = "";
    }

    function startExercise() {
        if (currentExerciseIndex < 0) {
            currentExerciseIndex = 0;
        }
        var ex = exercises[currentExerciseIndex];
        var cycleTime = ex.inhaleDuration + ex.holdDuration + ex.exhaleDuration + (ex.holdAfterExhale || 0);
        root.calculatedCycles = Math.floor((root.selectedDuration * 60) / cycleTime);
        
        currentCycle = 1;
        breathPhase = "inhale";
        phaseTimeRemaining = ex.inhaleDuration * 1000;
        totalTimeRemaining = root.selectedDuration * 60 * 1000;
        isRunning = true;
        isPaused = false;
        exerciseTimer.start();
    }

    function togglePause() {
        if (!isRunning && currentExerciseIndex >= 0) {
            startExercise();
            return;
        }
        isPaused = !isPaused;
        if (isPaused) {
            exerciseTimer.stop();
        } else {
            exerciseTimer.start();
        }
    }

    function stopExercise() {
        isRunning = false;
        isPaused = false;
        currentCycle = 0;
        breathPhase = "";
        phaseTimeRemaining = 0;
        totalTimeRemaining = 0;
        exerciseTimer.stop();
    }

    function calculateTotalTime() {
        if (currentExerciseIndex < 0) return 0;
        var ex = exercises[currentExerciseIndex];
        var cycleTime = (ex.inhaleDuration + ex.holdDuration + ex.exhaleDuration + (ex.holdAfterExhale || 0)) * 1000;
        return cycleTime * ex.cycles;
    }

    Timer {
        id: exerciseTimer
        interval: 1000
        repeat: true
        running: isRunning && !isPaused
        onTriggered: {
            phaseTimeRemaining -= 1000;
            totalTimeRemaining -= 1000;
            
            if (phaseTimeRemaining <= 0) {
                var ex = exercises[currentExerciseIndex];
                
                if (breathPhase === "inhale") {
                    if (ex.holdDuration > 0) {
                        breathPhase = "hold";
                        phaseTimeRemaining = ex.holdDuration * 1000;
                    } else {
                        breathPhase = "exhale";
                        phaseTimeRemaining = ex.exhaleDuration * 1000;
                    }
                } else if (breathPhase === "hold") {
                    breathPhase = "exhale";
                    phaseTimeRemaining = ex.exhaleDuration * 1000;
                } else if (breathPhase === "exhale") {
                    if (ex.holdAfterExhale > 0) {
                        breathPhase = "holdAfterExhale";
                        phaseTimeRemaining = ex.holdAfterExhale * 1000;
                    } else {
                        if (currentCycle < root.calculatedCycles) {
                            currentCycle++;
                            breathPhase = "inhale";
                            phaseTimeRemaining = ex.inhaleDuration * 1000;
                        } else {
                            stopExercise();
                            ToastService.showInfo("Exercise complete!");
                        }
                    }
                } else if (breathPhase === "holdAfterExhale") {
                    if (currentCycle < root.calculatedCycles) {
                        currentCycle++;
                        breathPhase = "inhale";
                        phaseTimeRemaining = ex.inhaleDuration * 1000;
                    } else {
                        stopExercise();
                        ToastService.showInfo("Exercise complete!");
                    }
                }
            }
        }
    }

    Timer {
        id: autoStartTimer
        interval: 2000
        onTriggered: {
            if (pluginData.enableAutoStart && pluginData.autoStartExercise !== undefined) {
                var idx = parseInt(pluginData.autoStartExercise);
                if (idx >= 0 && idx < root.exercises.length) {
                    selectExercise(idx);
                    startExercise();
                }
            }
        }
    }

    Component.onCompleted: autoStartTimer.start()

    horizontalBarPill: Component {
        Item {
            implicitWidth: pillRow.implicitWidth
            implicitHeight: pillRow.implicitHeight

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.PointingHandCursor
                onClicked: root.triggerPopout()
            }

            Row {
                id: pillRow
                anchors.centerIn: parent
                spacing: 4

                DankIcon {
                    name: root.isPaused ? "pause" : 
                          (breathPhase === "inhale" ? "trending_up" : 
                           breathPhase === "hold" || breathPhase === "holdAfterExhale" ? "horizontal_rule" :
                           breathPhase === "exhale" ? "trending_down" : "air")
                    size: 18
                    color: (root.isRunning || root.breathPhase !== "") ? Theme.primary : Theme.surfaceVariantText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    verticalBarPill: horizontalBarPill

    popoutWidth: 380
    popoutHeight: 500

    popoutContent: Component {
        PopoutComponent {
            width: root.popoutWidth
            headerText: "Breathing Exercises"
            detailsText: isRunning ? "Cycle " + currentCycle + "/" + root.calculatedCycles : ""
            showCloseButton: false

            Column {
                width: parent.width
                spacing: 8

                // Active display when running
                Rectangle {
                    width: parent.width
                    height: 100
                    radius: Theme.cornerRadius
                    color: root.isRunning ? Theme.primary : Theme.surfaceContainerHigh
                    visible: root.isRunning || root.breathPhase !== ""

                    Row {
                        anchors.centerIn: parent
                        spacing: 48

                        DankIcon {
                            name: root.isPaused ? "pause" : 
                                  (breathPhase === "inhale" ? "trending_up" : 
                                   breathPhase === "hold" || breathPhase === "holdAfterExhale" ? "horizontal_rule" :
                                   breathPhase === "exhale" ? "trending_down" : "air")
                            size: 64
                            color: root.isRunning ? Theme.onPrimary : Theme.surfaceVariantText
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Item {
                            width: 120
                            height: parent.height
                            anchors.verticalCenter: parent.verticalCenter

                            Column {
                                anchors.centerIn: parent
                                spacing: 4

                                StyledText {
                                    text: root.isPaused ? "Paused" : (breathPhase === "inhale" ? "Breathe In" : 
                                          breathPhase === "hold" ? "Hold" : 
                                          breathPhase === "exhale" ? "Breathe Out" :
                                          breathPhase === "holdAfterExhale" ? "Hold" : "---")
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                    color: root.isRunning ? Theme.onPrimary : Theme.surfaceText
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Row {
                                    spacing: 8
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    StyledText {
                                        text: (Math.ceil(phaseTimeRemaining / 1000)) + "s"
                                        font.pixelSize: 28
                                        font.weight: Font.Bold
                                        color: root.isRunning ? Theme.onPrimary : Theme.surfaceVariantText
                                    }

                                    StyledText {
                                        text: "/ " + Math.floor(totalTimeRemaining / 60000) + ":" + ((Math.floor((totalTimeRemaining % 60000) / 1000) + "").padStart(2, "0"))
                                        font.pixelSize: 16
                                        color: root.isRunning ? Theme.onPrimary : Theme.surfaceVariantText
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: root.currentExerciseIndex >= 0
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.togglePause()
                    }
                }

                // Exercises grid
                Flow {
                    width: parent.width
                    spacing: root.gridSpacing

                    Repeater {
                        model: root.exercises
                        delegate: Rectangle {
                            width: root.cellWidth
                            height: root.cellHeight
                            radius: Theme.cornerRadius
                            color: root.currentExerciseIndex === index ? Theme.primary : Theme.surfaceContainerHigh

                            Column {
                                anchors.centerIn: parent
                                spacing: 4
                                DankIcon {
                                    name: modelData.icon
                                    size: root.iconSize
                                    color: root.currentExerciseIndex === index ? Theme.onPrimary : Theme.surfaceVariantText
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                                StyledText {
                                    text: modelData.name
                                    font.pixelSize: root.fontSize
                                    font.weight: Font.Medium
                                    color: root.currentExerciseIndex === index ? Theme.onPrimary : Theme.surfaceText
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                                StyledText {
                                    text: modelData.inhaleDuration + "-" + modelData.holdDuration + "-" + modelData.exhaleDuration
                                    font.pixelSize: 11
                                    color: root.currentExerciseIndex === index ? Theme.onPrimary : Theme.surfaceVariantText
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.selectExercise(index);
                                    if (root.isRunning) root.startExercise();
                                }
                            }
                        }
                    }
                }

                // Start/Stop buttons
                Column {
                    width: parent.width
                    spacing: 8

                    Row {
                        width: parent.width
                        spacing: 8

                        DankButton {
                            text: root.isRunning ? (root.isPaused ? "Resume" : "Pause") : "Start"
                            width: parent.width / 2 - 4
                            height: 40
                            iconName: root.isPaused ? "play_arrow" : (root.isRunning ? "pause" : "play_arrow")
                            onClicked: {
                                if (root.isRunning) {
                                    root.togglePause();
                                } else {
                                    root.startExercise();
                                }
                            }
                        }

                        DankButton {
                            text: "Stop"
                            width: parent.width / 2 - 4
                            height: 40
                            backgroundColor: Theme.errorContainer
                            textColor: Theme.error
                            iconName: "stop"
                            visible: root.isRunning || root.breathPhase !== ""
                            onClicked: root.stopExercise()
                        }
                    }

                    // Duration presets
                    Row {
                        width: parent.width
                        spacing: 4
                        visible: !root.isRunning

                        Repeater {
                            model: root.timePresets
                            delegate: Rectangle {
                                width: (parent.width - 28) / 8
                                height: 28
                                radius: Theme.cornerRadius
                                color: root.selectedDuration === modelData.minutes ? Theme.primary : Theme.surfaceContainerHigh

                                StyledText {
                                    text: modelData.label
                                    font.pixelSize: 12
                                    font.weight: root.selectedDuration === modelData.minutes ? Font.Bold : Font.Normal
                                    color: root.selectedDuration === modelData.minutes ? Theme.onPrimary : Theme.surfaceText
                                    anchors.centerIn: parent
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.selectedDuration = modelData.minutes;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}