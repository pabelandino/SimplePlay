//
//  L10n.swift
//  LvoqPlayback
//

import Foundation

/// Type-safe access to `Localizable.xcstrings`. Keep keys grouped by feature.
/// To add a language: extend `AppLocale`, fill this catalog, and add `knownRegions`.
enum L10n {
    private static let table = "Localizable"

    private static func text(_ key: String) -> String {
        String(
            localized: String.LocalizationValue(key),
            table: table,
            locale: AppLocalization.resolvedLocale
        )
    }

    private static func format(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: text(key), locale: AppLocalization.resolvedLocale, arguments: arguments)
    }

    enum App {
        static var displayName: String { text("app.display_name") }
        static var companionName: String { text("app.companion_name") }
        static var untitledProject: String { text("app.untitled_project") }
    }

    enum Common {
        static var done: String { text("common.done") }
        static var cancel: String { text("common.cancel") }
        static var close: String { text("common.close") }
        static var delete: String { text("common.delete") }
        static var ok: String { text("common.ok") }
        static var retry: String { text("common.retry") }
        static var refresh: String { text("common.refresh") }
        static var change: String { text("common.change") }
        static var play: String { text("common.play") }
        static var pause: String { text("common.pause") }
        static var stop: String { text("common.stop") }
        static var save: String { text("common.save") }
        static var open: String { text("common.open") }
        static var error: String { text("common.error") }
        static var importLabel: String { text("common.import") }
        static var new: String { text("common.new") }
        static var trigger: String { text("common.trigger") }
        static var original: String { text("common.original") }
        static var fit: String { text("common.fit") }
        static var hide: String { text("common.hide") }
    }

    enum Settings {
        static var title: String { text("settings.title") }
        static var subtitle: String { text("settings.subtitle") }
        static var languageSection: String { text("settings.language.section") }
        static var languageFooter: String { text("settings.language.footer") }
        static var languageSystem: String { text("settings.language.option.system") }

        static func languageName(for locale: AppLocale) -> String {
            text(locale.settingsNameKey)
        }
    }

    enum File {
        static var saveProject: String { text("file.save_project") }
        static var saveProjectAs: String { text("file.save_project_as") }
        static var openProject: String { text("file.open_project") }
        static var openProjectShort: String { text("file.open_project_short") }
        static var newProject: String { text("file.new_project") }
        static var newProjectEllipsis: String { text("file.new_project_ellipsis") }
        static var resetSession: String { text("file.reset_session") }
        static var resetSessionEllipsis: String { text("file.reset_session_ellipsis") }
        static var projectSession: String { text("file.project_session") }
        static var resetEverything: String { text("dialog.reset_everything") }
        static var resetSessionMessage: String { text("dialog.reset_session_message") }
        static var saveAndContinue: String { text("dialog.save_and_continue") }
        static var continueWithoutSaving: String { text("dialog.continue_without_saving") }
        static var newProjectMessage: String { text("dialog.new_project_message") }
        static var deleteSection: String { text("dialog.delete_section") }
        static var deleteSectionMessage: String { text("dialog.delete_section_message") }
        static var sessionFootnote: String { text("session.footnote") }

        static func deleteNamed(_ name: String) -> String {
            format("dialog.delete_named", name)
        }
    }

    enum Transport {
        static var menu: String { text("transport.menu") }
        static var undo: String { text("edit.undo") }
        static var redo: String { text("edit.redo") }
        static var loopSelection: String { text("transport.loop_selection") }
    }

    enum Audio {
        static var output: String { text("audio.output") }
        static var interface: String { text("audio.interface") }
        static var outputPair: String { text("audio.output_pair") }
        static var sampleRate: String { text("audio.sample_rate") }
        static var sampleRateFootnote: String { text("audio.sample_rate_footnote") }
        static var refreshDevices: String { text("audio.refresh_devices") }
        static var systemDefault: String { text("audio.system_default") }
        static var builtInSpeaker: String { text("audio.built_in_speaker") }
        static var masterVolume: String { text("audio.master_volume") }
        static var soundLevels: String { text("audio.sound_levels") }

        static func sampleRateMatched(_ rate: String) -> String {
            format("import.notice_sample_rate", rate)
        }

        static func clipRateMismatch(clipHz: Int, projectHz: Int) -> String {
            format("error.sample_rate_mismatch", clipHz, projectHz)
        }
    }

    enum Pitch {
        static var title: String { text("pitch.title") }
        static var label: String { text("pitch.label") }
        static var empty: String { text("pitch.empty") }
        static var footnote: String { text("pitch.footnote") }
        static var track: String { text("pitch.track") }
        static var reset: String { text("pitch.reset") }
        static var help: String { text("pitch.help") }
        static var importHint: String { text("pitch.import_hint") }
        static var originalOff: String { text("pitch.original_off") }
        static var originalZero: String { text("pitch.original_zero") }
        static var minusFive: String { text("pitch.minus_five") }
        static var plusFive: String { text("pitch.plus_five") }
    }

    enum Section {
        static var markers: String { text("section.markers") }
        static var defaultName: String { text("section.default_name") }
        static var selectedMarker: String { text("section.selected_marker") }
        static var markerName: String { text("section.marker_name") }
        static var name: String { text("section.name") }
        static var padMapping: String { text("section.pad_mapping") }
        static var assignMIDI: String { text("section.assign_midi") }
        static var assignMIDIPad: String { text("section.assign_midi_pad") }
        static var deleteMarker: String { text("section.delete_marker") }
        static var range: String { text("section.range") }
        static var lane: String { text("section.lane") }
        static var dragToCreate: String { text("section.drag_to_create") }
        static var phoneHint: String { text("section.phone_hint") }
        static var playFootnote: String { text("section.play_footnote") }
        static var creationHintIOS: String { text("section.creation_hint_ios") }
        static var creationHintMac: String { text("section.creation_hint_mac") }
        static var createHintTouch: String { text("section.create_hint_touch") }
        static var createHintDrag: String { text("section.create_hint_drag") }
        static var dragHelp: String { text("section.drag_help") }
        static var modeRepeat: String { text("section.mode.repeat") }
        static var modeContinue: String { text("section.mode.continue") }
        static var modeContinueNext: String { text("section.mode.continue_next") }
        static var modeOneShot: String { text("section.mode.one_shot") }

        static var presets: [String] {
            [
                text("section.preset.verse"),
                text("section.preset.verse1"),
                text("section.preset.verse2"),
                text("section.preset.pre_chorus"),
                text("section.preset.chorus"),
                text("section.preset.bridge"),
                text("section.preset.outro"),
            ]
        }

        static func nextQueued(_ name: String) -> String {
            format("section.next_queued", name)
        }

        static func repeatOnce(_ name: String) -> String {
            format("section.repeat_once", name)
        }
    }

    enum Lyric {
        static var slide: String { text("lyric.slide") }
        static var notAssigned: String { text("lyric.not_assigned") }
        static var assign: String { text("lyric.assign") }
        static var change: String { text("lyric.change") }
        static var cardsFootnote: String { text("lyric.cards_footnote") }
        static var assignSlide: String { text("lyric.assign_slide") }
        static var clearLink: String { text("lyric.clear_link") }
        static var loading: String { text("lyric.loading") }
        static var loadingShort: String { text("lyric.loading_short") }
        static var notFound: String { text("lyric.not_found") }
        static var notFoundBody: String { text("lyric.not_found_body") }
        static var notOnNetwork: String { text("lyric.not_on_network") }
        static var unavailable: String { text("lyric.unavailable") }
        static var assignEachSection: String { text("lyric.assign_each_section") }
        static var assignEachCard: String { text("lyric.assign_each_card") }
        static var assignPadsHelp: String { text("lyric.assign_pads_help") }
        static var assignSections: String { text("lyric.assign_sections") }
        static var assignSectionsShort: String { text("lyric.assign_sections_short") }
        static var slideShort: String { text("lyric.slide_short") }
        static var noSlide: String { text("lyric.no_slide") }
        static var linkedSlide: String { text("lyric.linked_slide") }

        static func linkToSection(_ name: String) -> String {
            format("lyric.link_to_section", name)
        }

        static func tapCard(_ name: String) -> String {
            format("lyric.tap_card", name)
        }

        static func slidesCount(_ count: Int, title: String) -> String {
            format("lyric.slides_count", count, title)
        }

        static func header(section: String, title: String, count: Int) -> String {
            format("lyric.header_with_catalog", section, title, count)
        }

        static func slideNumber(_ number: Int) -> String {
            format("lyric.slide_n", number)
        }

        static func slideNumberPreview(_ number: Int, preview: String) -> String {
            format("lyric.slide_n_preview", number, preview)
        }

        static func usedBy(_ names: String) -> String {
            format("lyric.used_by", names)
        }

        static func accessibilitySlide(_ number: Int, text: String) -> String {
            format("lyric.a11y.slide", number, text)
        }

        static func accessibilitySelected(_ number: Int, names: String, text: String) -> String {
            format("lyric.a11y.selected", number, names, text)
        }

        static func accessibilityUsed(_ number: Int, names: String, text: String) -> String {
            format("lyric.a11y.used", number, names, text)
        }

        static func accessibilityChange(_ name: String) -> String {
            format("lyric.a11y.change", name)
        }

        static func accessibilityAssign(_ name: String) -> String {
            format("lyric.a11y.assign", name)
        }
    }

    enum MIDI {
        static var input: String { text("midi.input") }
        static var allInputs: String { text("midi.all_inputs") }
        static var refresh: String { text("midi.refresh") }
        static var assigning: String { text("midi.assigning") }
        static var listening: String { text("midi.listening") }
        static var listeningAssignment: String { text("midi.listening_assignment") }
        static var createMarkersFirst: String { text("midi.create_markers_first") }
        static var waiting: String { text("midi.waiting") }
        static var pressPad: String { text("midi.press_pad") }
        static var listeningAll: String { text("midi.listening_all") }
        static var label: String { text("midi.label") }
        static var stopAssigning: String { text("midi.stop_assigning") }
        static var assignShort: String { text("midi.assign_short") }
        static var selectDevice: String { text("midi.select_device") }
        static var refreshHelp: String { text("midi.refresh_help") }
        static var mapping: String { text("midi.mapping") }
        static var playing: String { text("midi.playing") }
        static var queued: String { text("midi.queued") }
        static var deviceShort: String { text("midi.device_short") }

        static func playHelp(section: String, assignment: String) -> String {
            format("midi.play_help", section, assignment)
        }

        static func playingHelp(_ name: String) -> String {
            format("midi.playing_help", name)
        }

        static func queuedHelp(_ name: String) -> String {
            format("midi.queued_help", name)
        }

        static func repeatHelp(_ name: String) -> String {
            format("midi.repeat_help", name)
        }

        static func assignFor(_ name: String) -> String {
            format("midi.assign_for", name)
        }

        static func lastInput(_ debug: String) -> String {
            format("midi.last_input", debug)
        }

        static func mapped(section: String, assignment: String) -> String {
            format("midi.mapped", section, assignment)
        }

        static func connected(_ name: String) -> String {
            format("midi.connected", name)
        }

        static func pressForSection(_ name: String) -> String {
            format("midi.press_for_section", name)
        }

        static func note(_ note: Int, channel: Int) -> String {
            format("midi.note", note, channel)
        }

        static func controlChange(_ number: Int, channel: Int) -> String {
            format("midi.cc", number, channel)
        }
    }

    enum Selection {
        static var duration: String { text("selection.duration") }
        static var start: String { text("selection.start") }
        static var end: String { text("selection.end") }
        static var loop: String { text("selection.loop") }
        static var empty: String { text("selection.empty") }
    }

    enum Snap {
        static var title: String { text("snap.title") }
        static var enable: String { text("snap.enable") }
        static var interval: String { text("snap.interval") }
    }

    enum Timeline {
        static var time: String { text("timeline.time") }
        static var zoom: String { text("timeline.zoom") }
        static var tracks: String { text("timeline.tracks") }
        static var moveClips: String { text("timeline.move_clips") }
        static var selectClips: String { text("timeline.select_clips") }
        static var splitHelp: String { text("timeline.split_help") }
        static var trimHelp: String { text("timeline.trim_help") }
        static var splitClip: String { text("timeline.split_clip") }
        static var addTrack: String { text("timeline.add_track") }
        static var emptyTrack: String { text("timeline.empty_track") }
        static var importAudioEllipsis: String { text("timeline.import_audio_ellipsis") }
        static var expandLanes: String { text("timeline.expand_lanes") }
        static var stackStems: String { text("timeline.stack_stems") }
        static var showEveryLane: String { text("timeline.show_every_lane") }
        static var stackCompact: String { text("timeline.stack_compact") }
        static var allStems: String { text("timeline.all_stems") }
        static var hideScale: String { text("timeline.hide_scale") }
        static var showScale: String { text("timeline.show_scale") }
        static var emptyShort: String { text("timeline.empty_short") }
        static var add: String { text("timeline.add") }
        static var importTrack: String { text("timeline.import_track") }
        static var stack: String { text("timeline.stack") }
        static var expand: String { text("timeline.expand") }
        static var dropPlayhead: String { text("timeline.drop_playhead") }
        static var dropStems: String { text("timeline.drop_stems") }

        static func ofDuration(_ duration: String) -> String {
            format("timeline.of_duration", duration)
        }

        static func trackCount(_ count: Int) -> String {
            format("timeline.track_count", count)
        }

        static func trackHeight(_ percent: Int) -> String {
            format("timeline.track_height", percent)
        }
    }

    enum Import {
        static var audio: String { text("import.audio") }
        static var audioFiles: String { text("import.audio_files") }
        static var folder: String { text("import.folder") }
        static var help: String { text("import.help") }
        static var sessionHelp: String { text("import.session_help") }
        static var drop: String { text("import.drop") }
        static var formats: String { text("import.formats") }
        static var dragStems: String { text("import.drag_stems") }
        static var orToolbar: String { text("import.or_toolbar") }

        static func limit(imported: Int, maximum: Int) -> String {
            format("import.limit", imported, maximum)
        }
    }

    enum Mixer {
        static var title: String { text("mixer.title") }
        static var close: String { text("mixer.close") }
        static var empty: String { text("mixer.empty") }
        static var group: String { text("mixer.group") }
        static var main: String { text("mixer.main") }
        static var output: String { text("mixer.output") }
        static var hideVolume: String { text("mixer.hide_volume") }
        static var showVolume: String { text("mixer.show_volume") }

        static func volumePercent(_ percent: Int) -> String {
            format("mixer.volume_percent", percent)
        }
    }

    enum Accessibility {
        static var queueAudio: String { text("a11y.queue_audio") }
        static var trackVolume: String { text("a11y.track_volume") }

        static func playSection(_ name: String) -> String {
            format("a11y.play_section", name)
        }

        static var trackReorder: String { text("track.reorder_help") }
        static var splitHint: String { text("clip.split_hint") }
    }

    enum Errors {
        static var deviceSelection: String { text("error.device_selection") }
        static var engineStart: String { text("error.engine_start") }
        static var noPlayable: String { text("error.no_playable") }
        static var playbackUnavailable: String { text("error.playback_unavailable") }
        static var invalidPackage: String { text("error.invalid_package") }
        static var missingManifest: String { text("error.missing_manifest") }
        static var unsupportedFormat: String { text("error.unsupported_format") }
        static var unreadableFile: String { text("error.unreadable_file") }
        static var emptySelection: String { text("error.empty_selection") }
        static var storageUnavailable: String { text("error.storage_unavailable") }
        static var invalidArchive: String { text("error.invalid_archive") }
        static var corruptManifest: String { text("error.corrupt_manifest") }
        static var emptyResponse: String { text("error.empty_response") }
        static var noHost: String { text("error.no_host") }
        static var unexpectedResponse: String { text("error.unexpected_response") }

        static func clipLoad(name: String, reason: String) -> String {
            format("error.clip_load", name, reason)
        }

        static func missingAudio(_ name: String) -> String {
            format("error.missing_audio", name)
        }

        static func unsupportedVersion(_ version: Int) -> String {
            format("error.unsupported_version", version)
        }

        static func corruptAsset(_ name: String) -> String {
            format("error.corrupt_asset", name)
        }
    }

    enum Panel {
        static var save: String { text("panel.save") }
        static var saveTitle: String { text("panel.save_title") }
        static var open: String { text("panel.open") }
        static var openTitle: String { text("panel.open_title") }
        static var importLabel: String { text("panel.import") }
        static var importFilesTitle: String { text("panel.import_files_title") }
        static var importFolderTitle: String { text("panel.import_folder_title") }
    }

    enum TrackRole {
        static var click: String { text("role.click") }
        static var cue: String { text("role.cue") }
        static var guide: String { text("role.guide") }
        static var countIn: String { text("role.count_in") }
        static var leadVocal: String { text("role.lead_vocal") }
        static var backingVocal: String { text("role.backing_vocal") }
        static var electricGuitar: String { text("role.electric_guitar") }
        static var acousticGuitar: String { text("role.acoustic_guitar") }
        static var bass: String { text("role.bass") }
        static var drums: String { text("role.drums") }
        static var keys: String { text("role.keys") }
        static var piano: String { text("role.piano") }
        static var synth: String { text("role.synth") }
        static var strings: String { text("role.strings") }
        static var brass: String { text("role.brass") }
        static var percussion: String { text("role.percussion") }
        static var loop: String { text("role.loop") }
        static var fx: String { text("role.fx") }
        static var unknown: String { text("role.unknown") }
    }
}
