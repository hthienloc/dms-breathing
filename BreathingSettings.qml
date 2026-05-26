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

        ToggleSetting {
            settingKey: "enableTwoTone"
            label: "Two-Tone Model"
            description: "Play a distinct falling pitch during exhale (default plays rising pitch on inhale only)."
            defaultValue: false
        }

        SelectionSetting {
            settingKey: "soundType"
            label: "Sound Cue Type"
            description: "Select which sound cue to play during exercises."
            options: [
                { label: "Singing Bowl Chime (Default)", value: "chime" },
                { label: "Ambient Meditation Music", value: "meditation" },
                { label: "Custom Sound File", value: "custom" }
            ]
            defaultValue: "chime"
        }

        SliderSetting {
            settingKey: "defaultSoundVolume"
            label: "Default Volume"
            description: "Default volume for breathing sound cues."
            defaultValue: 80
            minimum: 0
            maximum: 100
            unit: "%"
            leftIcon: "volume_down"
            rightIcon: "volume_up"
        }

        StringSetting {
            settingKey: "customSoundPath"
            label: "Custom Sound File"
            description: "Absolute path to custom audio. Only active when Sound Cue Type is set to Custom Sound File."
            placeholder: "/home/user/sounds/my-sound.ogg"
            defaultValue: ""
        }
    }

    SettingsCard {
        SectionTitle { text: "Appearance" }

        SelectionSetting {
            settingKey: "animationStyle"
            label: "Animation Style"
            description: "Visual style of the breathing visualizer."
            options: [
                { label: "Classic Card", value: "classic" },
                { label: "Expanding Circle", value: "circle" },
                { label: "Flowing Wave", value: "wave" },
                { label: "Pulsating Glow", value: "pulse" }
            ]
            defaultValue: "pulse"
        }
    }

    SettingsCard {
        SectionTitle { text: "Behavior" }

        ToggleSetting {
            settingKey: "showHints"
            label: "Show Hints"
            description: "Display helpful usage tips and shortcuts at the bottom of the popout."
            defaultValue: true
        }
    }
}
