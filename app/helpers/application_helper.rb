# frozen_string_literal: true

module ApplicationHelper
  def title(text = nil)
    content_for(:title) { text || t('.title') }
  end

  def nav(active:)
    @active_nav = active # rubocop:disable Rails/HelperInstanceVariable
  end

  def active_nav?(key)
    @active_nav == key # rubocop:disable Rails/HelperInstanceVariable
  end
end
