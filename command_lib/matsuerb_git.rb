# frozen_string_literal: true

require 'minigit'

# Wraps the MiniGit operations shared by the commands/ that automate
# periodic Matsue.rb hackathon housekeeping (create-matsuerb,
# finish-matsuerb-schedule): checking out a dedicated branch and
# committing a single file, both exiting on failure instead of raising.
module MatsuerbGit
  def self.checkout_branch(git, branch_name)
    git.checkout(b: branch_name)
  rescue MiniGit::GitError
    exit(1)
  end

  def self.commit(git, relative_path, message)
    git.add(relative_path)
    git.commit({ m: message }, relative_path)
  rescue MiniGit::GitError
    exit(1)
  end
end
