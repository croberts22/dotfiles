copr() {
    git checkout develop
    git pull
    git fetch origin +refs/pull/$1/merge:
    git checkout -qf FETCH_HEAD
}

upload_music_to_tenebrae() {
  scp -r $1 spacepyro@tenebrae:music/
}
