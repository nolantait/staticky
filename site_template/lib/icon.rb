# frozen_string_literal: true

class Icon < Protos::Component
  include Protos::Icon

  SIZES = {
    xs: "w-3 h-3",
    sm: "w-4 h-4",
    md: "w-6 h-6",
    lg: "w-8 h-8",
    xl: "w-12 h-12"
  }.freeze

  DIMENSION = {
    xs: 12,
    sm: 14,
    md: 16,
    lg: 20,
    xl: 28
  }.freeze

  param :name, reader: false
  option :size, reader: false, default: -> { :md }
  option :variant, reader: false, default: -> { :solid }

  def view_template
    icon(@name, variant: @variant, **attrs)
  end

  private

  def default_attrs
    {
      width: DIMENSION[@size],
      height: DIMENSION[@size]
    }
  end

  def theme
    {
      container: SIZES[@size]
    }
  end
end
