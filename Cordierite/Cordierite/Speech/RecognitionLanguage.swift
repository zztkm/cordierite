import Foundation
import Speech

enum RecognitionLanguageResolver {
    static func locale(for option: RecognitionLanguageOption) -> Locale {
        switch option {
        case .system:
            systemLocale()
        case .english:
            Locale(identifier: "en-US")
        case .japanese:
            Locale(identifier: "ja-JP")
        }
    }

    static func resolvedLocale(for option: RecognitionLanguageOption) async -> Locale? {
        await SpeechTranscriber.supportedLocale(equivalentTo: locale(for: option))
    }

    /// User-facing label including the resolved locale for System Default.
    static func menuLabel(for option: RecognitionLanguageOption, resolvedLocale: Locale?) -> String {
        guard option == .system, let resolvedLocale else {
            return option.label
        }
        return "System Default (\(resolvedLocale.identifier.replacingOccurrences(of: "_", with: "-")))"
    }

    private static func systemLocale() -> Locale {
        // preferredLanguages comes from System Settings and stays aligned with the
        // user's language list. Locale.current is fixed at process launch on macOS
        // and can fall back to the app's development region (en) when the app
        // bundle does not localize the user's language.
        if let preferred = Locale.preferredLanguages.first {
            return Locale(identifier: preferred)
        }
        return Locale.autoupdatingCurrent
    }
}
