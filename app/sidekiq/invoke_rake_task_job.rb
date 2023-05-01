# frozen_string_literal: true

require "rake"

Rails.application.load_tasks

class InvokeRakeTaskJob
  include Sidekiq::Job

  def perform(*args)
    Rake::Task[args["task"]].execute
  end
end
