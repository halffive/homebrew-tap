class ChronosCli < Formula
  desc "Manage Chronos schedules, jobs and executions from the terminal"
  homepage "https://chronos.sh"
  # The chronos-cli release workflow rewrites url and sha256 for every stable release.
  url "https://github.com/halffive/chronos-cli/archive/refs/tags/v0.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"
  head "https://github.com/halffive/chronos-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X chronos.sh/cli/internal/build.version=#{version}
      -X chronos.sh/cli/internal/build.builtAt=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"chronos", ldflags:), "./cmd/chronos"
    generate_completions_from_executable(bin/"chronos", shell_parameter_format: :cobra)
  end

  test do
    info = JSON.parse(shell_output("#{bin}/chronos version --json"))
    assert_equal version.to_s, info["version"]
  end
end
