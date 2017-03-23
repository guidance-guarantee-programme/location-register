class NotifyPensionGuidanceJob < ApplicationJob
  queue_as :default

  def perform
    PensionGuidanceApi.new.call
  end
end
