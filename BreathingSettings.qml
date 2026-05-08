import QtQuick
import QtQuick.Controls
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "breathing"

    readonly property var exercises: [
        { name: "Deep Breathing", id: "deep" },
        { name: "4-7-8 Breathing", id: "478" },
        { name: "Box Breathing", id: "box" },
        { name: "Equal Breathing", id: "equal" },
        { name: "Resonance", id: "resonance" },
        { name: "Alternate Nostril", id: "alternate" }
    ]

    StyledText {
        width: parent.width
        text: "Breathing Exercise Settings"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.primary
    }

    StyledRect {
        width: parent.width
        height: generalColumn.implicitHeight + Theme.spacingL * 2
        radius: Theme.cornerRadius
        color: Theme.surfaceContainer

        Column {
            id: generalColumn
            anchors.fill: parent
            anchors.margins: Theme.spacingL
            spacing: Theme.spacingM

            StyledText {
                text: "General"
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            ToggleSetting {
                settingKey: "enableAutoStart"
                label: "Auto-start Exercise"
                description: "Start exercise automatically on login."
                defaultValue: false
            }

            SelectionSetting {
                settingKey: "autoStartExercise"
                label: "Default Exercise"
                description: "Exercise to start automatically."
                options: [
                    { label: "Deep Breathing", value: "0" },
                    { label: "4-7-8 Breathing", value: "1" },
                    { label: "Box Breathing", value: "2" },
                    { label: "Equal Breathing", value: "3" },
                    { label: "Resonance", value: "4" },
                    { label: "Alternate Nostril", value: "5" }
                ]
                defaultValue: "0"
                visible: root.loadValue("enableAutoStart", false)
            }
        }
    }

    StyledRect {
        width: parent.width
        height: feedbackColumn.implicitHeight + Theme.spacingL * 2
        radius: Theme.cornerRadius
        color: Theme.surfaceContainer

        Column {
            id: feedbackColumn
            anchors.fill: parent
            anchors.margins: Theme.spacingL
            spacing: Theme.spacingM

            StyledText {
                text: "Feedback"
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            ToggleSetting {
                settingKey: "enableHaptic"
                label: "Haptic Feedback"
                description: "Vibrate on phase transitions."
                defaultValue: true
            }
        }
    }
}