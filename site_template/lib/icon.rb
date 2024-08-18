# frozen_string_literal: true

class Icon < Component
  param :name, reader: false
  option :variant, reader: false, default: -> {}
  option :size, default: -> { :md }, reader: false

  def template
    div(**attrs) do
      render Protos::Icon.heroicon(@name, variant:)
    end
  end

  private

  def variant
    @variant || {
      xs: :micro,
      sm: :mini,
      md: :solid,
      lg: :solid
    }.fetch(@size)
  end

  def size
    {
      xs: "w-3 h-3",
      sm: "w-4 h-4",
      md: "w-5 h-5",
      lg: "w-7 h-7"
    }.fetch(@size)
  end

  def theme
    {
      container: tokens(size, "opacity-90", "inline-block")
    }
  end
end
