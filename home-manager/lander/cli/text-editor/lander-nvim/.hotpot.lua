return {
  build = {
    {atomic = true, verbose = true},
    {"fnl/**/*.fnl", true}
  },
  clean = true,
  compiler = {
    modules = {
      correlate = true
    }
  }
}
