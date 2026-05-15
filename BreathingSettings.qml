import QtQuick
import QtQuick.Controls
import qs.Common
import qs.Widgets
import qs.Modules.Plugins
import "../dms-common"

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

    PluginHeader {
        title: "Breathing Exercise Settings"
    }

    SettingsCard {
        SectionTitle { text: "General" }

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
        }

        SliderSetting {
            settingKey: "defaultDuration"
            label: "Default Duration"
            description: "Session length for auto-started exercises (minutes)."
            minimum: 1
            maximum: 30
            defaultValue: 5
        }

        ToggleSetting {
            settingKey: "showHints"
            label: "Show Hints"
            description: "Display helpful usage tips and shortcuts at the bottom of the popout."
            defaultValue: true
        }
    }

    SettingsCard {
        SectionTitle { text: "Feedback" }

        ToggleSetting {
            settingKey: "enableHaptic"
            label: "Haptic Feedback"
            description: "Vibrate on phase transitions."
            defaultValue: true
        }
        
        ToggleSetting {
            settingKey: "enableSound"
            label: "Sound Cues"
            description: "Play subtle sounds on phase transitions."
            defaultValue: true
        }
    }

    SettingsCard {
        SectionTitle { text: "Quick Guide" }
        InfoText {
            text: "• Select an exercise to see details\n• Click Start to begin guided breathing\n• Use the Progress indicator to track your session"
        }
    }
}