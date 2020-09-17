# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  delegate_all

  def self.set_jbuilder(&block)
    define_method :to_jbuilder do
      return unless object
      instance_eval(&block)
    end
  end
end
