import QtQuick
import QtQuick.Controls
import qs.Common
import qs.Widgets
import qs.Modules.Plugins
import "./dms-common"

PluginSettings {
    id: root
    pluginId: "breathing"

    readonly property var exercises: [
        { name: I18n.tr("Deep Breathing"), id: "deep" },
        { name: I18n.tr("4-7-8 Breathing"), id: "478" },
        { name: I18n.tr("Box Breathing"), id: "box" },
        { name: I18n.tr("Equal Breathing"), id: "equal" },
        { name: I18n.tr("Resonance"), id: "resonance" },
        { name: I18n.tr("Alternate Nostril"), id: "alternate" }
    ]

    SettingsCard {
        SectionTitle { text: I18n.tr("General"); icon: "tune" }

        ToggleSetting {
            settingKey: "enableAutoStart"
            label: I18n.tr("Auto-start Exercise")
            description: I18n.tr("Start exercise automatically on login.")
            defaultValue: false
        }

        SelectionSetting {
            settingKey: "autoStartExercise"
            label: I18n.tr("Default Exercise")
            description: I18n.tr("Exercise to start automatically.")
            options: [
                { label: I18n.tr("Deep Breathing"), value: "0" },
                { label: I18n.tr("4-7-8 Breathing"), value: "1" },
                { label: I18n.tr("Box Breathing"), value: "2" },
                { label: I18n.tr("Equal Breathing"), value: "3" },
                { label: I18n.tr("Resonance"), value: "4" },
                { label: I18n.tr("Alternate Nostril"), value: "5" }
            ]
            defaultValue: "0"
        }

        SliderSetting {
            settingKey: "defaultDuration"
            label: I18n.tr("Default Duration")
            description: I18n.tr("Session length for auto-started exercises (minutes).")
            minimum: 1
            maximum: 30
            defaultValue: 5
        }
    }

    SettingsCard {
        SectionTitle { text: I18n.tr("Feedback"); icon: "vibration" }

        ToggleSetting {
            settingKey: "enableHaptic"
            label: I18n.tr("Haptic Feedback")
            description: I18n.tr("Vibrate on phase transitions.")
            defaultValue: true
        }
        
        ToggleSetting {
            settingKey: "enableSound"
            label: I18n.tr("Sound Cues")
            description: I18n.tr("Play subtle sounds on phase transitions.")
            defaultValue: true
        }

        ToggleSetting {
            settingKey: "enableTwoTone"
            label: I18n.tr("Two-Tone Model")
            description: I18n.tr("Play a distinct falling pitch during exhale (default plays rising pitch on inhale only).")
            defaultValue: false
        }

        SelectionSetting {
            settingKey: "soundType"
            label: I18n.tr("Sound Cue Type")
            description: I18n.tr("Select which sound cue to play during exercises.")
            options: [
                { label: I18n.tr("Singing Bowl Chime (Default)"), value: "chime" },
                { label: I18n.tr("Ambient Meditation Music"), value: "meditation" },
                { label: I18n.tr("Custom Sound File"), value: "custom" }
            ]
            defaultValue: "chime"
        }

        SliderSetting {
            settingKey: "defaultSoundVolume"
            label: I18n.tr("Default Volume")
            description: I18n.tr("Default volume for breathing sound cues.")
            defaultValue: 80
            minimum: 0
            maximum: 100
            unit: "%"
            leftIcon: "volume_down"
            rightIcon: "volume_up"
        }

        StringSetting {
            settingKey: "customSoundPath"
            label: I18n.tr("Custom Sound File")
            description: I18n.tr("Absolute path to custom audio. Only active when Sound Cue Type is set to Custom Sound File.")
            placeholder: "/home/user/sounds/my-sound.ogg"
            defaultValue: ""
        }
    }

    SettingsCard {
        SectionTitle { text: I18n.tr("Appearance"); icon: "palette" }

        SelectionSetting {
            settingKey: "animationStyle"
            label: I18n.tr("Animation Style")
            description: I18n.tr("Visual style of the breathing visualizer.")
            options: [
                { label: I18n.tr("Classic Card"), value: "classic" },
                { label: I18n.tr("Expanding Circle"), value: "circle" },
                { label: I18n.tr("Flowing Wave"), value: "wave" },
                { label: I18n.tr("Pulsating Glow"), value: "pulse" }
            ]
            defaultValue: "pulse"
        }
    }

    SettingsCard {
        SectionTitle { text: I18n.tr("Behavior"); icon: "settings" }

        ToggleSetting {
            settingKey: "showHints"
            label: I18n.tr("Show Hints")
            description: I18n.tr("Display helpful usage tips and shortcuts at the bottom of the popout.")
            defaultValue: true
        }
    }

    PluginAbout {
        repoUrl: "https://github.com/hthienloc/dms-breathing"
    }
}
