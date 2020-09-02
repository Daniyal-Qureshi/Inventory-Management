module I18nMacros
  def t(*args)
    I18n.translate!(*args)
  end
end

RSpec.configure do |config|
  config.include I18nMacros, type: :feature
end
