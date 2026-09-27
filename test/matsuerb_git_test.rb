# frozen_string_literal: true

require 'test_helper'
require 'matsuerb_git'

class FakeGit
  attr_reader :calls

  def initialize(fail_with: nil)
    @calls = []
    @fail_with = fail_with
  end

  def checkout(**kwargs)
    raise @fail_with if @fail_with

    @calls << [:checkout, kwargs]
  end

  def add(path)
    raise @fail_with if @fail_with

    @calls << [:add, path]
  end

  def commit(opts, path)
    raise @fail_with if @fail_with

    @calls << [:commit, opts, path]
  end
end

describe 'MatsuerbGit.checkout_branch' do
  it 'checks out the given branch' do
    git = FakeGit.new
    MatsuerbGit.checkout_branch(git, 'chore/closed-r0809')
    _(git.calls).must_equal([[:checkout, { b: 'chore/closed-r0809' }]])
  end

  it 'exits with status 1 when the checkout fails' do
    git = FakeGit.new(fail_with: MiniGit::GitError.new)
    _(proc { MatsuerbGit.checkout_branch(git, 'chore/closed-r0809') }).must_raise(SystemExit)
  end
end

describe 'MatsuerbGit.commit' do
  it 'adds and commits the given path with the given message' do
    git = FakeGit.new
    MatsuerbGit.commit(git, 'content/schedule.html', 'chore: スケジュールを更新')
    _(git.calls).must_equal(
      [
        [:add, 'content/schedule.html'],
        [:commit, { m: 'chore: スケジュールを更新' }, 'content/schedule.html']
      ]
    )
  end

  it 'exits with status 1 when the commit fails' do
    git = FakeGit.new(fail_with: MiniGit::GitError.new)
    _(proc { MatsuerbGit.commit(git, 'content/schedule.html', 'msg') }).must_raise(SystemExit)
  end
end
