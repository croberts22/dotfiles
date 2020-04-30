copr() {
    git checkout develop
    git pull
    git fetch origin +refs/pull/$1/merge:
    git checkout -qf FETCH_HEAD
}

upload_music_to_tenebrae() {
  scp -r $1 spacepyro@tenebrae:music/
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
