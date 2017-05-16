# frozen_string_literal: true

require 'gender_form_builder'

module ApplicationHelper
  def macro(partial, **vars, &block)
    if block_given?
      render layout: partial, locals: vars, &block
    else
      render partial: partial, locals: vars
    end
  end

  HOVER_ICO_TYPES = { warn: '!', info: '?', dict: '✱' }.freeze

  def hover_ico(type, &block)
    unless HOVER_ICO_TYPES.keys.include?(type)
      raise ArgumentError, "unknown type, must be one of #{HOVER_ICO_TYPES.keys}"
    end

    macro('hover_ico', type: type, &block)
  end

  BANNER_TYPES = {
    success: %w(✔ Success!),
    err:     %w(✖ Oops!),
    warn:    %w(! Warning!),
    info:    %w(? FYI...),
    timer:   %w(⌛ Tick-tock...)
  }.freeze

  def banner(type, &block)
    type = banner_devise_convert(type)

    unless BANNER_TYPES.keys.include?(type)
      raise ArgumentError, "unknown type, must be one of #{BANNER_TYPES.keys}"
    end

    macro(
      'custom_banner',
      type: type,
      ico: BANNER_TYPES[type][0],
      title: BANNER_TYPES[type][1],
      &block
    )
  end

  def user_handle(user, clan_sym = true)
    render 'user_handle', user: user, clan_sym: clan_sym
  end

  def cws_local_time(time = Time.now, options = nil)
    local_time(time, options ? options : :long)
  end

  def cws_local_date(time = Time.now, options = nil)
    local_time(time, options ? options : :long_notime)
  end

  # Transforms the route shorthand controller#action into a proper url.
  # @param [String] route the route in controller#action form
  # @return [String] the url
  def route_path(route)
    controller, action = route.split('#')
    url_for(action: action, controller: controller)
  end

  private

  BANNER_DEVISE_CORRL = {
    error:  :err,
    alert:  :err,
    notice: :info
  }.freeze

  def banner_devise_convert(type)
    BANNER_DEVISE_CORRL[type] || type
  end
end
