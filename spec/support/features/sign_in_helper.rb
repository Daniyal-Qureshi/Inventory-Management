module SignInHelper
  def sign_in
    t('layouts.application.sign_in')
  end

  def attempt_code(code)
    fill_in t('helpers.label.session.access_code'), with: code
    click_on t('helpers.submit.session.submit')
  end
end

RSpec.configure do |config|
  config.include SignInHelper, type: :feature
end
