require "rubocop/rake_task"

namespace :test do
  desc "Run RuboCop style and lint checks"
  Rubocop::RakeTask.new(:rubocop) do |t|
    t.options = ["--rails"]
  end
end
