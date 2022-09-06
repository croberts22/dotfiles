profile_zsh() {
  shell=${1-$SHELL}
  ZPROF=true $shell -i -c exit
}

pi() {
    pod install
}

set_xcode_parallelization() {
    echo "Setting parallelization of Xcode tasks to ${1} task."
    defaults write com.apple.dt.xcodebuild PBXNumberOfParallelBuildSubtasks $1
    defaults write com.apple.dt.xcodebuild IDEBuildOperationMaxNumberOfConcurrentCompileTasks $1
    defaults write com.apple.dt.Xcode PBXNumberOfParallelBuildSubtasks $1
    defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks $1
}

auto_set_xcode_parallelization() {
    set_xcode_parallelization `sysctl -n hw.ncpu`
}

clear_xcode_parallelization() {
    defaults delete com.apple.dt.xcodebuild PBXNumberOfParallelBuildSubtasks
    defaults delete com.apple.dt.xcodebuild IDEBuildOperationMaxNumberOfConcurrentCompileTasks
    defaults delete com.apple.dt.Xcode PBXNumberOfParallelBuildSubtasks
    defaults delete com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks
}

switch_xcode() {
    sudo xcode-select -s /Applications/$1.app/Contents/Developer; export DEVELOPER_DIR=$(sudo xcode-select --print-path)
}

update_fastlane() {
  bundle update fastlane
  git add Gemfile.lock
  git commit -m "Updating fastlane."
}

clear_all_derived_data() {
    echo "Requesting a cleanup of compiled code...🧹"
    echo "Clearing org.carthage.CarthageKit..."
    rm -rf ~/Library/Caches/org.carthage.CarthageKit
    echo "Clearing DerivedData..."
    rm -rf ~/Library/Developer/Xcode/DerivedData
    echo "Done! 💫"
}

fix_swiftui_sims() {
    echo "Fixing SwiftUI previews from making your computer outrageously hot when idle..."
    cd ~/Library/Developer/Xcode/UserData/Previews/Simulator\ Devices/
    find . -name com.apple.suggestions.plist -exec plutil -replace SuggestionsAppLibraryEnabled -bool NO {} ";"
    cd -

    echo "Fixing Simulators from also making your computer outrageously hot when idle..."
    cd ~/Library/Developer/CoreSimulator/Devices
    find . -name com.apple.suggestions.plist -exec plutil -replace SuggestionsAppLibraryEnabled -bool NO {} ";"
    cd -

    echo "Done! ❄️"
}

reset_swiftui_previews() {
    echo "Resetting simulators for SwiftUI previews... 📱"
    xcrun simctl --set previews delete all
    echo "Simulators are reset. ✅"
}
