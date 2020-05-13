# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    title { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence(word_count: 5) }
    price { Faker::Commerce.price }
    amount { Faker::Number.number(digits: 3) }
    category { Faker::Commerce.department(max: 1) }
  end
end
