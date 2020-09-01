FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    price factory: :amount
  end

  factory :amount, class: Money do
    skip_create
    initialize_with { new(cents, currency) }

    transient do
      cents { 0 }
      currency { 'USD' }
    end

    trait :small do
      cents { 499 }
    end

    trait :medium do
      cents { 1299 }
    end

    trait :large do
      cents { 3299 }
    end
  end
end
