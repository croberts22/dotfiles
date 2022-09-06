profile_zsh() {
  shell=${1-$SHELL}
  ZPROF=true $shell -i -c exit
}

sf() {
    ./Pods/SwiftFormat/CommandLineTool/swiftformat $1
}

sl() {
    ./Pods/SwiftLint/swiftlint
}

pi() {
    pod install
}

extract_mp4_from_mkv() {
  arg=$1
  filename=${arg%.mkv}
  ffmpeg -i $filename.mkv -codec copy $filename.mp4
}

resize_video() {
  arg=$1
  filename=${arg%.mp4}
  ffmpeg -i $filename.mp4 -aspect 1280:960 -c copy $filename-resized-1920x960.mp4
}

delay_video() {
  arg=$1
  time_arg=$2
  filename=${arg%.mp4}
  delay=$2
  ffmpeg -i $filename.mp4 -itsoffset $2 -i $filename.mp4 -map 0:v -map 1:a -c copy $filename-delayed-$2.mp4
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

test_and_upload() {
  rm -rf build/Logs/Test
  xcodebuild -workspace $1 -scheme $2 -derivedDataPath build -destination 'platform=iOS Simulator,OS=13.4.1,name=iPhone 11' -enableCodeCoverage YES clean build test | xcpretty
  find build/Logs/Test -name "*.xcresult" | xargs -I % sh -c 'xcrun xccov view --report --json % > %.json'
  find build/Logs/Test -name "*xcresult*" -exec scp -r {} test_results ';'
  find test_results -maxdepth 1 -name "*.json" | sort -n | xargs -I % sh -c 'curl -v -H "Content-Type:multipart/form-data" -F "file=@%;type=application/json" localhost:3000/coverage_reports/'
  find test_results -maxdepth 1 -name "*.json" -exec mv {} test_results/archive ';'
  find test_results -maxdepth 1 -name "*.xcresult" -exec mv {} test_results/xcresult ';'
}
